import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AuthRequest, User, ApiResponse } from '../types';
import { prisma } from '../lib/prisma';

export interface JWTPayload {
  userId: string;
  email: string;
  role: string;
  companyId?: string;
}

// Middleware para verificar token JWT
export const authenticateToken = async (
  req: AuthRequest,
  res: Response<ApiResponse>,
  next: NextFunction
) => {
  try {
    console.log('🔐 Middleware de autenticação - Iniciando...');
    console.log('📋 Headers recebidos:', req.headers);
    console.log('🌐 URL da requisição:', req.url);
    console.log('📝 Método da requisição:', req.method);
    
    const authHeader = req.headers['authorization'];
    console.log('🔑 Header Authorization:', authHeader);
    
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN
    console.log('🎫 Token extraído:', token ? `${token.substring(0, 20)}...` : 'Nenhum token');

    if (!token) {
      console.log('❌ Token não fornecido');
      return res.status(401).json({
        success: false,
        message: 'Token de acesso não fornecido',
        data: null
      });
    }

    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      throw new Error('JWT_SECRET não configurado');
    }

    const decoded = jwt.verify(token, jwtSecret) as JWTPayload;
    
    // Buscar usuário no banco com dados da empresa
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
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
        message: 'Usuário não encontrado ou inativo',
        data: null
      });
    }

    // Atualizar último login
    await prisma.user.update({
      where: { id: user.id },
      data: { lastLogin: new Date() }
    });

    req.user = user as User;
    req.companyId = user.companyId || undefined;

    console.log('✅ Autenticação bem-sucedida!');
    console.log('👤 Usuário:', user.name, `(${user.role})`);
    console.log('🏢 Company ID:', user.companyId || 'Nenhum');
    
    return next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({
        success: false,
        message: 'Token inválido',
        data: null
      });
    }

    console.error('Erro na autenticação:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno na autenticação',
      data: null
    });
  }
};

// Middleware para verificar permissões específicas
export const requireRole = (roles: string[]) => {
  return (req: AuthRequest, res: Response<ApiResponse>, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado',
        data: null
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Acesso negado. Permissão insuficiente.',
        data: null
      });
    }

    return next();
  };
};

// Middleware para verificar se é usuário master
export const requireMaster = requireRole(['master']);

// Middleware para verificar se é admin ou master
export const requireAdmin = requireRole(['master', 'admin']);

// Middleware para verificar se tem companyId
export const requireCompany = (
  req: AuthRequest,
  res: Response<ApiResponse>,
  next: NextFunction
) => {
  if (!req.companyId) {
    return res.status(400).json({
      success: false,
      message: 'Company ID é obrigatório para esta operação',
      data: null
    });
  }

  return next();
};
