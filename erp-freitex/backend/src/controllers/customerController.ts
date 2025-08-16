import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';

export class CustomerController {
  // Listar todos os clientes da empresa
  async listCustomers(req: Request, res: Response): Promise<void> {
    try {
      const companyId = (req as any).user.companyId;
      const { search, status, hasOpenAccounts } = req.query;

      // Construir filtros
      const where: any = {
        companyId: companyId
      };

      if (search) {
        where.OR = [
          { name: { contains: search as string, mode: 'insensitive' } },
          { email: { contains: search as string, mode: 'insensitive' } },
          { cpfCnpj: { contains: search as string, mode: 'insensitive' } }
        ];
      }

      if (status) {
        where.isActive = status === 'active';
      }

      const customers = await prisma.customer.findMany({
        where,
        include: {
          sales: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              totalAmount: true,
              paymentMethod: true,
              paymentStatus: true,
              createdAt: true,
              dueDate: true
            },
            orderBy: {
              createdAt: 'desc'
            }
          }
        },
        orderBy: {
          name: 'asc'
        }
      });

      // Processar dados dos clientes
      const processedCustomers = customers.map(customer => {
        const totalPurchases = customer.sales.reduce((sum, sale) => sum + Number(sale.totalAmount), 0);
        const lastPurchase = customer.sales.length > 0 ? customer.sales[0].createdAt : null;
        const openAccounts = customer.sales.filter(sale => 
          sale.paymentStatus === 'PENDING'
        );
        const totalOpenAmount = openAccounts.reduce((sum, sale) => sum + Number(sale.totalAmount), 0);

        return {
          ...customer,
          totalPurchases,
          lastPurchase: lastPurchase ? lastPurchase.toISOString() : null,
          openAccountsCount: openAccounts.length,
          totalOpenAmount,
          hasOpenAccounts: openAccounts.length > 0
        };
      });

      // Filtrar por contas em aberto se solicitado
      let filteredCustomers = processedCustomers;
      if (hasOpenAccounts === 'true') {
        filteredCustomers = processedCustomers.filter(customer => customer.hasOpenAccounts);
      }

