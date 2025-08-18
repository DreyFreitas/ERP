import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

export class SettingsController {
  // ========================================
  // FORMAS DE PAGAMENTO
  // ========================================

  // Listar formas de pagamento
  async listPaymentMethods(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;

      const paymentMethods = await prisma.paymentMethod.findMany({
        where: { companyId },
        orderBy: { sortOrder: 'asc' }
      });

      return res.json({
        success: true,
        message: 'Formas de pagamento listadas com sucesso',
        data: paymentMethods
      });
    } catch (error) {
      console.error('Erro ao listar formas de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }

  // Criar forma de pagamento
  async createPaymentMethod(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { name, description, fee, color, sortOrder } = req.body;

      if (!name) {
        return res.status(400).json({
          success: false,
          message: 'Nome é obrigatório',
          data: null
        });
      }

      const paymentMethod = await prisma.paymentMethod.create({
        data: {
          companyId,
          name,
          description,
          fee: fee ? Number(fee) : null,
          color,
          sortOrder: sortOrder || 0
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Forma de pagamento criada com sucesso',
        data: paymentMethod
      });
    } catch (error) {
      console.error('Erro ao criar forma de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }

  // Atualizar forma de pagamento
  async updatePaymentMethod(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { id } = req.params;
      const { name, description, fee, color, sortOrder, isActive } = req.body;

      const paymentMethod = await prisma.paymentMethod.findFirst({
        where: { id, companyId }
      });

      if (!paymentMethod) {
        return res.status(404).json({
          success: false,
          message: 'Forma de pagamento não encontrada',
          data: null
        });
      }

      const updatedPaymentMethod = await prisma.paymentMethod.update({
        where: { id },
        data: {
          name,
          description,
          fee: fee ? Number(fee) : null,
          color,
          sortOrder: sortOrder || 0,
          isActive
        }
      });

      return res.json({
        success: true,
        message: 'Forma de pagamento atualizada com sucesso',
        data: updatedPaymentMethod
      });
    } catch (error) {
      console.error('Erro ao atualizar forma de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }

  // Deletar forma de pagamento
  async deletePaymentMethod(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { id } = req.params;

      const paymentMethod = await prisma.paymentMethod.findFirst({
        where: { id, companyId }
      });

      if (!paymentMethod) {
        return res.status(404).json({
          success: false,
          message: 'Forma de pagamento não encontrada',
          data: null
        });
      }

      await prisma.paymentMethod.delete({
        where: { id }
      });

      return res.json({
        success: true,
        message: 'Forma de pagamento deletada com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao deletar forma de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }

  // ========================================
  // PRAZOS DE PAGAMENTO
  // ========================================

  // Listar prazos de pagamento
  async listPaymentTerms(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;

      const paymentTerms = await prisma.paymentTerm.findMany({
        where: { companyId },
        orderBy: { sortOrder: 'asc' }
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
  }

  // Criar prazo de pagamento
  async createPaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { name, days, description, interest, sortOrder } = req.body;

      if (!name) {
        return res.status(400).json({
          success: false,
          message: 'Nome é obrigatório',
          data: null
        });
      }

      const paymentTerm = await prisma.paymentTerm.create({
        data: {
          companyId,
          name,
          days: days || 0,
          description,
          interest: interest ? Number(interest) : null,
          sortOrder: sortOrder || 0
        }
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
  }

  // Atualizar prazo de pagamento
  async updatePaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { id } = req.params;
      const { name, days, description, interest, sortOrder, isActive } = req.body;

      const paymentTerm = await prisma.paymentTerm.findFirst({
        where: { id, companyId }
      });

      if (!paymentTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      const updatedPaymentTerm = await prisma.paymentTerm.update({
        where: { id },
        data: {
          name,
          days: days || 0,
          description,
          interest: interest ? Number(interest) : null,
          sortOrder: sortOrder || 0,
          isActive
        }
      });

      return res.json({
        success: true,
        message: 'Prazo de pagamento atualizado com sucesso',
        data: updatedPaymentTerm
      });
    } catch (error) {
      console.error('Erro ao atualizar prazo de pagamento:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }

  // Deletar prazo de pagamento
  async deletePaymentTerm(req: Request, res: Response<ApiResponse>) {
    try {
      const { companyId } = (req as any).user;
      const { id } = req.params;

      const paymentTerm = await prisma.paymentTerm.findFirst({
        where: { id, companyId }
      });

      if (!paymentTerm) {
        return res.status(404).json({
          success: false,
          message: 'Prazo de pagamento não encontrado',
          data: null
        });
      }

      await prisma.paymentTerm.delete({
        where: { id }
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
  }
}

export const settingsController = new SettingsController();
