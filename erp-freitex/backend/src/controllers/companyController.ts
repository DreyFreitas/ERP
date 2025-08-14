import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

interface CreateCompanyData {
  name: string;
  cnpj?: string;
  email: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  planType?: string;
}

interface UpdateCompanyData {
  name?: string;
  cnpj?: string;
  email?: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  planType?: string;
  planStatus?: string;
  isActive?: boolean;
}

export const companyController = {
  // Listar todas as empresas
  async listCompanies(req: Request, res: Response<ApiResponse>) {
    try {
      const companies = await prisma.company.findMany({
        include: {
          users: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true,
              isActive: true
            }
          },
          _count: {
            select: {
              users: true
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        }
      });

      return res.json({
        success: true,
        message: 'Empresas listadas com sucesso',
        data: companies
      });
    } catch (error) {
      console.error('Erro ao listar empresas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar empresa por ID
  async getCompanyById(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;

      const company = await prisma.company.findUnique({
        where: { id },
        include: {
          users: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true,
              isActive: true,
              lastLogin: true,
              createdAt: true
            }
          },
          settings: true
        }
      });

      if (!company) {
        return res.status(404).json({
          success: false,
          message: 'Empresa não encontrada',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Empresa encontrada com sucesso',
        data: company
      });
    } catch (error) {
      console.error('Erro ao buscar empresa:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar nova empresa
  async createCompany(req: Request, res: Response<ApiResponse>) {
    try {
      const data: CreateCompanyData = req.body;

      // Validações básicas
      if (!data.name || !data.email) {
        return res.status(400).json({
          success: false,
          message: 'Nome e email são obrigatórios',
          data: null
        });
      }

      // Verificar se o email já existe
      const existingCompany = await prisma.company.findUnique({
        where: { email: data.email.toLowerCase() }
      });

      if (existingCompany) {
        return res.status(400).json({
          success: false,
          message: 'Já existe uma empresa com este email',
          data: null
        });
      }

      // Verificar se o CNPJ já existe (se fornecido)
      if (data.cnpj) {
        const existingCnpj = await prisma.company.findUnique({
          where: { cnpj: data.cnpj }
        });

        if (existingCnpj) {
          return res.status(400).json({
            success: false,
            message: 'Já existe uma empresa com este CNPJ',
            data: null
          });
        }
      }

      // Criar empresa
      const company = await prisma.company.create({
        data: {
          name: data.name,
          cnpj: data.cnpj,
          email: data.email.toLowerCase(),
          phone: data.phone,
          address: data.address,
          city: data.city,
          state: data.state,
          zipCode: data.zipCode,
          planType: data.planType || 'basic',
          trialEndsAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) // 30 dias de trial
        },
        include: {
          users: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true,
              isActive: true
            }
          }
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Empresa criada com sucesso',
        data: company
      });
    } catch (error) {
      console.error('Erro ao criar empresa:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar empresa
  async updateCompany(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const data: UpdateCompanyData = req.body;

      // Verificar se a empresa existe
      const existingCompany = await prisma.company.findUnique({
        where: { id }
      });

      if (!existingCompany) {
        return res.status(404).json({
          success: false,
          message: 'Empresa não encontrada',
          data: null
        });
      }

      // Verificar se o email já existe (se estiver sendo alterado)
      if (data.email && data.email !== existingCompany.email) {
        const emailExists = await prisma.company.findUnique({
          where: { email: data.email.toLowerCase() }
        });

        if (emailExists) {
          return res.status(400).json({
            success: false,
            message: 'Já existe uma empresa com este email',
            data: null
          });
        }
      }

      // Verificar se o CNPJ já existe (se estiver sendo alterado)
      if (data.cnpj && data.cnpj !== existingCompany.cnpj) {
        const cnpjExists = await prisma.company.findUnique({
          where: { cnpj: data.cnpj }
        });

        if (cnpjExists) {
          return res.status(400).json({
            success: false,
            message: 'Já existe uma empresa com este CNPJ',
            data: null
          });
        }
      }

      // Atualizar empresa
      const updatedCompany = await prisma.company.update({
        where: { id },
        data: {
          ...data,
          email: data.email ? data.email.toLowerCase() : undefined
        },
        include: {
          users: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true,
              isActive: true
            }
          }
        }
      });

      return res.json({
        success: true,
        message: 'Empresa atualizada com sucesso',
        data: updatedCompany
      });
    } catch (error) {
      console.error('Erro ao atualizar empresa:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Desativar/Ativar empresa
  async toggleCompanyStatus(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;

      const company = await prisma.company.findUnique({
        where: { id }
      });

      if (!company) {
        return res.status(404).json({
          success: false,
          message: 'Empresa não encontrada',
          data: null
        });
      }

      const updatedCompany = await prisma.company.update({
        where: { id },
        data: {
          isActive: !company.isActive
        },
        include: {
          users: {
            select: {
              id: true,
              name: true,
              email: true,
              role: true,
              isActive: true
            }
          }
        }
      });

      return res.json({
        success: true,
        message: `Empresa ${updatedCompany.isActive ? 'ativada' : 'desativada'} com sucesso`,
        data: updatedCompany
      });
    } catch (error) {
      console.error('Erro ao alterar status da empresa:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Obter estatísticas das empresas
  async getCompanyStats(req: Request, res: Response<ApiResponse>) {
    try {
      const [
        totalCompanies,
        activeCompanies,
        suspendedCompanies,
        companiesThisMonth,
        totalUsers
      ] = await Promise.all([
        prisma.company.count(),
        prisma.company.count({ where: { isActive: true } }),
        prisma.company.count({ where: { planStatus: 'suspended' } }),
        prisma.company.count({
          where: {
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        }),
        prisma.user.count({ where: { role: { not: 'master' } } })
      ]);

      const stats = {
        totalCompanies,
        activeCompanies,
        suspendedCompanies,
        companiesThisMonth,
        totalUsers,
        inactiveCompanies: totalCompanies - activeCompanies
      };

      return res.json({
        success: true,
        message: 'Estatísticas obtidas com sucesso',
        data: stats
      });
    } catch (error) {
      console.error('Erro ao obter estatísticas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
