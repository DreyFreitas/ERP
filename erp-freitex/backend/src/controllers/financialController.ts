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
}

export const financialController = new FinancialController();
