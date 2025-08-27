import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { MovementType } from '@prisma/client';

const prisma = new PrismaClient();

export class StockController {
  // Registrar entrada de estoque
  async registerEntry(req: Request, res: Response): Promise<void> {
    try {
      const { productId, variationId, quantity, unitCost, referenceDocument, notes } = req.body;
      const userId = (req as any).user.id;
      const companyId = (req as any).user.companyId;

      // Validar dados obrigatórios
      if (!productId || !quantity || quantity <= 0) {
        res.status(400).json({
          success: false,
          message: 'Produto e quantidade são obrigatórios'
        });
        return;
      }

      // Verificar se o produto existe e pertence à empresa
      const product = await prisma.product.findFirst({
        where: {
          id: productId,
          companyId: companyId
        },
        include: {
          variations: true
        }
      });

      if (!product) {
        res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
        return;
      }

      // Se for variação, verificar se existe
      if (variationId) {
        const variation = product.variations.find(v => v.id === variationId);
        if (!variation) {
          res.status(404).json({
            success: false,
            message: 'Variação não encontrada'
          });
          return;
        }
      }

      // Calcular custo total
      const totalCost = unitCost ? unitCost * quantity : null;

      // Registrar movimentação
      const movement = await prisma.stockMovement.create({
        data: {
          productId,
          variationId: variationId || null,
          movementType: MovementType.ENTRY,
          quantity,
          unitCost,
          totalCost,
          referenceDocument,
          notes,
          userId
        }
      });

      // Atualizar estoque
      if (variationId) {
        // Atualizar variação específica
        await prisma.productVariation.update({
          where: { id: variationId },
          data: {
            stockQuantity: {
              increment: quantity
            }
          }
        });
      } else {
        // Atualizar todas as variações do produto (distribuir igualmente)
        const variations = await prisma.productVariation.findMany({
          where: { productId }
        });

        if (variations.length > 0) {
          const quantityPerVariation = Math.floor(quantity / variations.length);
          const remainder = quantity % variations.length;

          for (let i = 0; i < variations.length; i++) {
            const extraQuantity = i < remainder ? 1 : 0;
            await prisma.productVariation.update({
              where: { id: variations[i].id },
              data: {
                stockQuantity: {
                  increment: quantityPerVariation + extraQuantity
                }
              }
            });
          }
        }
      }

      res.status(201).json({
        success: true,
        message: 'Entrada de estoque registrada com sucesso',
        data: movement
      });

    } catch (error) {
      console.error('Erro ao registrar entrada de estoque:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Registrar saída de estoque
  async registerExit(req: Request, res: Response): Promise<void> {
    try {
      const { productId, variationId, quantity, referenceDocument, notes } = req.body;
      const userId = (req as any).user.id;
      const companyId = (req as any).user.companyId;

      // Validar dados obrigatórios
      if (!productId || !quantity || quantity <= 0) {
        res.status(400).json({
          success: false,
          message: 'Produto e quantidade são obrigatórios'
        });
        return;
      }

      // Verificar se o produto existe e pertence à empresa
      const product = await prisma.product.findFirst({
        where: {
          id: productId,
          companyId: companyId
        },
        include: {
          variations: true
        }
      });

      if (!product) {
        res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
        return;
      }

      // Verificar estoque disponível
      let currentStock = 0;
      if (variationId) {
        const variation = product.variations.find(v => v.id === variationId);
        if (!variation) {
          res.status(404).json({
            success: false,
            message: 'Variação não encontrada'
          });
          return;
        }
        currentStock = variation.stockQuantity;
      } else {
        // Soma do estoque de todas as variações
        currentStock = product.variations.reduce((sum, v) => sum + v.stockQuantity, 0);
      }

      if (currentStock < quantity) {
        res.status(400).json({
          success: false,
          message: `Estoque insuficiente. Disponível: ${currentStock}, Solicitado: ${quantity}`
        });
        return;
      }

      // Registrar movimentação
      const movement = await prisma.stockMovement.create({
        data: {
          productId,
          variationId: variationId || null,
          movementType: MovementType.EXIT,
          quantity,
          previousQuantity: currentStock,
          newQuantity: currentStock - quantity,
          referenceDocument,
          notes,
          userId
        }
      });

      // Atualizar estoque
      if (variationId) {
        await prisma.productVariation.update({
          where: { id: variationId },
          data: {
            stockQuantity: {
              decrement: quantity
            }
          }
        });
      } else {
        // Distribuir saída entre variações (priorizar as com mais estoque)
        const variations = await prisma.productVariation.findMany({
          where: { productId },
          orderBy: { stockQuantity: 'desc' }
        });

        let remainingQuantity = quantity;
        for (const variation of variations) {
          if (remainingQuantity <= 0) break;
          
          const quantityToRemove = Math.min(remainingQuantity, variation.stockQuantity);
          await prisma.productVariation.update({
            where: { id: variation.id },
            data: {
              stockQuantity: {
                decrement: quantityToRemove
              }
            }
          });
          remainingQuantity -= quantityToRemove;
        }
      }

      res.status(201).json({
        success: true,
        message: 'Saída de estoque registrada com sucesso',
        data: movement
      });

    } catch (error) {
      console.error('Erro ao registrar saída de estoque:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Registrar entrada de estoque em lote (múltiplas variações)
  async registerBatchEntry(req: Request, res: Response): Promise<void> {
    try {
      const { productId, entries, referenceDocument, notes } = req.body;
      const userId = (req as any).user.id;
      const companyId = (req as any).user.companyId;

      // Validar dados obrigatórios
      if (!productId || !entries || !Array.isArray(entries) || entries.length === 0) {
        res.status(400).json({
          success: false,
          message: 'Produto e entradas são obrigatórios'
        });
        return;
      }

      // Verificar se o produto existe e pertence à empresa
      const product = await prisma.product.findFirst({
        where: {
          id: productId,
          companyId: companyId
        },
        include: {
          variations: true
        }
      });

      if (!product) {
        res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
        return;
      }

      const movements = [];

      // Processar cada entrada
      for (const entry of entries) {
        const { variationId, quantity, unitCost } = entry;

        if (!quantity || quantity <= 0) {
          continue; // Pular entradas inválidas
        }

        // Verificar se a variação existe (se fornecida)
        if (variationId) {
          const variation = product.variations.find(v => v.id === variationId);
          if (!variation) {
            continue; // Pular variação inexistente
          }
        }

        // Calcular custo total
        const totalCost = unitCost ? unitCost * quantity : null;

        // Registrar movimentação
        const movement = await prisma.stockMovement.create({
          data: {
            productId,
            variationId: variationId || null,
            movementType: MovementType.ENTRY,
            quantity,
            unitCost,
            totalCost,
            referenceDocument,
            notes,
            userId
          }
        });

        movements.push(movement);

        // Atualizar estoque
        if (variationId) {
          await prisma.productVariation.update({
            where: { id: variationId },
            data: {
              stockQuantity: {
                increment: quantity
              }
            }
          });
        }
      }

      res.status(201).json({
        success: true,
        message: 'Entradas de estoque registradas com sucesso',
        data: {
          movements,
          totalEntries: movements.length
        }
      });

    } catch (error) {
      console.error('Erro ao registrar entradas em lote:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Ajuste de estoque
  async adjustStock(req: Request, res: Response): Promise<void> {
    try {
      const { productId, variationId, newQuantity, reason, notes } = req.body;
      const userId = (req as any).user.id;
      const companyId = (req as any).user.companyId;

      // Validar dados obrigatórios
      if (!productId || newQuantity === undefined || newQuantity < 0) {
        res.status(400).json({
          success: false,
          message: 'Produto e nova quantidade são obrigatórios'
        });
        return;
      }

      // Verificar se o produto existe e pertence à empresa
      const product = await prisma.product.findFirst({
        where: {
          id: productId,
          companyId: companyId
        },
        include: {
          variations: true
        }
      });

      if (!product) {
        res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
        return;
      }

      // Obter estoque atual
      let currentStock = 0;
      if (variationId) {
        const variation = product.variations.find(v => v.id === variationId);
        if (!variation) {
          res.status(404).json({
            success: false,
            message: 'Variação não encontrada'
          });
          return;
        }
        currentStock = variation.stockQuantity;
      } else {
        currentStock = product.variations.reduce((sum, v) => sum + v.stockQuantity, 0);
      }

      // Calcular diferença
      const difference = newQuantity - currentStock;
      const movementType = difference > 0 ? MovementType.ENTRY : MovementType.EXIT;
      const quantity = Math.abs(difference);

      // Registrar movimentação
      const movement = await prisma.stockMovement.create({
        data: {
          productId,
          variationId: variationId || null,
          movementType,
          quantity,
          previousQuantity: currentStock,
          newQuantity,
          referenceDocument: reason,
          notes,
          userId
        }
      });

      // Atualizar estoque
      if (variationId) {
        await prisma.productVariation.update({
          where: { id: variationId },
          data: {
            stockQuantity: newQuantity
          }
        });
      } else {
        // Distribuir entre variações (se houver múltiplas)
        const variations = await prisma.productVariation.findMany({
          where: { productId }
        });

        if (variations.length > 0) {
          const quantityPerVariation = Math.floor(newQuantity / variations.length);
          const remainder = newQuantity % variations.length;

          for (let i = 0; i < variations.length; i++) {
            const extraQuantity = i < remainder ? 1 : 0;
            await prisma.productVariation.update({
              where: { id: variations[i].id },
              data: {
                stockQuantity: quantityPerVariation + extraQuantity
              }
            });
          }
        }
      }

      res.status(200).json({
        success: true,
        message: 'Estoque ajustado com sucesso',
        data: movement
      });

    } catch (error) {
      console.error('Erro ao ajustar estoque:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Listar movimentações de estoque
  async getStockMovements(req: Request, res: Response): Promise<void> {
    try {
      const { productId, variationId, movementType, startDate, endDate, page = 1, limit = 20 } = req.query;
      const companyId = (req as any).user.companyId;

      const skip = (Number(page) - 1) * Number(limit);

      // Construir filtros
      const where: any = {
        product: {
          companyId: companyId
        }
      };

      if (productId) where.productId = productId as string;
      if (variationId) where.variationId = variationId as string;
      if (movementType) where.movementType = movementType as MovementType;

      if (startDate || endDate) {
        where.createdAt = {};
        if (startDate) where.createdAt.gte = new Date(startDate as string);
        if (endDate) where.createdAt.lte = new Date(endDate as string);
      }

      // Buscar movimentações
      const [movements, total] = await Promise.all([
        prisma.stockMovement.findMany({
          where,
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
                size: true,
                color: true,
                model: true
              }
            }
          },
          orderBy: {
            createdAt: 'desc'
          },
          skip,
          take: Number(limit)
        }),
        prisma.stockMovement.count({ where })
      ]);

      res.status(200).json({
        success: true,
        data: {
          movements,
          pagination: {
            page: Number(page),
            limit: Number(limit),
            total,
            pages: Math.ceil(total / Number(limit))
          }
        }
      });

    } catch (error) {
      console.error('Erro ao buscar movimentações de estoque:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Relatório de estoque atual
  async getCurrentStock(req: Request, res: Response): Promise<void> {
    try {
      const { categoryId, lowStock, outOfStock } = req.query;
      const companyId = (req as any).user.companyId;

      // Construir filtros
      const where: any = {
        companyId: companyId,
        isActive: true
      };

      if (categoryId) where.categoryId = categoryId as string;

      // Buscar produtos com variações
      const products = await prisma.product.findMany({
        where,
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: { isActive: true },
            select: {
              id: true,
              size: true,
              color: true,
              model: true,
              stockQuantity: true,
              salePrice: true
            }
          }
        },
        orderBy: {
          name: 'asc'
        }
      });

      // Processar dados de estoque
      const stockData = products.map(product => {
        const totalStock = product.variations.reduce((sum, v) => sum + v.stockQuantity, 0);
        const totalValue = product.variations.reduce((sum, v) => sum + (v.stockQuantity * Number(v.salePrice)), 0);
        
        return {
          ...product,
          totalStock,
          totalValue,
          hasLowStock: totalStock <= (product.minStock || 10),
          isOutOfStock: totalStock === 0
        };
      });

      // Aplicar filtros adicionais
      let filteredData = stockData;
      
      if (lowStock === 'true') {
        filteredData = filteredData.filter(p => p.hasLowStock);
      }
      
      if (outOfStock === 'true') {
        filteredData = filteredData.filter(p => p.isOutOfStock);
      }

      // Estatísticas gerais
      const stats = {
        totalProducts: stockData.length,
        totalStock: stockData.reduce((sum, p) => sum + p.totalStock, 0),
        totalValue: stockData.reduce((sum, p) => sum + p.totalValue, 0),
        lowStockCount: stockData.filter(p => p.hasLowStock).length,
        outOfStockCount: stockData.filter(p => p.isOutOfStock).length
      };

      res.status(200).json({
        success: true,
        data: {
          products: filteredData,
          stats
        }
      });

    } catch (error) {
      console.error('Erro ao buscar estoque atual:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Buscar movimentação específica
  async getStockMovement(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const companyId = (req as any).user.companyId;

      const movement = await prisma.stockMovement.findFirst({
        where: {
          id,
          product: {
            companyId: companyId
          }
        },
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
              size: true,
              color: true,
              model: true
            }
          }
        }
      });

      if (!movement) {
        res.status(404).json({
          success: false,
          message: 'Movimentação não encontrada'
        });
        return;
      }

      res.status(200).json({
        success: true,
        data: movement
      });

    } catch (error) {
      console.error('Erro ao buscar movimentação:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}
