import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';

export class FinancialController {
  // ========================================
  // CONTAS FINANCEIRAS
  // ========================================

  // Listar contas financeiras
  async listAccounts(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { search, status } = req.query;

      const where: any = {
        companyId,
      };

      if (search) {
        where.name = {
          contains: search as string,
          mode: 'insensitive',
        };
      }

      if (status === 'active') {
        where.isActive = true;
      } else if (status === 'inactive') {
        where.isActive = false;
      }

      const accounts = await prisma.financialAccount.findMany({
        where,
        orderBy: { name: 'asc' },
      });

      return res.json(accounts);
    } catch (error) {
      console.error('Erro ao listar contas financeiras:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Obter conta por ID
  async getAccountById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;

      const account = await prisma.financialAccount.findFirst({
        where: {
          id,
          companyId,
        },
        include: {
          transactions: {
            orderBy: { createdAt: 'desc' },
            take: 10,
          },
        },
      });

      if (!account) {
        return res.status(404).json({ error: 'Conta não encontrada' });
      }

      return res.json(account);
    } catch (error) {
      console.error('Erro ao obter conta:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Criar conta financeira
  async createAccount(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { name, accountType, initialBalance } = req.body;

      if (!name || !accountType) {
        return res.status(400).json({ error: 'Nome e tipo de conta são obrigatórios' });
      }

      if (!companyId) {
        return res.status(400).json({ error: 'ID da empresa não encontrado' });
      }

      // @ts-ignore
      const account = await prisma.financialAccount.create({
        data: {
          companyId: companyId!,
          name,
          accountType: accountType as any,
          initialBalance: initialBalance || 0,
          currentBalance: initialBalance || 0,
        },
      });

      return res.status(201).json(account);
    } catch (error) {
      console.error('Erro ao criar conta:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Atualizar conta financeira
  async updateAccount(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;
      const { name, accountType, isActive } = req.body;

      const account = await prisma.financialAccount.findFirst({
        where: {
          id,
          companyId,
        },
      });

      if (!account) {
        return res.status(404).json({ error: 'Conta não encontrada' });
      }

      const updatedAccount = await prisma.financialAccount.update({
        where: { id },
        data: {
          name,
          accountType,
          isActive,
        },
      });

      return res.json(updatedAccount);
    } catch (error) {
      console.error('Erro ao atualizar conta:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Deletar conta financeira
  async deleteAccount(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;

      const account = await prisma.financialAccount.findFirst({
        where: {
          id,
          companyId,
        },
        include: {
          transactions: true,
        },
      });

      if (!account) {
        return res.status(404).json({ error: 'Conta não encontrada' });
      }

      if (account.transactions.length > 0) {
        return res.status(400).json({ error: 'Não é possível deletar uma conta que possui transações' });
      }

      await prisma.financialAccount.delete({
        where: { id },
      });

      return res.json({ message: 'Conta deletada com sucesso' });
    } catch (error) {
      console.error('Erro ao deletar conta:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // ========================================
  // TRANSAÇÕES FINANCEIRAS
  // ========================================

  // Listar transações
  async listTransactions(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { 
        search, 
        status, 
        type, 
        accountId, 
        startDate, 
        endDate,
        page = 1,
        limit = 20
      } = req.query;

      const skip = (Number(page) - 1) * Number(limit);

      const where: any = {
        companyId,
      };

      if (search) {
        where.description = {
          contains: search as string,
          mode: 'insensitive',
        };
      }

      if (status) {
        where.status = status;
      }

      if (type) {
        where.transactionType = type;
      }

      if (accountId) {
        where.accountId = accountId;
      }

      if (startDate && endDate) {
        where.dueDate = {
          gte: new Date(startDate as string),
          lte: new Date(endDate as string),
        };
      }

      const [transactions, total] = await Promise.all([
        prisma.financialTransaction.findMany({
          where,
          include: {
            account: {
              select: {
                name: true,
                accountType: true,
              },
            },
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: Number(limit),
        }),
        prisma.financialTransaction.count({ where }),
      ]);

      return res.json({
        transactions,
        pagination: {
          page: Number(page),
          limit: Number(limit),
          total,
          pages: Math.ceil(total / Number(limit)),
        },
      });
    } catch (error) {
      console.error('Erro ao listar transações:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Obter transação por ID
  async getTransactionById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;

      const transaction = await prisma.financialTransaction.findFirst({
        where: {
          id,
          companyId,
        },
        include: {
          account: {
            select: {
              name: true,
              accountType: true,
            },
          },
        },
      });

      if (!transaction) {
        return res.status(404).json({ error: 'Transação não encontrada' });
      }

      return res.json(transaction);
    } catch (error) {
      console.error('Erro ao obter transação:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Criar transação
  async createTransaction(req: Request, res: Response) {
    try {
      const { companyId, id: userId } = (req as any).user;
      const {
        accountId,
        transactionType,
        description,
        amount,
        dueDate,
        category,
        referenceDocument,
        notes,
        isRecurring,
        recurrenceType,
        recurrenceInterval,
        recurrenceEndDate,
      } = req.body;

      if (!accountId || !transactionType || !description || !amount) {
        return res.status(400).json({ 
          error: 'Conta, tipo, descrição e valor são obrigatórios' 
        });
      }

      if (!companyId) {
        return res.status(400).json({ error: 'ID da empresa não encontrado' });
      }

      // Verificar se a conta existe e pertence à empresa
      const account = await prisma.financialAccount.findFirst({
        where: {
          id: accountId,
          companyId,
        },
      });

      if (!account) {
        return res.status(404).json({ error: 'Conta não encontrada' });
      }

      // Criar a transação
      // @ts-ignore
      const transaction = await prisma.financialTransaction.create({
        data: {
          companyId: companyId!,
          accountId,
          transactionType: transactionType as any,
          description,
          amount: Number(amount),
          dueDate: dueDate ? new Date(dueDate) : null,
          category,
          referenceDocument,
          notes,
          userId,
          isRecurring: isRecurring || false,
          recurrenceType: recurrenceType || null,
          recurrenceInterval: recurrenceInterval ? Number(recurrenceInterval) : null,
          recurrenceEndDate: recurrenceEndDate ? new Date(recurrenceEndDate) : null,
        },
      });

      // Atualizar saldo da conta
      const balanceChange = transactionType === 'INCOME' ? Number(amount) : -Number(amount);
      await prisma.financialAccount.update({
        where: { id: accountId },
        data: {
          currentBalance: {
            increment: balanceChange,
          },
        },
      });

      return res.status(201).json(transaction);
    } catch (error) {
      console.error('Erro ao criar transação:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Atualizar transação
  async updateTransaction(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;
      const {
        description,
        amount,
        dueDate,
        status,
        category,
        referenceDocument,
        notes,
      } = req.body;

      const transaction = await prisma.financialTransaction.findFirst({
        where: {
          id,
          companyId,
        },
      });

      if (!transaction) {
        return res.status(404).json({ error: 'Transação não encontrada' });
      }

      // Se o status mudou para PAID, atualizar paymentDate
      const updateData: any = {
        description,
        amount: Number(amount),
        dueDate: dueDate ? new Date(dueDate) : null,
        status,
        category,
        referenceDocument,
        notes,
      };

      if (status === 'PAID' && transaction.status !== 'PAID') {
        updateData.paymentDate = new Date();
      }

      const updatedTransaction = await prisma.financialTransaction.update({
        where: { id },
        data: updateData,
      });

      return res.json(updatedTransaction);
    } catch (error) {
      console.error('Erro ao atualizar transação:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Deletar transação
  async deleteTransaction(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { companyId } = (req as any).user;

      const transaction = await prisma.financialTransaction.findFirst({
        where: {
          id,
          companyId,
        },
      });

      if (!transaction) {
        return res.status(404).json({ error: 'Transação não encontrada' });
      }

      // Reverter o saldo da conta
      const balanceChange = transaction.transactionType === 'INCOME' ? -Number(transaction.amount) : Number(transaction.amount);
      await prisma.financialAccount.update({
        where: { id: transaction.accountId },
        data: {
          currentBalance: {
            increment: balanceChange,
          },
        },
      });

      await prisma.financialTransaction.delete({
        where: { id },
      });

      return res.json({ message: 'Transação deletada com sucesso' });
    } catch (error) {
      console.error('Erro ao deletar transação:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // ========================================
  // RELATÓRIOS E ESTATÍSTICAS
  // ========================================

  // Obter estatísticas financeiras
  async getFinancialStats(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { startDate, endDate } = req.query;

      const dateFilter: any = {};
      if (startDate && endDate) {
        dateFilter.createdAt = {
          gte: new Date(startDate as string),
          lte: new Date(endDate as string),
        };
      }

      const [
        totalIncome,
        totalExpenses,
        pendingReceivables,
        pendingPayables,
        accountBalances,
      ] = await Promise.all([
        // Total de receitas
        prisma.financialTransaction.aggregate({
          where: {
            companyId,
            transactionType: 'INCOME',
            status: 'PAID',
            ...dateFilter,
          },
          _sum: { amount: true },
        }),
        // Total de despesas
        prisma.financialTransaction.aggregate({
          where: {
            companyId,
            transactionType: 'EXPENSE',
            status: 'PAID',
            ...dateFilter,
          },
          _sum: { amount: true },
        }),
        // Contas a receber pendentes
        prisma.financialTransaction.aggregate({
          where: {
            companyId,
            transactionType: 'INCOME',
            status: 'PENDING',
          },
          _sum: { amount: true },
        }),
        // Contas a pagar pendentes
        prisma.financialTransaction.aggregate({
          where: {
            companyId,
            transactionType: 'EXPENSE',
            status: 'PENDING',
          },
          _sum: { amount: true },
        }),
        // Saldos das contas
        prisma.financialAccount.findMany({
          where: {
            companyId,
            isActive: true,
          },
          select: {
            name: true,
            accountType: true,
            currentBalance: true,
          },
          orderBy: { name: 'asc' },
        }),
      ]);

      const stats = {
        totalIncome: Number(totalIncome._sum?.amount || 0),
        totalExpenses: Number(totalExpenses._sum?.amount || 0),
        netIncome: Number(totalIncome._sum?.amount || 0) - Number(totalExpenses._sum?.amount || 0),
        pendingReceivables: Number(pendingReceivables._sum?.amount || 0),
        pendingPayables: Number(pendingPayables._sum?.amount || 0),
        accountBalances,
      };

      return res.json(stats);
    } catch (error) {
      console.error('Erro ao obter estatísticas:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // ========================================
  // TRANSAÇÕES RECORRENTES
  // ========================================

  // Gerar transações recorrentes
  async generateRecurringTransactions(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { date } = req.query;

      const targetDate = date ? new Date(date as string) : new Date();
      const generatedTransactions = [];

      // Buscar transações recorrentes ativas
      const recurringTransactions = await prisma.financialTransaction.findMany({
        where: {
          companyId,
          isRecurring: true,
          transactionType: 'EXPENSE',
          status: 'PENDING',
          OR: [
            { recurrenceEndDate: null },
            { recurrenceEndDate: { gte: targetDate } }
          ]
        }
      });

      for (const transaction of recurringTransactions) {
        const nextDueDate = this.calculateNextDueDate(
          transaction.dueDate || transaction.createdAt,
          transaction.recurrenceType!,
          transaction.recurrenceInterval || 1
        );

        // Se a próxima data de vencimento é hoje ou passou, gerar nova transação
        if (nextDueDate <= targetDate) {
          const newTransaction = await prisma.financialTransaction.create({
            data: {
              companyId,
              accountId: transaction.accountId,
              transactionType: 'EXPENSE',
              description: transaction.description,
              amount: transaction.amount,
              dueDate: nextDueDate,
              category: transaction.category,
              referenceDocument: transaction.referenceDocument,
              notes: transaction.notes,
              userId: transaction.userId,
              isRecurring: false, // Nova transação não é recorrente
              parentTransactionId: transaction.id, // Referência à transação pai
            }
          });

          generatedTransactions.push(newTransaction);
        }
      }

      return res.json({
        message: `${generatedTransactions.length} transações recorrentes geradas`,
        transactions: generatedTransactions
      });
    } catch (error) {
      console.error('Erro ao gerar transações recorrentes:', error);
      return res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  // Calcular próxima data de vencimento
  private calculateNextDueDate(currentDate: Date, recurrenceType: string, interval: number): Date {
    const date = new Date(currentDate);
    
    switch (recurrenceType) {
      case 'DAILY':
        date.setDate(date.getDate() + interval);
        break;
      case 'WEEKLY':
        date.setDate(date.getDate() + (interval * 7));
        break;
      case 'MONTHLY':
        date.setMonth(date.getMonth() + interval);
        break;
      case 'QUARTERLY':
        date.setMonth(date.getMonth() + (interval * 3));
        break;
      case 'SEMIANNUAL':
        date.setMonth(date.getMonth() + (interval * 6));
        break;
      case 'ANNUAL':
        date.setFullYear(date.getFullYear() + interval);
        break;
      default:
        date.setMonth(date.getMonth() + interval);
    }
    
    return date;
  }

  // ========================================
  // CONTAS A RECEBER
  // ========================================

  // Listar contas a receber baseadas nas parcelas E vendas a prazo direto
  async listAccountsReceivable(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { search, status, customerId } = req.query;

      const today = new Date();
      const accountsReceivable = [];

      // 1. Buscar parcelas (vendas parceladas)
      const installmentsWhere: any = {
        sale: {
          companyId: companyId,
          isActive: true
        },
        status: {
          in: ['PENDING', 'OVERDUE']
        }
      };

      if (search) {
        installmentsWhere.OR = [
          {
            sale: {
              customer: {
                name: {
                  contains: search as string,
                  mode: 'insensitive',
                }
              }
            }
          },
          {
            sale: {
              saleNumber: {
                contains: search as string,
                mode: 'insensitive',
              }
            }
          }
        ];
      }

      if (status === 'overdue') {
        installmentsWhere.dueDate = {
          lt: today
        };
        installmentsWhere.status = 'PENDING';
      }

      if (customerId) {
        installmentsWhere.sale = {
          ...installmentsWhere.sale,
          customerId: customerId as string
        };
      }

      const installments = await prisma.saleInstallment.findMany({
        where: installmentsWhere,
        include: {
          sale: {
            include: {
              customer: {
                select: {
                  id: true,
                  name: true,
                  email: true,
                  phone: true
                }
              }
            }
          }
        },
        orderBy: {
          dueDate: 'asc'
        }
      });

      // Processar parcelas
      installments.forEach(installment => {
        const dueDate = new Date(installment.dueDate);
        const daysOverdue = Math.floor((today.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24));
        
        let status = installment.status;
        if (installment.status === 'PENDING' && daysOverdue > 0) {
          status = 'OVERDUE';
        }

        accountsReceivable.push({
          id: `installment_${installment.id}`,
          customer: installment.sale.customer,
          saleNumber: installment.sale.saleNumber,
          saleDate: installment.sale.createdAt,
          dueDate: installment.dueDate,
          originalAmount: installment.amount,
          pendingAmount: installment.status === 'PAID' ? 0 : installment.amount,
          daysOverdue: daysOverdue > 0 ? daysOverdue : 0,
          status: status,
          installmentNumber: installment.installmentNumber,
          saleId: installment.saleId,
          type: 'installment'
        });
      });

      // 2. Buscar vendas a prazo direto (não parceladas)
      const directSalesWhere: any = {
        companyId: companyId,
        isActive: true,
        paymentStatus: 'PENDING',
        dueDate: {
          not: null
        }
      };

      if (search) {
        directSalesWhere.OR = [
          {
            customer: {
              name: {
                contains: search as string,
                mode: 'insensitive',
              }
            }
          },
          {
            saleNumber: {
              contains: search as string,
              mode: 'insensitive',
            }
          }
        ];
      }

      if (status === 'overdue') {
        directSalesWhere.dueDate = {
          lt: today
        };
      }

      if (customerId) {
        directSalesWhere.customerId = customerId as string;
      }

      const directSales = await prisma.sale.findMany({
        where: directSalesWhere,
        include: {
          customer: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          }
        },
        orderBy: {
          dueDate: 'asc'
        }
      });

      // Processar vendas a prazo direto
      directSales.forEach(sale => {
        const dueDate = new Date(sale.dueDate!);
        const daysOverdue = Math.floor((today.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24));
        
        let status = sale.paymentStatus;
        if (sale.paymentStatus === 'PENDING' && daysOverdue > 0) {
          status = 'OVERDUE';
        }

        accountsReceivable.push({
          id: `sale_${sale.id}`,
          customer: sale.customer,
          saleNumber: sale.saleNumber,
          saleDate: sale.createdAt,
          dueDate: sale.dueDate,
          originalAmount: sale.finalAmount,
          pendingAmount: sale.paymentStatus === 'PAID' ? 0 : sale.finalAmount,
          daysOverdue: daysOverdue > 0 ? daysOverdue : 0,
          status: status,
          installmentNumber: null,
          saleId: sale.id,
          type: 'direct'
        });
      });

      // Ordenar por data de vencimento
      accountsReceivable.sort((a, b) => new Date(a.dueDate).getTime() - new Date(b.dueDate).getTime());

      return res.json({
        success: true,
        data: accountsReceivable
      });
    } catch (error) {
      console.error('Erro ao listar contas a receber:', error);
      return res.status(500).json({ 
        success: false,
        error: 'Erro interno do servidor' 
      });
    }
  }

  // Listar vencimentos próximos (próximos 30 dias)
  async listUpcomingDueDates(req: Request, res: Response) {
    try {
      const { companyId } = (req as any).user;
      const { days = 30 } = req.query;

      const daysAhead = parseInt(days as string);
      const today = new Date();
      const futureDate = new Date();
      futureDate.setDate(today.getDate() + daysAhead);

      const installments = await prisma.saleInstallment.findMany({
        where: {
          sale: {
            companyId: companyId,
            isActive: true
          },
          status: 'PENDING',
          dueDate: {
            gte: today,
            lte: futureDate
          }
        },
        include: {
          sale: {
            include: {
              customer: {
                select: {
                  id: true,
                  name: true,
                  email: true,
                  phone: true
                }
              }
            }
          }
        },
        orderBy: {
          dueDate: 'asc'
        }
      });

      // Calcular dias restantes
      const upcomingDueDates = installments.map(installment => {
        const dueDate = new Date(installment.dueDate);
        const daysRemaining = Math.ceil((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
        
        let status = 'PENDING';
        if (daysRemaining <= 7) {
          status = 'URGENT';
        } else if (daysRemaining <= 15) {
          status = 'WARNING';
        }

        return {
          id: installment.id,
          customer: installment.sale.customer,
          saleNumber: installment.sale.saleNumber,
          dueDate: installment.dueDate,
          amount: installment.amount,
          daysRemaining: daysRemaining,
          status: status,
          installmentNumber: installment.installmentNumber,
          saleId: installment.saleId
        };
      });

      return res.json({
        success: true,
        data: upcomingDueDates
      });
    } catch (error) {
      console.error('Erro ao listar vencimentos próximos:', error);
      return res.status(500).json({ 
        success: false,
        error: 'Erro interno do servidor' 
      });
    }
  }

  // ========================================
}

export const financialController = new FinancialController();
