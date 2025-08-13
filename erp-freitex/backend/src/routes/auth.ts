import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../lib/prisma';
import { authenticateToken, requireMaster } from '../middleware/auth';
import { LoginCredentials, AuthResponse, ApiResponse, AuthRequest, UserRole } from '../types';

const router = Router();

// Login
router.post('/login', async (req: Request, res: Response<ApiResponse<AuthResponse>>) => {
  try {
    const { email, password }: LoginCredentials = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email e senha são obrigatórios',
        data: null
      });
    }

    // Buscar usuário
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            planStatus: true,
            trialEndsAt: true,
            subscriptionEndsAt: true,
            isActive: true
          }
        }
      }
    });

    if (!user || !user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Credenciais inválidas',
        data: null
      });
    }

    // Verificar senha
    const isValidPassword = await bcrypt.compare(password, user.passwordHash);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Credenciais inválidas',
        data: null
      });
    }

    // Verificar se a empresa está ativa (se não for usuário master)
    if (user.role !== 'master' && user.company) {
      if (!user.company.isActive) {
        return res.status(403).json({
          success: false,
          message: 'Empresa inativa. Entre em contato com o suporte.',
          data: null
        });
      }

      // Verificar se o plano não expirou
      const now = new Date();
      if (user.company.planStatus === 'suspended' || 
          (user.company.subscriptionEndsAt && user.company.subscriptionEndsAt < now) ||
          (user.company.trialEndsAt && user.company.trialEndsAt < now)) {
        return res.status(403).json({
          success: false,
          message: 'Plano expirado. Renove sua assinatura para continuar.',
          data: null
        });
      }
    }

    // Atualizar último login
    await prisma.user.update({
      where: { id: user.id },
      data: { lastLogin: new Date() }
    });

    // Gerar tokens
    const accessToken = jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role as UserRole,
        companyId: user.companyId
      },
      process.env.JWT_SECRET!,
      { expiresIn: '1h' }
    );

    const refreshToken = jwt.sign(
      {
        userId: user.id,
        email: user.email
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    );

    const response: AuthResponse = {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role as UserRole,
        permissions: user.permissions,
        companyId: user.companyId || undefined,
        isActive: user.isActive,
        lastLogin: user.lastLogin || undefined,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      },
             company: user.company ? {
         id: user.company.id,
         name: user.company.name,
         email: '', // Campo obrigatório, mas não estamos buscando
         planType: 'basic' as any, // Campo obrigatório, mas não estamos buscando
         planStatus: user.company.planStatus as any,
         trialEndsAt: user.company.trialEndsAt || undefined,
         subscriptionEndsAt: user.company.subscriptionEndsAt || undefined,
         isActive: user.company.isActive,
         createdAt: new Date(), // Campo obrigatório, mas não estamos buscando
         updatedAt: new Date() // Campo obrigatório, mas não estamos buscando
       } : undefined,
      accessToken,
      refreshToken
    };

    return res.json({
      success: true,
      message: 'Login realizado com sucesso',
      data: response
    });

  } catch (error) {
    console.error('Erro no login:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor',
      data: null
    });
  }
});

// Refresh Token
router.post('/refresh', async (req: Request, res: Response<ApiResponse<{ accessToken: string }>>) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        message: 'Refresh token é obrigatório',
        data: null
      });
    }

    // Verificar refresh token
    const decoded = jwt.verify(refreshToken, process.env.JWT_SECRET!) as any;
    
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            planStatus: true,
            isActive: true
          }
        }
      }
    });

    if (!user || !user.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Token inválido',
        data: null
      });
    }

    // Verificar se a empresa está ativa (se não for usuário master)
    if (user.role !== 'master' && user.company && !user.company.isActive) {
      return res.status(403).json({
        success: false,
        message: 'Empresa inativa',
        data: null
      });
    }

    // Gerar novo access token
    const newAccessToken = jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role as UserRole,
        companyId: user.companyId
      },
      process.env.JWT_SECRET!,
      { expiresIn: '1h' }
    );

    return res.json({
      success: true,
      message: 'Token renovado com sucesso',
      data: { accessToken: newAccessToken }
    });

  } catch (error) {
    console.error('Erro no refresh token:', error);
    return res.status(401).json({
      success: false,
      message: 'Token inválido',
      data: null
    });
  }
});

// Logout
router.post('/logout', authenticateToken, async (req: AuthRequest, res: Response<ApiResponse>) => {
  try {
    // Em uma implementação mais robusta, você poderia invalidar o refresh token
    // Por enquanto, apenas retornamos sucesso
    return res.json({
      success: true,
      message: 'Logout realizado com sucesso',
      data: null
    });
  } catch (error) {
    console.error('Erro no logout:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor',
      data: null
    });
  }
});

// Verificar token (para verificar se o usuário está autenticado)
router.get('/verify', authenticateToken, async (req: AuthRequest, res: Response<ApiResponse>) => {
  try {
    return res.json({
      success: true,
      message: 'Token válido',
      data: {
        user: req.user,
        companyId: req.companyId
      }
    });
  } catch (error) {
    console.error('Erro na verificação do token:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor',
      data: null
    });
  }
});

// Criar usuário master (apenas para desenvolvimento)
router.post('/create-master', async (req: Request, res: Response<ApiResponse>) => {
  try {
    // Verificar se já existe um usuário master
    const existingMaster = await prisma.user.findFirst({
      where: { role: 'master' }
    });

    if (existingMaster) {
      return res.status(400).json({
        success: false,
        message: 'Usuário master já existe',
        data: null
      });
    }

    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Nome, email e senha são obrigatórios',
        data: null
      });
    }

    // Hash da senha
    const passwordHash = await bcrypt.hash(password, 12);

    // Criar usuário master
    const masterUser = await prisma.user.create({
      data: {
        name,
        email: email.toLowerCase(),
        passwordHash,
        role: 'master',
        isActive: true
      }
    });

    return res.status(201).json({
      success: true,
      message: 'Usuário master criado com sucesso',
      data: {
        id: masterUser.id,
        name: masterUser.name,
        email: masterUser.email,
        role: masterUser.role
      }
    });

  } catch (error) {
    console.error('Erro ao criar usuário master:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor',
      data: null
    });
  }
});

export default router;
