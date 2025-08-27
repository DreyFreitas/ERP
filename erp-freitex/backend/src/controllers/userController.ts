import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';
import bcrypt from 'bcryptjs';

interface CreateUserData {
  name: string;
  email: string;
  password: string;
  role: string;
  companyId: string;
  permissions?: any;
}

interface UpdateUserData {
  name?: string;
  email?: string;
  password?: string;
  role?: string;
  permissions?: any;
  isActive?: boolean;
}

export const userController = {
  // Listar todos os usuários (masters e por empresa)
  async listAllUsers(req: Request, res: Response<ApiResponse>) {
    try {
      const users = await prisma.user.findMany({
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          permissions: true,
          isActive: true,
          lastLogin: true,
          createdAt: true,
          updatedAt: true,
          company: {
            select: {
              id: true,
              name: true,
              email: true
            }
          }
        },
        orderBy: [
          { role: 'asc' }, // Masters primeiro
          { createdAt: 'desc' }
        ]
      });

      return res.json({
        success: true,
        message: 'Usuários listados com sucesso',
        data: users
      });
    } catch (error) {
      console.error('Erro ao listar usuários:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Listar usuários de uma empresa
  async listUsersByCompany(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = req.params;

      // Verificar se a empresa existe
      const company = await prisma.company.findUnique({
        where: { id: companyId }
      });

      if (!company) {
        return res.status(404).json({
          success: false,
          message: 'Empresa não encontrada',
          data: null
        });
      }

      const users = await prisma.user.findMany({
        where: { companyId },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          permissions: true,
          isActive: true,
          lastLogin: true,
          createdAt: true,
          updatedAt: true
        },
        orderBy: {
          createdAt: 'desc'
        }
      });

      return res.json({
        success: true,
        message: 'Usuários listados com sucesso',
        data: users
      });
    } catch (error) {
      console.error('Erro ao listar usuários:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar usuário por ID
  async getUserById(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;

      const user = await prisma.user.findUnique({
        where: { id },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          permissions: true,
          isActive: true,
          lastLogin: true,
          createdAt: true,
          updatedAt: true,
          company: {
            select: {
              id: true,
              name: true,
              email: true
            }
          }
        }
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Usuário encontrado com sucesso',
        data: user
      });
    } catch (error) {
      console.error('Erro ao buscar usuário:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar novo usuário
  async createUser(req: Request, res: Response<ApiResponse>) {
    try {
      const data: CreateUserData = req.body;

      // Validações básicas
      if (!data.name || !data.email || !data.password || !data.role) {
        return res.status(400).json({
          success: false,
          message: 'Nome, email, senha e role são obrigatórios',
          data: null
        });
      }

      // Se não for usuário master, companyId é obrigatório
      if (data.role !== 'master' && !data.companyId) {
        return res.status(400).json({
          success: false,
          message: 'CompanyId é obrigatório para usuários não-master',
          data: null
        });
      }

      // Se for usuário master, não deve ter companyId
      if (data.role === 'master' && data.companyId) {
        return res.status(400).json({
          success: false,
          message: 'Usuários master não devem ter companyId',
          data: null
        });
      }

      // Verificar se a empresa existe (se não for master)
      if (data.companyId) {
        const company = await prisma.company.findUnique({
          where: { id: data.companyId }
        });

        if (!company) {
          return res.status(404).json({
            success: false,
            message: 'Empresa não encontrada',
            data: null
          });
        }
      }

      // Verificar se o email já existe
      const existingUser = await prisma.user.findUnique({
        where: { email: data.email.toLowerCase() }
      });

      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: 'Já existe um usuário com este email',
          data: null
        });
      }

      // Hash da senha
      const passwordHash = await bcrypt.hash(data.password, 12);

      // Criar usuário
      const user = await prisma.user.create({
        data: {
          name: data.name,
          email: data.email.toLowerCase(),
          passwordHash,
          role: data.role,
          companyId: data.companyId || null, // null para usuários master
          permissions: data.permissions || {}
        },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          permissions: true,
          isActive: true,
          createdAt: true,
          company: {
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Usuário criado com sucesso',
        data: user
      });
    } catch (error) {
      console.error('Erro ao criar usuário:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar usuário
  async updateUser(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const data: UpdateUserData = req.body;

      // Verificar se o usuário existe
      const existingUser = await prisma.user.findUnique({
        where: { id }
      });

      if (!existingUser) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado',
          data: null
        });
      }

      // Verificar se o email já existe (se estiver sendo alterado)
      if (data.email && data.email !== existingUser.email) {
        const emailExists = await prisma.user.findUnique({
          where: { email: data.email.toLowerCase() }
        });

        if (emailExists) {
          return res.status(400).json({
            success: false,
            message: 'Já existe um usuário com este email',
            data: null
          });
        }
      }

      // Preparar dados para atualização
      const updateData: any = {
        ...data,
        email: data.email ? data.email.toLowerCase() : undefined
      };

      // Se a senha estiver sendo alterada, fazer hash
      if (data.password) {
        updateData.passwordHash = await bcrypt.hash(data.password, 12);
        delete updateData.password;
      }

      // Atualizar usuário
      const updatedUser = await prisma.user.update({
        where: { id },
        data: updateData,
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          permissions: true,
          isActive: true,
          updatedAt: true,
          company: {
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      return res.json({
        success: true,
        message: 'Usuário atualizado com sucesso',
        data: updatedUser
      });
    } catch (error) {
      console.error('Erro ao atualizar usuário:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Desativar/Ativar usuário
  async toggleUserStatus(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;

      const user = await prisma.user.findUnique({
        where: { id }
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado',
          data: null
        });
      }

      // Não permitir desativar usuário master
      if (user.role === 'master') {
        return res.status(400).json({
          success: false,
          message: 'Não é possível desativar um usuário master',
          data: null
        });
      }

      const updatedUser = await prisma.user.update({
        where: { id },
        data: {
          isActive: !user.isActive
        },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          isActive: true,
          updatedAt: true
        }
      });

      return res.json({
        success: true,
        message: `Usuário ${updatedUser.isActive ? 'ativado' : 'desativado'} com sucesso`,
        data: updatedUser
      });
    } catch (error) {
      console.error('Erro ao alterar status do usuário:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Redefinir senha do usuário
  async resetUserPassword(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const { newPassword } = req.body;

      if (!newPassword) {
        return res.status(400).json({
          success: false,
          message: 'Nova senha é obrigatória',
          data: null
        });
      }

      const user = await prisma.user.findUnique({
        where: { id }
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado',
          data: null
        });
      }

      // Hash da nova senha
      const passwordHash = await bcrypt.hash(newPassword, 12);

      await prisma.user.update({
        where: { id },
        data: {
          passwordHash
        }
      });

      return res.json({
        success: true,
        message: 'Senha redefinida com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao redefinir senha:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Estatísticas de usuários
  async getUserStats(req: Request, res: Response<ApiResponse>) {
    try {
      const [
        totalUsers,
        activeUsers,
        masterUsers,
        adminUsers,
        managerUsers,
        sellerUsers,
        stockUsers,
        financialUsers,
        usersThisMonth
      ] = await Promise.all([
        prisma.user.count(),
        prisma.user.count({ where: { isActive: true } }),
        prisma.user.count({ where: { role: 'master' } }),
        prisma.user.count({ where: { role: 'admin' } }),
        prisma.user.count({ where: { role: 'manager' } }),
        prisma.user.count({ where: { role: 'seller' } }),
        prisma.user.count({ where: { role: 'stock' } }),
        prisma.user.count({ where: { role: 'financial' } }),
        prisma.user.count({
          where: {
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        })
      ]);

      const stats = {
        totalUsers,
        activeUsers,
        masterUsers,
        adminUsers,
        managerUsers,
        sellerUsers,
        stockUsers,
        financialUsers,
        usersThisMonth
      };

      return res.json({
        success: true,
        message: 'Estatísticas de usuários carregadas com sucesso',
        data: stats
      });
    } catch (error) {
      console.error('Erro ao carregar estatísticas de usuários:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
