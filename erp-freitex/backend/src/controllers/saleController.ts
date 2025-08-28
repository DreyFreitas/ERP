import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

interface CreateSaleData {
  customerId?: string;
  items: {
    productId: string;
    variationId?: string;
    quantity: number;
    unitPrice: number;
    discount?: number;
  }[];
  paymentMethodId: string;
  paymentTermId?: string;
  discount?: number;
  discountAmount?: number;
  discountType?: 'percentage' | 'fixed';
  notes?: string;
  mixedPayments?: Array<{
    methodId: string;
    amount: number;
    originalAmount: number;
    fee?: number;
    paymentTermId?: string;
  }>;
}

interface UpdateSaleData {
  customerId?: string;
  paymentMethodId?: string;
  paymentTermId?: string;
  discount?: number;
  notes?: string;
  saleStatus?: 'COMPLETED' | 'CANCELLED' | 'RETURNED';
  paymentStatus?: 'PENDING' | 'PAID' | 'CANCELLED';
}

export const saleController = {
  // Listar todas as vendas
  async listSales(req: Request, res: Response<ApiResponse>) {
    try {
      const userId = (req as any).user.id;
      const { page = 1, limit = 20, status, customerId, startDate, endDate } = req.query;

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

      const skip = (Number(page) - 1) * Number(limit);
      
      // Construir filtros
      const where: any = {
        companyId: user.companyId,
        isActive: true
      };

      if (status) {
        where.saleStatus = status;
      }

      if (customerId) {
        where.customerId = customerId;
      }

      if (startDate && endDate) {
        where.createdAt = {
          gte: new Date(startDate as string),
          lte: new Date(endDate as string)
        };
      }

      const [sales, total] = await Promise.all([
        prisma.sale.findMany({
          where,
          include: {
            customer: {
              select: {
                id: true,
                name: true,
                email: true,
                phone: true
              }
            },
            paymentMethod: {
              select: {
                id: true,
                name: true,
                color: true
              }
            },
            paymentTerm: {
              select: {
                id: true,
                name: true,
                days: true,
                isInstallment: true,
                installmentsCount: true
              }
            },
            items: {
              include: {
                product: {
                  select: {
                    id: true,
                    name: true,
                    sku: true
                  }
                },
                variation: {
                  select: {
                    id: true,
                    sku: true,
                    size: true,
                    color: true,
                    model: true
                  }
                }
              }
            },
            installments: {
              orderBy: {
                installmentNumber: 'asc'
              }
            }
          },
          orderBy: {
            createdAt: 'desc'
          },
          skip,
          take: Number(limit)
        }),
        prisma.sale.count({ where })
      ]);

      return res.json({
        success: true,
        message: 'Vendas listadas com sucesso',
        data: {
          sales,
          pagination: {
            page: Number(page),
            limit: Number(limit),
            total,
            pages: Math.ceil(total / Number(limit))
          }
        }
      });
    } catch (error) {
      console.error('Erro ao listar vendas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar venda por ID
  async getSaleById(req: Request, res: Response<ApiResponse>) {
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

      const sale = await prisma.sale.findFirst({
        where: {
          id,
          companyId: user.companyId
        },
        include: {
          customer: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          paymentMethod: {
            select: {
              id: true,
              name: true,
              color: true,
              fee: true
            }
          },
          items: {
            include: {
              product: {
                select: {
                  id: true,
                  name: true,
                  sku: true,
                  description: true
                }
              },
              variation: {
                select: {
                  id: true,
                  sku: true,
                  size: true,
                  color: true,
                  model: true
                }
              }
            }
          }
        }
      });

      if (!sale) {
        return res.status(404).json({
          success: false,
          message: 'Venda não encontrada',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Venda encontrada com sucesso',
        data: sale
      });
    } catch (error) {
      console.error('Erro ao buscar venda:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar nova venda
  async createSale(req: Request, res: Response<ApiResponse>) {
    try {
      const userId = (req as any).user.id;
      const saleData: CreateSaleData = req.body;

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

      // Validações
      if (!saleData.items || saleData.items.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'A venda deve ter pelo menos um item',
          data: null
        });
      }

      if (!saleData.paymentMethodId) {
        return res.status(400).json({
          success: false,
          message: 'Método de pagamento é obrigatório',
          data: null
        });
      }

      // Verificar se o método de pagamento existe
      const paymentMethod = await prisma.paymentMethod.findFirst({
        where: {
          id: saleData.paymentMethodId,
          companyId: user.companyId,
          isActive: true
        }
      });

      if (!paymentMethod) {
        return res.status(400).json({
          success: false,
          message: 'Método de pagamento não encontrado',
          data: null
        });
      }

      // Verificar se o prazo de pagamento existe (se fornecido)
      let paymentTerm: any = null;
      console.log('=== DEBUG PAYMENT TERM ===');
      console.log('saleData.paymentTermId:', saleData.paymentTermId);
      console.log('user.companyId:', user.companyId);
      
      if (saleData.paymentTermId) {
        paymentTerm = await prisma.paymentTerm.findFirst({
          where: {
            id: saleData.paymentTermId,
            companyId: user.companyId,
            isActive: true
          }
        });

        console.log('paymentTerm encontrado:', paymentTerm);

        if (!paymentTerm) {
          return res.status(400).json({
            success: false,
            message: 'Prazo de pagamento não encontrado',
            data: null
          });
        }
      }

      // Verificar se o cliente existe (se fornecido)
      let customer: any = null;
      if (saleData.customerId) {
        customer = await prisma.customer.findFirst({
          where: {
            id: saleData.customerId,
            companyId: user.companyId,
            isActive: true
          }
        });

        if (!customer) {
          return res.status(400).json({
            success: false,
            message: 'Cliente não encontrado',
            data: null
          });
        }
      }

      // Regras de venda a prazo: se houve selection de prazo, cliente é obrigatório e deve estar apto
      const isInstallmentSale = Boolean(saleData.paymentTermId);
      if (isInstallmentSale) {
        if (!saleData.customerId) {
          return res.status(400).json({
            success: false,
            message: 'Cliente é obrigatório para vendas a prazo',
            data: null
          });
        }

        // Validar capacidade de crédito do cliente
        if (customer) {
          // Bloqueios
          if (customer.allowCreditPurchases === false) {
            return res.status(400).json({
              success: false,
              message: 'Cliente não está autorizado a comprar a prazo',
              data: null
            });
          }
          if (customer.creditStatus && customer.creditStatus !== 'ACTIVE') {
            return res.status(400).json({
              success: false,
              message: 'Cliente com crédito não ativo para compras a prazo',
              data: null
            });
          }
        }
      }

      // Verificar produtos e estoque
      for (const item of saleData.items) {
        const product = await prisma.product.findFirst({
          where: {
            id: item.productId,
            companyId: user.companyId,
            isActive: true
          },
          include: {
            variations: true
          }
        });

        if (!product) {
          return res.status(400).json({
            success: false,
            message: `Produto ${item.productId} não encontrado`,
            data: null
          });
        }

        // Verificar variação se fornecida
        if (item.variationId) {
          const variation = product.variations.find(v => v.id === item.variationId);
          if (!variation) {
            return res.status(400).json({
              success: false,
              message: `Variação ${item.variationId} não encontrada para o produto ${product.name}`,
              data: null
            });
          }
        }

        // Verificar estoque - usando a tabela de variações se houver variação
        let currentStock = 0;
        if (item.variationId) {
          const variation = await prisma.productVariation.findUnique({
            where: { id: item.variationId }
          });
          currentStock = variation ? variation.stockQuantity : 0;
        } else {
          // Para produtos sem variação, usar o estoque do produto principal
          currentStock = product.minStock || 0;
        }

        // TEMPORÁRIO: Comentado para permitir teste de impressão
        // if (currentStock < item.quantity) {
        //   return res.status(400).json({
        //     success: false,
        //     message: `Estoque insuficiente para o produto ${product.name}. Disponível: ${currentStock}, Solicitado: ${item.quantity}`,
        //     data: null
        //   });
        // }
      }

      // Gerar número da venda
      const lastSale = await prisma.sale.findFirst({
        where: {
          companyId: user.companyId
        },
        orderBy: {
          createdAt: 'desc'
        }
      });

      const saleNumber = lastSale 
        ? `VDA${String(parseInt(lastSale.saleNumber.replace('VDA', '')) + 1).padStart(6, '0')}`
        : 'VDA000001';

      // Calcular totais
      const itemsTotal = saleData.items.reduce((sum, item) => {
        const itemTotal = (item.unitPrice * item.quantity) - (item.discount || 0);
        return sum + itemTotal;
      }, 0);

      // Calcular desconto
      let discountValue = 0;
      if (saleData.discountAmount && saleData.discountType) {
        if (saleData.discountType === 'percentage') {
          discountValue = (itemsTotal * saleData.discountAmount) / 100;
        } else {
          discountValue = saleData.discountAmount;
        }
      } else {
        discountValue = saleData.discount || 0;
      }

      const subtotalAfterDiscount = itemsTotal - discountValue;

      // Calcular taxas de pagamento
      let totalFees = 0;
      let finalAmount = subtotalAfterDiscount;

      console.log('=== DEBUG CÁLCULO FINAL AMOUNT ===');
      console.log('subtotalAfterDiscount:', subtotalAfterDiscount);
      console.log('saleData.mixedPayments:', saleData.mixedPayments);

      if (saleData.mixedPayments && saleData.mixedPayments.length > 0) {
        // Calcular taxas dos pagamentos mistos
        totalFees = saleData.mixedPayments.reduce((sum, payment) => {
          const fee = payment.fee || 0;
          const originalAmount = payment.originalAmount || payment.amount || 0;
          const feeAmount = (originalAmount * fee) / 100;
          console.log('payment.originalAmount:', payment.originalAmount);
          console.log('payment.amount:', payment.amount);
          console.log('originalAmount usado:', originalAmount);
          console.log('payment.fee:', payment.fee);
          console.log('feeAmount:', feeAmount);
          return sum + feeAmount;
        }, 0);
        finalAmount = subtotalAfterDiscount + totalFees;
        console.log('totalFees (mixed):', totalFees);
        console.log('finalAmount (mixed):', finalAmount);
      } else {
        // Calcular taxa do método de pagamento único
        const fee = Number(paymentMethod.fee) || 0;
        if (fee > 0) {
          totalFees = (subtotalAfterDiscount * fee) / 100;
          finalAmount = subtotalAfterDiscount + totalFees;
        }
        console.log('totalFees (single):', totalFees);
        console.log('finalAmount (single):', finalAmount);
      }

      // Determinar o status do pagamento baseado no método/prazo de pagamento
      let paymentStatus: 'PENDING' | 'PAID' = 'PENDING';
      // Se não há prazo de pagamento (pagamento à vista), marcar como PAGO
      if (!saleData.paymentTermId) {
        paymentStatus = 'PAID';
      }
      
      // Calcular parcelas se for venda parcelada
      let installments: Array<{ amount: number; dueDate: Date }> = [];
      
      console.log('=== DEBUG PARCELAMENTO ===');
      console.log('saleData.paymentTermId:', saleData.paymentTermId);
      console.log('paymentTerm:', paymentTerm);
      console.log('paymentTerm?.isInstallment:', paymentTerm?.isInstallment);
      
      if (saleData.paymentTermId && paymentTerm && paymentTerm.isInstallment) {
        console.log('✅ Criando parcelas...');
        const installmentsCount = Number(paymentTerm.installmentsCount) || 1;
        const installmentInterval = Number(paymentTerm.installmentInterval) || 30;
        const installmentAmount = finalAmount / installmentsCount;
        
        console.log('installmentsCount:', installmentsCount);
        console.log('installmentInterval:', installmentInterval);
        console.log('installmentAmount:', installmentAmount);
        console.log('finalAmount:', finalAmount);
        
        // Calcular data da primeira parcela baseada na configuração do prazo
        const firstDueDate = new Date();
        const daysToFirstInstallment = Number(paymentTerm.days) || 30;
        firstDueDate.setDate(firstDueDate.getDate() + daysToFirstInstallment);
        
        console.log('daysToFirstInstallment:', daysToFirstInstallment);
        console.log('firstDueDate:', firstDueDate);
        
        for (let i = 0; i < installmentsCount; i++) {
          const dueDate = new Date(firstDueDate);
          dueDate.setDate(dueDate.getDate() + (i * installmentInterval));
          installments.push({
            amount: installmentAmount,
            dueDate: dueDate
          });
        }
        
        console.log('✅ Parcelas criadas:', installments);
      } else {
        console.log('❌ Não criou parcelas - condições não atendidas');
        console.log('saleData.paymentTermId:', saleData.paymentTermId);
        console.log('paymentTerm:', paymentTerm);
        console.log('paymentTerm?.isInstallment:', paymentTerm?.isInstallment);
      }
      
      // Criar a venda
      const sale = await prisma.sale.create({
        data: {
          companyId: user.companyId,
          customerId: saleData.customerId,
          saleNumber,
          totalAmount: subtotalAfterDiscount,
          discount: discountValue,
          discountType: saleData.discountType,
          totalFees,
          finalAmount,
          paymentMethodId: saleData.paymentMethodId,
          paymentTermId: saleData.paymentTermId,
          paymentStatus,
          notes: saleData.notes,
          // Para vendas parceladas, usar a data da primeira parcela
          dueDate: installments.length > 0 ? installments[0].dueDate : 
            (saleData.paymentTermId
              ? (paymentTerm && paymentTerm.days
                  ? new Date(Date.now() + Number(paymentTerm.days) * 24 * 60 * 60 * 1000)
                  : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000))
              : null)
        }
      });

      // Criar os itens da venda
      const saleItems = await Promise.all(
        saleData.items.map(item => 
          prisma.saleItem.create({
            data: {
              saleId: sale.id,
              productId: item.productId,
              variationId: item.variationId,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              totalPrice: (item.unitPrice * item.quantity) - (item.discount || 0),
              discount: item.discount || 0
            }
          })
        )
      );

      // Atualizar estoque
      for (const item of saleData.items) {
        if (item.variationId) {
          // Atualizar estoque da variação
          await prisma.productVariation.update({
            where: { id: item.variationId },
            data: {
              stockQuantity: {
                decrement: item.quantity
              }
            }
          });
        }

        // Registrar movimento de estoque
        await prisma.stockMovement.create({
          data: {
            productId: item.productId,
            variationId: item.variationId,
            movementType: 'EXIT',
            quantity: item.quantity,
            referenceDocument: `Venda ${saleNumber}`,
            notes: `Venda realizada via PDV`,
            userId
          }
        });
      }

      // Se venda a prazo, validar limite e atualizar consumo de crédito
      if (isInstallmentSale && customer) {
        const creditLimit = Number(customer.creditLimit || 0);
        const creditUsed = Number(customer.creditUsed || 0);
        const available = creditLimit - creditUsed;
        if (creditLimit > 0 && available < Number(finalAmount)) {
          return res.status(400).json({
            success: false,
            message: 'Cliente sem limite de crédito suficiente para esta venda',
            data: null
          });
        }

        // Atualizar uso de crédito do cliente
        await prisma.customer.update({
          where: { id: customer.id },
          data: {
            creditUsed: Number(creditUsed) + Number(finalAmount),
            creditAvailable: creditLimit > 0 ? (Number(creditLimit) - (Number(creditUsed) + Number(finalAmount))) : null
          }
        });
      }

      // Criar transação financeira automaticamente
      try {
        // Buscar a conta configurada para o método de pagamento
        let targetAccount = null;
        
        if (paymentMethod.accountId) {
          // Usar a conta configurada no método de pagamento
          targetAccount = await prisma.financialAccount.findFirst({
            where: {
              id: paymentMethod.accountId,
              companyId: user.companyId,
              isActive: true
            }
          });
        }
        
        // Se não há conta configurada, usar conta de caixa padrão
        if (!targetAccount) {
          targetAccount = await prisma.financialAccount.findFirst({
            where: {
              companyId: user.companyId,
              accountType: 'CASH',
              isActive: true
            }
          });

          // Se não existir conta de caixa, criar uma
          if (!targetAccount) {
            targetAccount = await prisma.financialAccount.create({
              data: {
                companyId: user.companyId,
                name: 'Caixa Principal',
                accountType: 'CASH',
                initialBalance: 0,
                currentBalance: 0,
                isActive: true
              }
            });
          }
        }

        console.log('=== DEBUG FINANCIAL TRANSACTION ===');
        console.log('targetAccount:', targetAccount);
        console.log('installments.length:', installments.length);
        console.log('installments:', installments);
        
              // Criar parcelas se for venda parcelada
      if (installments.length > 0) {
        console.log('✅ Criando parcelas da venda...');
        // Criar uma parcela para cada installment
        for (let i = 0; i < installments.length; i++) {
          const installment = installments[i];
          console.log(`Criando parcela ${i + 1}:`, installment);
          await prisma.saleInstallment.create({
            data: {
              saleId: sale.id,
              installmentNumber: i + 1,
              amount: installment.amount,
              dueDate: installment.dueDate,
              status: 'PENDING',
              notes: `Parcela ${i + 1}/${installments.length} da venda ${saleNumber}`
            }
          });
          console.log(`✅ Parcela ${i + 1} criada com sucesso`);
        }
      }

      // Criar transações financeiras
      if (installments.length > 0) {
        console.log('✅ Criando transações para parcelas...');
        // Criar uma transação para cada parcela
        for (let i = 0; i < installments.length; i++) {
          const installment = installments[i];
          console.log(`Criando transação para parcela ${i + 1}:`, installment);
          await prisma.financialTransaction.create({
            data: {
              companyId: user.companyId,
              accountId: targetAccount.id,
              transactionType: 'INCOME',
              description: `Venda ${saleNumber} - Parcela ${i + 1}/${installments.length} - ${saleData.customerId ? 'Com cliente' : 'Sem cliente'}`,
              amount: installment.amount,
              paymentDate: null, // Pendente
              dueDate: installment.dueDate,
              status: 'PENDING',
              category: 'Vendas',
              referenceDocument: `${saleNumber}-P${i + 1}`,
              notes: `Parcela ${i + 1}/${installments.length} da venda ${saleNumber} - Método: ${paymentMethod.name}`,
              userId
            }
          });
          console.log(`✅ Transação para parcela ${i + 1} criada com sucesso`);
        }
      } else {
          // Criar transação única (à vista ou a prazo sem parcelamento)
          await prisma.financialTransaction.create({
            data: {
              companyId: user.companyId,
              accountId: targetAccount.id,
              transactionType: 'INCOME',
              description: `Venda ${saleNumber} - ${saleData.customerId ? 'Com cliente' : 'Sem cliente'}`,
              amount: finalAmount,
              paymentDate: paymentStatus === 'PAID' ? new Date() : null,
              dueDate: sale.dueDate,
              status: paymentStatus === 'PAID' ? 'PAID' : 'PENDING',
              category: 'Vendas',
              referenceDocument: saleNumber,
              notes: `Venda realizada via PDV - Método: ${paymentMethod.name}`,
              userId
            }
          });
        }

        // Atualizar saldo da conta somente para vendas à vista
        if (paymentStatus === 'PAID') {
          await prisma.financialAccount.update({
            where: { id: targetAccount.id },
            data: {
              currentBalance: {
                increment: finalAmount
              }
            }
          });
        }
      } catch (financialError) {
        console.error('Erro ao criar transação financeira:', financialError);
        // Não falhar a venda se a transação financeira falhar
      }

      // Buscar a venda criada com todos os relacionamentos
      const createdSale = await prisma.sale.findUnique({
        where: { id: sale.id },
        include: {
          customer: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          paymentMethod: {
            select: {
              id: true,
              name: true,
              color: true
            }
          },
          items: {
            include: {
              product: {
                select: {
                  id: true,
                  name: true,
                  sku: true
                }
              },
              variation: {
                select: {
                  id: true,
                  sku: true,
                  size: true,
                  color: true,
                  model: true
                }
              }
            }
          }
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Venda criada com sucesso',
        data: createdSale
      });
    } catch (error) {
      console.error('Erro ao criar venda:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Calcular preview de parcelas
  async calculateInstallmentPreview(req: Request, res: Response<ApiResponse>) {
    try {
      const { paymentTermId, amount } = req.body;
      
      if (!paymentTermId || !amount) {
        return res.status(400).json({
          success: false,
          message: 'paymentTermId e amount são obrigatórios',
          data: null
        });
      }

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
        return res.status(400).json({
          success: false,
          message: 'Este prazo não é parcelado',
          data: null
        });
      }

      const installmentsCount = Number(paymentTerm.installmentsCount) || 1;
      const installmentInterval = Number(paymentTerm.installmentInterval) || 30;
      const installmentAmount = Number(amount) / installmentsCount;
      
      // Calcular data da primeira parcela baseada na configuração do prazo
      const firstDueDate = new Date();
      const daysToFirstInstallment = Number(paymentTerm.days) || 30;
      firstDueDate.setDate(firstDueDate.getDate() + daysToFirstInstallment);

      const installments = [];
      for (let i = 0; i < installmentsCount; i++) {
        const dueDate = new Date(firstDueDate);
        dueDate.setDate(dueDate.getDate() + (i * installmentInterval));
        installments.push({
          number: i + 1,
          amount: installmentAmount,
          dueDate: dueDate
        });
      }

      return res.status(200).json({
        success: true,
        message: 'Preview de parcelas calculado com sucesso',
        data: installments
      });
    } catch (error) {
      console.error('Erro ao calcular preview de parcelas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Listar parcelas de uma venda
  async listSaleInstallments(req: Request, res: Response<ApiResponse>) {
    try {
      const { saleId } = req.params;
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

      // Verificar se a venda pertence à empresa do usuário
      const sale = await prisma.sale.findFirst({
        where: {
          id: saleId,
          companyId: user.companyId
        }
      });

      if (!sale) {
        return res.status(404).json({
          success: false,
          message: 'Venda não encontrada',
          data: null
        });
      }

      // Buscar as parcelas da venda
      const installments = await prisma.saleInstallment.findMany({
        where: {
          saleId: saleId
        },
        orderBy: {
          installmentNumber: 'asc'
        }
      });

      return res.status(200).json({
        success: true,
        message: 'Parcelas listadas com sucesso',
        data: installments
      });
    } catch (error) {
      console.error('Erro ao listar parcelas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar venda
  async updateSale(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const updateData: UpdateSaleData = req.body;
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

      // Verificar se a venda existe
      const existingSale = await prisma.sale.findFirst({
        where: {
          id,
          companyId: user.companyId
        }
      });

      if (!existingSale) {
        return res.status(404).json({
          success: false,
          message: 'Venda não encontrada',
          data: null
        });
      }

      // Validações específicas
      if (updateData.paymentMethodId) {
        const paymentMethod = await prisma.paymentMethod.findFirst({
          where: {
            id: updateData.paymentMethodId,
            companyId: user.companyId,
            isActive: true
          }
        });

        if (!paymentMethod) {
          return res.status(400).json({
            success: false,
            message: 'Método de pagamento não encontrado',
            data: null
          });
        }
      }

      if (updateData.customerId) {
        const customer = await prisma.customer.findFirst({
          where: {
            id: updateData.customerId,
            companyId: user.companyId,
            isActive: true
          }
        });

        if (!customer) {
          return res.status(400).json({
            success: false,
            message: 'Cliente não encontrado',
            data: null
          });
        }
      }

      // Atualizar a venda
      const updatedSale = await prisma.sale.update({
        where: { id },
        data: updateData,
        include: {
          customer: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          paymentMethod: {
            select: {
              id: true,
              name: true,
              color: true
            }
          },
          items: {
            include: {
              product: {
                select: {
                  id: true,
                  name: true,
                  sku: true
                }
              },
              variation: {
                select: {
                  id: true,
                  sku: true,
                  size: true,
                  color: true,
                  model: true
                }
              }
            }
          }
        }
      });

      return res.json({
        success: true,
        message: 'Venda atualizada com sucesso',
        data: updatedSale
      });
    } catch (error) {
      console.error('Erro ao atualizar venda:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Cancelar venda
  async cancelSale(req: Request, res: Response<ApiResponse>) {
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

      // Verificar se a venda existe
      const sale = await prisma.sale.findFirst({
        where: {
          id,
          companyId: user.companyId
        },
        include: {
          items: true
        }
      });

      if (!sale) {
        return res.status(404).json({
          success: false,
          message: 'Venda não encontrada',
          data: null
        });
      }

      if (sale.saleStatus === 'CANCELLED') {
        return res.status(400).json({
          success: false,
          message: 'Venda já está cancelada',
          data: null
        });
      }

      // Atualizar status da venda
      await prisma.sale.update({
        where: { id },
        data: {
          saleStatus: 'CANCELLED',
          paymentStatus: 'CANCELLED'
        }
      });

      // Restaurar estoque
      for (const item of sale.items) {
        if (item.variationId) {
          // Restaurar estoque da variação
          await prisma.productVariation.update({
            where: { id: item.variationId },
            data: {
              stockQuantity: {
                increment: item.quantity
              }
            }
          });
        }

        // Registrar movimento de estoque
        await prisma.stockMovement.create({
          data: {
            productId: item.productId,
            variationId: item.variationId,
            movementType: 'ENTRY',
            quantity: item.quantity,
            referenceDocument: `Cancelamento da venda ${sale.saleNumber}`,
            notes: `Estoque restaurado devido ao cancelamento da venda`,
            userId
          }
        });
      }

      return res.json({
        success: true,
        message: 'Venda cancelada com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao cancelar venda:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Estatísticas de vendas
  async getSalesStats(req: Request, res: Response<ApiResponse>) {
    try {
      const userId = (req as any).user.id;
      let period = 30;
      if (req.query.period) {
        // Se period for um objeto (como { period: 30 }), extrair o valor
        if (typeof req.query.period === 'object') {
          period = Number(Object.values(req.query.period)[0]) || 30;
        } else {
          period = Number(req.query.period) || 30;
        }
      }

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

      const startDate = new Date();
      startDate.setDate(startDate.getDate() - Number(period));

      // Vendas do período
      const sales = await prisma.sale.findMany({
        where: {
          companyId: user.companyId,
          createdAt: {
            gte: startDate
          },
          saleStatus: 'COMPLETED',
          isActive: true
        }
      });

      // Estatísticas
      const totalSales = sales.length;
      const totalRevenue = sales.reduce((sum, sale) => sum + Number(sale.totalAmount), 0);
      const averageTicket = totalSales > 0 ? totalRevenue / totalSales : 0;

      // Vendas por dia (últimos 7 dias)
      const dailySales = [];
      for (let i = 6; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        date.setHours(0, 0, 0, 0);

        const nextDate = new Date(date);
        nextDate.setDate(nextDate.getDate() + 1);

        const daySales = sales.filter(sale => 
          sale.createdAt >= date && sale.createdAt < nextDate
        );

        dailySales.push({
          date: date.toISOString().split('T')[0],
          count: daySales.length,
          revenue: daySales.reduce((sum, sale) => sum + Number(sale.totalAmount), 0)
        });
      }

      // Top produtos vendidos
      const topProducts = await prisma.saleItem.groupBy({
        by: ['productId'],
        where: {
          sale: {
            companyId: user.companyId,
            createdAt: {
              gte: startDate
            },
            saleStatus: 'COMPLETED',
            isActive: true
          }
        },
        _sum: {
          quantity: true,
          totalPrice: true
        },
        orderBy: {
          _sum: {
            quantity: 'desc'
          }
        },
        take: 5
      });

      const topProductsWithDetails = await Promise.all(
        topProducts.map(async (item) => {
          const product = await prisma.product.findUnique({
            where: { id: item.productId },
            select: { name: true, sku: true }
          });

          return {
            productId: item.productId,
            productName: product?.name || 'Produto não encontrado',
            sku: product?.sku || '',
            quantity: item._sum.quantity || 0,
            revenue: Number(item._sum.totalPrice || 0)
          };
        })
      );

      return res.json({
        success: true,
        message: 'Estatísticas de vendas obtidas com sucesso',
        data: {
          period: Number(period),
          totalSales,
          totalRevenue,
          averageTicket,
          dailySales,
          topProducts: topProductsWithDetails
        }
      });
    } catch (error) {
      console.error('Erro ao obter estatísticas de vendas:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
