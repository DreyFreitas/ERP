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
      console.log('🔍 Iniciando busca de empresas com contagem de usuários...');
      
      const companies = await prisma.company.findMany({
        select: {
          id: true,
          name: true,
          email: true,
          phone: true,
          city: true,
          state: true,
          planType: true,
          planStatus: true,
          isActive: true,
          createdAt: true,
          updatedAt: true,
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

      console.log('📊 Empresas encontradas:', companies.length);
      console.log('📋 Dados das empresas:', JSON.stringify(companies, null, 2));

      // Transformar os dados para incluir a contagem de usuários
      const companiesWithUserCount = companies.map(company => ({
        ...company,
        userCount: company._count.users,
        _count: undefined // Remover o objeto _count
      }));

      console.log('✅ Dados transformados:', JSON.stringify(companiesWithUserCount, null, 2));

      return res.json({
        success: true,
        message: 'Empresas listadas com sucesso',
        data: companiesWithUserCount
      });
    } catch (error) {
      console.error('❌ Erro ao listar empresas:', error);
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
        select: {
          id: true,
          name: true,
          cnpj: true,
          email: true,
          phone: true,
          address: true,
          city: true,
          state: true,
          zipCode: true,
          logoUrl: true,
          planType: true,
          planStatus: true,
          trialEndsAt: true,
          subscriptionEndsAt: true,
          isActive: true,
          createdAt: true,
          updatedAt: true
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
      const {
        name,
        cnpj,
        email,
        phone,
        address,
        city,
        state,
        zipCode,
        logoUrl,
        planType = 'basic'
      } = req.body;

      // Validações básicas
      if (!name || !email) {
        return res.status(400).json({
          success: false,
          message: 'Nome e email são obrigatórios',
          data: null
        });
      }

      // Verificar se o email já existe
      const existingCompany = await prisma.company.findUnique({
        where: { email: email.toLowerCase() }
      });

      if (existingCompany) {
        return res.status(400).json({
          success: false,
          message: 'Já existe uma empresa com este email',
          data: null
        });
      }

      // Verificar se o CNPJ já existe (se fornecido)
      if (cnpj) {
        const existingCnpj = await prisma.company.findUnique({
          where: { cnpj }
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
          name,
          cnpj,
          email: email.toLowerCase(),
          phone,
          address,
          city,
          state,
          zipCode,
          logoUrl,
          planType,
          planStatus: 'active',
          trialEndsAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 dias de trial
          isActive: true
        },
        select: {
          id: true,
          name: true,
          cnpj: true,
          email: true,
          phone: true,
          address: true,
          city: true,
          state: true,
          zipCode: true,
          logoUrl: true,
          planType: true,
          planStatus: true,
          trialEndsAt: true,
          subscriptionEndsAt: true,
          isActive: true,
          createdAt: true
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
      const updateData = req.body;

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
      if (updateData.email && updateData.email !== existingCompany.email) {
        const emailExists = await prisma.company.findUnique({
          where: { email: updateData.email.toLowerCase() }
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
      if (updateData.cnpj && updateData.cnpj !== existingCompany.cnpj) {
        const cnpjExists = await prisma.company.findUnique({
          where: { cnpj: updateData.cnpj }
        });

        if (cnpjExists) {
          return res.status(400).json({
            success: false,
            message: 'Já existe uma empresa com este CNPJ',
            data: null
          });
        }
      }

      // Preparar dados para atualização
      const dataToUpdate: any = {
        ...updateData,
        email: updateData.email ? updateData.email.toLowerCase() : undefined
      };

      // Atualizar empresa
      const updatedCompany = await prisma.company.update({
        where: { id },
        data: dataToUpdate,
        select: {
          id: true,
          name: true,
          cnpj: true,
          email: true,
          phone: true,
          address: true,
          city: true,
          state: true,
          zipCode: true,
          logoUrl: true,
          planType: true,
          planStatus: true,
          trialEndsAt: true,
          subscriptionEndsAt: true,
          isActive: true,
          updatedAt: true
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

  // Ativar/Desativar empresa
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
        select: {
          id: true,
          name: true,
          email: true,
          isActive: true,
          updatedAt: true
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

  // Dashboard da empresa
  async getCompanyDashboard(req: Request, res: Response<ApiResponse>) {
    try {
      const userId = (req as any).user.id;
      
      // Buscar usuário e sua empresa
      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: {
          company: true
        }
      });

      if (!user || !user.companyId || !user.company) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa ou empresa não encontrada.',
          data: null
        });
      }

      // Calcular data de início do mês atual
      const now = new Date();
      const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());

      // Buscar dados reais do banco de dados
      const [
        totalSales,
        salesToday,
        totalProducts,
        lowStockProducts,
        totalCustomers,
        monthlyRevenue,
        pendingPayments
      ] = await Promise.all([
        // Total de vendas (todas)
        prisma.sale.count({
          where: {
            companyId: user.companyId,
            isActive: true
          }
        }),
        
        // Vendas de hoje
        prisma.sale.count({
          where: {
            companyId: user.companyId,
            isActive: true,
            createdAt: {
              gte: startOfDay
            }
          }
        }),
        
        // Total de produtos
        prisma.product.count({
          where: {
            companyId: user.companyId,
            isActive: true
          }
        }),
        
        // Produtos com estoque baixo (menos de 10 unidades)
        prisma.product.count({
          where: {
            companyId: user.companyId,
            isActive: true,
            variations: {
              some: {
                stockQuantity: {
                  lt: 10
                }
              }
            }
          }
        }),
        
        // Total de clientes
        prisma.customer.count({
          where: {
            companyId: user.companyId,
            isActive: true
          }
        }),
        
        // Receita mensal
        prisma.sale.aggregate({
          where: {
            companyId: user.companyId,
            isActive: true,
            createdAt: {
              gte: startOfMonth
            },
            paymentStatus: 'PAID'
          },
          _sum: {
            totalAmount: true
          }
        }),
        
        // Contas pendentes (vendas com pagamento pendente)
        prisma.sale.aggregate({
          where: {
            companyId: user.companyId,
            isActive: true,
            paymentStatus: 'PENDING'
          },
          _sum: {
            totalAmount: true
          }
        })
      ]);

      const dashboardData = {
        totalSales: salesToday, // Mostrar vendas de hoje no card principal
        totalProducts,
        lowStockProducts,
        totalCustomers,
        monthlyRevenue: monthlyRevenue._sum.totalAmount || 0,
        pendingPayments: pendingPayments._sum.totalAmount || 0,
        company: {
          id: user.company.id,
          name: user.company.name,
          email: user.company.email
        }
      };

      return res.json({
        success: true,
        message: 'Dados do dashboard carregados com sucesso',
        data: dashboardData
      });
    } catch (error) {
      console.error('Erro ao carregar dashboard da empresa:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Estatísticas para o dashboard master
  async getCompanyStats(req: Request, res: Response<ApiResponse>) {
    try {
      // Buscar estatísticas das empresas
      const [
        totalCompanies,
        activeCompanies,
        suspendedCompanies,
        companiesThisMonth
      ] = await Promise.all([
        prisma.company.count(),
        prisma.company.count({ where: { isActive: true } }),
        prisma.company.count({ where: { isActive: false } }),
        prisma.company.count({
          where: {
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        })
      ]);

      const stats = {
        totalCompanies,
        activeCompanies,
        suspendedCompanies,
        companiesThisMonth
      };

      return res.json({
        success: true,
        message: 'Estatísticas carregadas com sucesso',
        data: stats
      });
    } catch (error) {
      console.error('Erro ao carregar estatísticas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