      res.status(200).json({
        success: true,
        data: filteredCustomers
      });

    } catch (error) {
      console.error('Erro ao listar clientes:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Buscar cliente por ID
  async getCustomerById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const companyId = (req as any).user.companyId;

      const customer = await prisma.customer.findFirst({
        where: {
          id,
          companyId: companyId
        },
        include: {
          sales: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              saleNumber: true,
              totalAmount: true,
              paymentMethod: true,
              paymentStatus: true,
              createdAt: true,
              dueDate: true,
              items: {
                select: {
                  product: {
                    select: {
                      name: true
                    }
                  },
                  quantity: true,
                  unitPrice: true,
                  totalPrice: true
                }
              }
            },
            orderBy: {
              createdAt: 'desc'
            }
          }
        }
      });

      if (!customer) {
        res.status(404).json({
          success: false,
          message: 'Cliente não encontrado'
        });
        return;
      }

      // Processar dados do cliente
      const totalPurchases = customer.sales.reduce((sum, sale) => sum + Number(sale.totalAmount), 0);
      const lastPurchase = customer.sales.length > 0 ? customer.sales[0].createdAt : null;
      const openAccounts = customer.sales.filter(sale => 
        sale.paymentStatus === 'PENDING'
      );
      const totalOpenAmount = openAccounts.reduce((sum, sale) => sum + Number(sale.totalAmount), 0);

      const processedCustomer = {
        ...customer,
        totalPurchases,
        lastPurchase: lastPurchase ? lastPurchase.toISOString() : null,
        openAccountsCount: openAccounts.length,
        totalOpenAmount,
        hasOpenAccounts: openAccounts.length > 0
      };

      res.status(200).json({
        success: true,
        data: processedCustomer
      });

    } catch (error) {
      console.error('Erro ao buscar cliente:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Criar novo cliente
  async createCustomer(req: Request, res: Response): Promise<void> {
    try {
      const companyId = (req as any).user.companyId;
      const {
        name,
        cpfCnpj,
        email,
        phone,
        address,
        city,
        state,
        zipCode,
        birthDate,
        gender,
        notes
      } = req.body;

      // Validar dados obrigatórios
      if (!name) {
        res.status(400).json({
          success: false,
          message: 'Nome do cliente é obrigatório'
        });
        return;
      }

      // Verificar se CPF/CNPJ já existe na empresa
      if (cpfCnpj) {
        const existingCustomer = await prisma.customer.findFirst({
          where: {
            cpfCnpj,
            companyId: companyId
          }
        });

        if (existingCustomer) {
          res.status(400).json({
            success: false,
            message: 'CPF/CNPJ já cadastrado para outro cliente'
          });
          return;
        }
      }

      // Verificar se email já existe na empresa
      if (email) {
        const existingCustomer = await prisma.customer.findFirst({
          where: {
            email,
            companyId: companyId
          }
        });

        if (existingCustomer) {
          res.status(400).json({
            success: false,
            message: 'Email já cadastrado para outro cliente'
          });
          return;
        }
      }

      const customer = await prisma.customer.create({
        data: {
          companyId: companyId,
          name,
          cpfCnpj,
          email,
          phone,
          address,
          city,
          state,
          zipCode,
          birthDate: birthDate ? new Date(birthDate) : null,
          gender,
          notes,
          isActive: true
        }
      });

      res.status(201).json({
        success: true,
        message: 'Cliente criado com sucesso',
        data: customer
      });

    } catch (error) {
      console.error('Erro ao criar cliente:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Atualizar cliente
  async updateCustomer(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const companyId = (req as any).user.companyId;
      const {
        name,
        cpfCnpj,
        email,
        phone,
        address,
        city,
        state,
        zipCode,
        birthDate,
        gender,
        notes,
        isActive
      } = req.body;

      // Verificar se o cliente existe e pertence à empresa
      const existingCustomer = await prisma.customer.findFirst({
        where: {
          id,
          companyId: companyId
        }
      });

      if (!existingCustomer) {
        res.status(404).json({
          success: false,
          message: 'Cliente não encontrado'
        });
        return;
      }

      // Verificar se CPF/CNPJ já existe para outro cliente
      if (cpfCnpj && cpfCnpj !== existingCustomer.cpfCnpj) {
        const duplicateCustomer = await prisma.customer.findFirst({
          where: {
            cpfCnpj,
            companyId: companyId,
            id: { not: id }
          }
        });

        if (duplicateCustomer) {
          res.status(400).json({
            success: false,
            message: 'CPF/CNPJ já cadastrado para outro cliente'
          });
          return;
        }
      }

      // Verificar se email já existe para outro cliente
      if (email && email !== existingCustomer.email) {
        const duplicateCustomer = await prisma.customer.findFirst({
          where: {
            email,
            companyId: companyId,
            id: { not: id }
          }
        });

        if (duplicateCustomer) {
          res.status(400).json({
            success: false,
            message: 'Email já cadastrado para outro cliente'
          });
          return;
        }
      }

      const customer = await prisma.customer.update({
        where: { id },
        data: {
          name,
          cpfCnpj,
          email,
          phone,
          address,
          city,
          state,
          zipCode,
          birthDate: birthDate ? new Date(birthDate) : null,
          gender,
          notes,
          isActive
        }
      });

      res.status(200).json({
        success: true,
        message: 'Cliente atualizado com sucesso',
        data: customer
      });

    } catch (error) {
      console.error('Erro ao atualizar cliente:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Deletar cliente
  async deleteCustomer(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const companyId = (req as any).user.companyId;

      // Verificar se o cliente existe e pertence à empresa
      const customer = await prisma.customer.findFirst({
        where: {
          id,
          companyId: companyId
        },
        include: {
          sales: {
            where: {
              isActive: true
            }
          }
        }
      });

      if (!customer) {
        res.status(404).json({
          success: false,
          message: 'Cliente não encontrado'
        });
        return;
      }

      // Verificar se o cliente tem vendas
      if (customer.sales.length > 0) {
        res.status(400).json({
          success: false,
          message: 'Não é possível deletar um cliente que possui vendas registradas'
        });
        return;
      }

      await prisma.customer.delete({
        where: { id }
      });

      res.status(200).json({
        success: true,
        message: 'Cliente deletado com sucesso'
      });

    } catch (error) {
      console.error('Erro ao deletar cliente:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Buscar contas em aberto do cliente
  async getCustomerOpenAccounts(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const companyId = (req as any).user.companyId;

      const openAccounts = await prisma.sale.findMany({
        where: {
          customerId: id,
          companyId: companyId,
          isActive: true,
          paymentStatus: 'PENDING'
        },
        include: {
          items: {
            select: {
              product: {
                select: {
                  name: true
                }
              },
              quantity: true,
              unitPrice: true,
              totalPrice: true
            }
          }
        },
        orderBy: {
          dueDate: 'asc'
        }
      });

      res.status(200).json({
        success: true,
        data: openAccounts
      });

    } catch (error) {
      console.error('Erro ao buscar contas em aberto:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Estatísticas de clientes
  async getCustomerStats(req: Request, res: Response): Promise<void> {
    try {
      const companyId = (req as any).user.companyId;

      const [
        totalCustomers,
        activeCustomers,
        customersWithPurchases,
        customersWithOpenAccounts,
        totalOpenAmount
      ] = await Promise.all([
        prisma.customer.count({
          where: { companyId: companyId }
        }),
        prisma.customer.count({
          where: { 
            companyId: companyId,
            isActive: true
          }
        }),
        prisma.customer.count({
          where: {
            companyId: companyId,
            sales: {
              some: {
                isActive: true
              }
            }
          }
        }),
        prisma.customer.count({
          where: {
            companyId: companyId,
            sales: {
              some: {
                isActive: true,
                paymentStatus: 'PENDING'
              }
            }
          }
        }),
        prisma.sale.aggregate({
          where: {
            companyId: companyId,
            isActive: true,
            paymentStatus: 'PENDING'
          },
          _sum: {
            totalAmount: true
          }
        })
      ]);

      const stats = {
        totalCustomers,
        activeCustomers,
        customersWithPurchases,
        customersWithOpenAccounts,
        totalOpenAmount: totalOpenAmount._sum?.totalAmount || 0
      };

      res.status(200).json({
        success: true,
        data: stats
      });

    } catch (error) {
      console.error('Erro ao buscar estatísticas:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}

export const customerController = new CustomerController();
