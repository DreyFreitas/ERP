import { Request, Response } from 'express';
import { AuthRequest } from '../types';
import { prisma } from '../lib/prisma';

// Listar mensalidades com filtros
export const listSubscriptions = async (req: Request, res: Response) => {
  try {
    const { status, companyId, month, year } = req.query;

    const where: any = {};

    if (status) {
      where.status = status;
    }

    if (companyId) {
      where.companyId = companyId;
    }

    if (month && year) {
      const startDate = new Date(Number(year), Number(month) - 1, 1);
      const endDate = new Date(Number(year), Number(month), 0, 23, 59, 59);
      where.dueDate = {
        gte: startDate,
        lte: endDate
      };
    }

    const subscriptions = await prisma.subscription.findMany({
      where,
      include: {
        company: {
          select: {
            id: true,
            name: true,
            email: true,
            cnpj: true
          }
        }
      },
      orderBy: {
        dueDate: 'desc'
      }
    });

    return res.status(200).json({
      success: true,
      data: subscriptions
    });

  } catch (error) {
    console.error('Erro ao listar mensalidades:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Obter estatísticas das mensalidades
export const getSubscriptionStats = async (req: Request, res: Response) => {
  try {
    const [
      total,
      pending,
      paid,
      overdue,
      totalRevenue,
      pendingRevenue
    ] = await Promise.all([
      prisma.subscription.count(),
      prisma.subscription.count({ where: { status: 'pending' } }),
      prisma.subscription.count({ where: { status: 'paid' } }),
      prisma.subscription.count({ where: { status: 'overdue' } }),
      prisma.subscription.aggregate({
        where: { status: 'paid' },
        _sum: { amount: true }
      }),
      prisma.subscription.aggregate({
        where: { status: { in: ['pending', 'overdue'] } },
        _sum: { amount: true }
      })
    ]);

    return res.status(200).json({
      success: true,
      data: {
        total,
        pending,
        paid,
        overdue,
        totalRevenue: totalRevenue._sum.amount || 0,
        pendingRevenue: pendingRevenue._sum.amount || 0
      }
    });

  } catch (error) {
    console.error('Erro ao obter estatísticas:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Criar nova mensalidade
export const createSubscription = async (req: AuthRequest, res: Response) => {
  try {
    const { companyId, planType, amount, dueDate, notes } = req.body;

    // Verificar se a empresa existe
    const company = await prisma.company.findUnique({
      where: { id: companyId }
    });

    if (!company) {
      return res.status(404).json({
        success: false,
        message: 'Empresa não encontrada'
      });
    }

    const subscription = await prisma.subscription.create({
      data: {
        companyId,
        planType,
        planStatus: company.planStatus,
        amount: parseFloat(amount),
        dueDate: new Date(dueDate),
        notes
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            email: true,
            cnpj: true
          }
        }
      }
    });

    return res.status(201).json({
      success: true,
      data: subscription
    });

  } catch (error) {
    console.error('Erro ao criar mensalidade:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Atualizar mensalidade
export const updateSubscription = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status, paymentDate, paymentMethod, notes } = req.body;

    const subscription = await prisma.subscription.update({
      where: { id },
      data: {
        ...(status && { status }),
        ...(paymentDate && { paymentDate: new Date(paymentDate) }),
        ...(paymentMethod && { paymentMethod }),
        ...(notes !== undefined && { notes })
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            email: true,
            cnpj: true
          }
        }
      }
    });

    return res.status(200).json({
      success: true,
      data: subscription
    });

  } catch (error) {
    console.error('Erro ao atualizar mensalidade:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Marcar como pago
export const markAsPaid = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { paymentDate, paymentMethod, notes } = req.body;

    const subscription = await prisma.subscription.update({
      where: { id },
      data: {
        status: 'paid',
        paymentDate: new Date(paymentDate),
        paymentMethod,
        notes
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            email: true,
            cnpj: true
          }
        }
      }
    });

    return res.status(200).json({
      success: true,
      data: subscription
    });

  } catch (error) {
    console.error('Erro ao marcar como pago:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Gerar mensalidades para o próximo mês
export const generateNextMonthSubscriptions = async (req: AuthRequest, res: Response) => {
  try {
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    nextMonth.setDate(1);

    // Buscar todas as empresas ativas
    const companies = await prisma.company.findMany({
      where: {
        isActive: true,
        planStatus: 'active'
      }
    });

    let createdCount = 0;

    for (const company of companies) {
      // Verificar se já existe mensalidade para o próximo mês
      const existingSubscription = await prisma.subscription.findFirst({
        where: {
          companyId: company.id,
          dueDate: {
            gte: new Date(nextMonth.getFullYear(), nextMonth.getMonth(), 1),
            lt: new Date(nextMonth.getFullYear(), nextMonth.getMonth() + 1, 1)
          }
        }
      });

      if (!existingSubscription) {
        // Definir valor baseado no tipo de plano
        let amount = 0;
        switch (company.planType) {
          case 'basic':
            amount = 99.90;
            break;
          case 'professional':
            amount = 199.90;
            break;
          case 'enterprise':
            amount = 399.90;
            break;
          default:
            amount = 99.90;
        }

        await prisma.subscription.create({
          data: {
            companyId: company.id,
            planType: company.planType,
            planStatus: company.planStatus,
            amount,
            dueDate: nextMonth,
            notes: `Mensalidade gerada automaticamente para ${nextMonth.toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' })}`
          }
        });

        createdCount++;
      }
    }

    return res.status(200).json({
      success: true,
      data: {
        count: createdCount,
        message: `${createdCount} mensalidades geradas para o próximo mês`
      }
    });

  } catch (error) {
    console.error('Erro ao gerar mensalidades:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Excluir mensalidade
export const deleteSubscription = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.subscription.delete({
      where: { id }
    });

    return res.status(200).json({
      success: true,
      message: 'Mensalidade excluída com sucesso'
    });

  } catch (error) {
    console.error('Erro ao excluir mensalidade:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

