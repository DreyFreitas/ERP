import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

interface CreatePaymentTermData {
  name: string;
  days: number;
  description?: string;
  interest?: number;
  sortOrder?: number;
  isInstallment?: boolean;
  installmentsCount?: number;
  installmentInterval?: number;
}

interface UpdatePaymentTermData {
  name?: string;
  days?: number;
  description?: string;
  interest?: number;
  sortOrder?: number;
  isActive?: boolean;
  isInstallment?: boolean;
  installmentsCount?: number;
  installmentInterval?: number;
}

export const paymentTermController = {
  // Listar todos os prazos de pagamento
  async listPaymentTerms(req: Request, res: Response<ApiResponse>) {
    try {
      const userId = (req as any).user.id;
      
      // Buscar usuário e sua empresa
      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId || !user.company) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      const paymentTerms = await prisma.paymentTerm.findMany({
        where: {
          companyId: user.companyId,
          isActive: true
        },
        orderBy: {
          sortOrder: 'asc'
        }
      });

      return res.json({
        success: true,
        message: 'Prazos de pagamento listados com sucesso',
        data: paymentTerms
      });
    } catch (error) {
      console.error('Erro ao listar prazos de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar prazo de pagamento por ID
  async getPaymentTermById(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const userId = (req as any).user.id;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      const paymentTerm = await prisma.paymentTerm.findFirst({
        where: {
          id,
          companyId: user.companyId
        }
      });

      if (!paymentTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Prazo de pagamento encontrado com sucesso',
        data: paymentTerm
      });
    } catch (error) {
      console.error('Erro ao buscar prazo de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar novo prazo de pagamento
  async createPaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const {
        name,
        days,
        description,
        interest = 0,
        sortOrder = 0,
        isInstallment = false,
        installmentsCount,
        installmentInterval
      } = req.body;

      // Debug: Log dos dados recebidos
      console.log('Dados recebidos para criar prazo de pagamento:', {
        name,
        days,
        description,
        interest,
        sortOrder,
        isInstallment,
        installmentsCount,
        installmentInterval
      });

      const userId = (req as any).user.id;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId || !user.company) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      // Validações
      if (!name) {
        return res.status(400).json({
          success: false,
          message: 'Nome é obrigatório',
          data: null
        });
      }

      if (days < 0) {
        return res.status(400).json({
          success: false,
          message: 'Dias deve ser maior ou igual a zero',
          data: null
        });
      }

      // Validações para parcelamento
      if (isInstallment) {
        if (!installmentsCount || installmentsCount < 2) {
          return res.status(400).json({
            success: false,
            message: 'Número de parcelas deve ser maior ou igual a 2',
            data: null
          });
        }

        if (!installmentInterval || installmentInterval < 1) {
          return res.status(400).json({
            success: false,
            message: 'Intervalo entre parcelas deve ser maior que zero',
            data: null
          });
        }
      }

      // Verificar se já existe um prazo com o mesmo nome na empresa
      const existingTerm = await prisma.paymentTerm.findFirst({
        where: {
          name,
          companyId: user.companyId
        }
      });

      if (existingTerm) {
        return res.status(400).json({
          success: false,
          message: 'Já existe um prazo de pagamento com este nome',
          data: null
        });
      }

      const paymentTermData = {
        companyId: user.companyId,
        name,
        days,
        description,
        interest,
        sortOrder,
        isInstallment,
        installmentsCount,
        installmentInterval
      };

      // Debug: Log dos dados que serão salvos
      console.log('Dados que serão salvos no banco:', paymentTermData);

      const paymentTerm = await prisma.paymentTerm.create({
        data: paymentTermData
      });

      return res.status(201).json({
        success: true,
        message: 'Prazo de pagamento criado com sucesso',
        data: paymentTerm
      });
    } catch (error) {
      console.error('Erro ao criar prazo de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar prazo de pagamento
  async updatePaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const updateData = req.body;

      const userId = (req as any).user.id;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      // Verificar se o prazo existe e pertence à empresa
      const existingTerm = await prisma.paymentTerm.findFirst({
        where: {
          id,
          companyId: user.companyId
        }
      });

      if (!existingTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      // Validações
      if (updateData.days !== undefined && updateData.days < 0) {
        return res.status(400).json({
          success: false,
          message: 'Dias deve ser maior ou igual a zero',
          data: null
        });
      }

      // Validações para parcelamento
      if (updateData.isInstallment) {
        if (!updateData.installmentsCount || updateData.installmentsCount < 2) {
          return res.status(400).json({
            success: false,
            message: 'Número de parcelas deve ser maior ou igual a 2',
            data: null
          });
        }

        if (!updateData.installmentInterval || updateData.installmentInterval < 1) {
          return res.status(400).json({
            success: false,
            message: 'Intervalo entre parcelas deve ser maior que zero',
            data: null
          });
        }
      }

      // Verificar se o nome já existe (se estiver sendo alterado)
      if (updateData.name && updateData.name !== existingTerm.name) {
        const nameExists = await prisma.paymentTerm.findFirst({
          where: {
            name: updateData.name,
            companyId: user.companyId,
            id: { not: id }
          }
        });

        if (nameExists) {
          return res.status(400).json({
            success: false,
            message: 'Já existe um prazo de pagamento com este nome',
            data: null
          });
        }
      }

      const updatedTerm = await prisma.paymentTerm.update({
        where: { id },
        data: updateData
      });

      return res.json({
        success: true,
        message: 'Prazo de pagamento atualizado com sucesso',
        data: updatedTerm
      });
    } catch (error) {
      console.error('Erro ao atualizar prazo de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Deletar prazo de pagamento
  async deletePaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const userId = (req as any).user.id;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      // Verificar se o prazo existe e pertence à empresa
      const existingTerm = await prisma.paymentTerm.findFirst({
        where: {
          id,
          companyId: user.companyId
        }
      });

      if (!existingTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      // Soft delete - apenas desativar
      await prisma.paymentTerm.update({
        where: { id },
        data: { isActive: false }
      });

      return res.json({
        success: true,
        message: 'Prazo de pagamento deletado com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao deletar prazo de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Calcular parcelas (função auxiliar)
  async calculateInstallments(req: Request, res: Response<ApiResponse>) {
    try {
      const { paymentTermId, totalAmount } = req.body;

      const userId = (req as any).user.id;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { company: true }
      });

      if (!user || !user.companyId) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não associado a uma empresa',
          data: null
        });
      }

      const paymentTerm = await prisma.paymentTerm.findFirst({
        where: {
          id: paymentTermId,
          companyId: user.companyId,
          isActive: true
        }
      });

      if (!paymentTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      if (!paymentTerm.isInstallment) {
        return res.json({
          success: true,
          message: 'Prazo não permite parcelamento',
          data: {
            installments: [{
              number: 1,
              amount: totalAmount,
              dueDate: new Date(Date.now() + paymentTerm.days * 24 * 60 * 60 * 1000)
            }]
          }
        });
      }

      // Calcular parcelas
      const installmentAmount = totalAmount / paymentTerm.installmentsCount!;
      const installments = [];

      for (let i = 1; i <= paymentTerm.installmentsCount!; i++) {
        const dueDate = new Date(Date.now() + (paymentTerm.days + (i - 1) * paymentTerm.installmentInterval!) * 24 * 60 * 60 * 1000);
        
        installments.push({
          number: i,
          amount: installmentAmount,
          dueDate: dueDate
        });
      }

      return res.json({
        success: true,
        message: 'Parcelas calculadas com sucesso',
        data: {
          paymentTerm,
          installments
        }
      });
    } catch (error) {
      console.error('Erro ao calcular parcelas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
