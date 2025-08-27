import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

interface CreateProductData {
  sku?: string;
  name: string;
  description?: string;
  categoryId?: string;
  supplierId?: string;
  barcode?: string;
  costPrice?: number;
  salePrice: number;
  promotionalPrice?: number;
  minStock: number;
  maxStock?: number;
  weight?: number;
  dimensions?: any;
  images?: string[];
  specifications?: any;
  variations?: Array<{
    size?: string;
    color?: string;
    model?: string;
    sku?: string;
    salePrice: number;
    stockQuantity: number;
  }>;
}

interface UpdateProductData {
  sku?: string;
  name?: string;
  description?: string;
  categoryId?: string;
  supplierId?: string;
  barcode?: string;
  costPrice?: number;
  salePrice?: number;
  promotionalPrice?: number;
  minStock?: number;
  maxStock?: number;
  weight?: number;
  dimensions?: any;
  images?: string[];
  specifications?: any;
  isActive?: boolean;
}

export const productController = {
  // Listar todos os produtos da empresa
  async listProducts(req: Request, res: Response<ApiResponse>) {
    try {
      const user = (req as any).user;
      
      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      const products = await prisma.product.findMany({
        where: {
          companyId: user.company.id,
          isActive: true
        },
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          supplier: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              sku: true,
              size: true,
              color: true,
              model: true,
              stockQuantity: true,
              salePrice: true
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        }
      });

      return res.json({
        success: true,
        message: 'Produtos listados com sucesso',
        data: products
      });
    } catch (error) {
      console.error('Erro ao listar produtos:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar produto por ID
  async getProductById(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      const product = await prisma.product.findFirst({
        where: { 
          id,
          companyId: user.company.id
        },
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          supplier: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              sku: true,
              size: true,
              color: true,
              model: true,
              stockQuantity: true,
              salePrice: true,
              costPrice: true,
              barcode: true
            }
          }
        }
      });

      if (!product) {
        return res.status(404).json({
          success: false,
          message: 'Produto não encontrado',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Produto encontrado com sucesso',
        data: product
      });
    } catch (error) {
      console.error('Erro ao buscar produto:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar novo produto
  async createProduct(req: Request, res: Response<ApiResponse>) {
    try {
      const productData: CreateProductData = req.body;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      // Validar dados obrigatórios
      if (!productData.name || !productData.salePrice) {
        return res.status(400).json({
          success: false,
          message: 'Nome e preço de venda são obrigatórios',
          data: null
        });
      }

      // Verificar se SKU já existe na mesma empresa (se fornecido)
      if (productData.sku) {
        const existingProduct = await prisma.product.findFirst({
          where: { 
            sku: productData.sku,
            companyId: user.company.id
          }
        });

        if (existingProduct) {
          return res.status(400).json({
            success: false,
            message: 'SKU já existe nesta empresa',
            data: null
          });
        }
      }

      const product = await prisma.product.create({
        data: {
          companyId: user.company.id,
          sku: productData.sku,
          name: productData.name,
          description: productData.description,
          categoryId: productData.categoryId,
          supplierId: productData.supplierId,
          barcode: productData.barcode,
          costPrice: productData.costPrice,
          salePrice: productData.salePrice,
          promotionalPrice: productData.promotionalPrice,
          minStock: productData.minStock || 0,
          maxStock: productData.maxStock,
          weight: productData.weight,
          dimensions: productData.dimensions,
          images: productData.images,
          specifications: productData.specifications,
          isActive: true,
          variations: productData.variations ? {
            create: productData.variations.map(variation => ({
              size: variation.size,
              color: variation.color,
              model: variation.model,
              sku: variation.sku?.trim() || null, // Permitir SKU nulo
              salePrice: variation.salePrice,
              stockQuantity: variation.stockQuantity || 0,
              isActive: true
            }))
          } : undefined
        },
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          supplier: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              sku: true,
              size: true,
              color: true,
              model: true,
              stockQuantity: true,
              salePrice: true
            }
          }
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Produto criado com sucesso',
        data: product
      });
    } catch (error) {
      console.error('Erro ao criar produto:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar produto
  async updateProduct(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const updateData: UpdateProductData = req.body;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      // Verificar se o produto existe e pertence à empresa
      const existingProduct = await prisma.product.findFirst({
        where: { 
          id,
          companyId: user.company.id
        }
      });

      if (!existingProduct) {
        return res.status(404).json({
          success: false,
          message: 'Produto não encontrado',
          data: null
        });
      }

      // Verificar se SKU já existe na mesma empresa (se fornecido e diferente do atual)
      if (updateData.sku && updateData.sku !== existingProduct.sku) {
        const productWithSku = await prisma.product.findFirst({
          where: { 
            sku: updateData.sku,
            companyId: user.company.id
          }
        });

        if (productWithSku) {
          return res.status(400).json({
            success: false,
            message: 'SKU já existe nesta empresa',
            data: null
          });
        }
      }

      const product = await prisma.product.update({
        where: { id },
        data: updateData,
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          supplier: {
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      return res.json({
        success: true,
        message: 'Produto atualizado com sucesso',
        data: product
      });
    } catch (error) {
      console.error('Erro ao atualizar produto:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Deletar produto (soft delete)
  async deleteProduct(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      // Verificar se o produto existe e pertence à empresa
      const existingProduct = await prisma.product.findFirst({
        where: { 
          id,
          companyId: user.company.id
        }
      });

      if (!existingProduct) {
        return res.status(404).json({
          success: false,
          message: 'Produto não encontrado',
          data: null
        });
      }

      // Soft delete - apenas desativar o produto
      await prisma.product.update({
        where: { id },
        data: { isActive: false }
      });

      return res.json({
        success: true,
        message: 'Produto deletado com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao deletar produto:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar produtos por categoria
  async getProductsByCategory(req: Request, res: Response<ApiResponse>) {
    try {
      const { categoryId } = req.params;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      const products = await prisma.product.findMany({
        where: {
          categoryId,
          isActive: true
        },
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              sku: true,
              stockQuantity: true,
              salePrice: true
            }
          }
        },
        orderBy: {
          name: 'asc'
        }
      });

      return res.json({
        success: true,
        message: 'Produtos da categoria listados com sucesso',
        data: products
      });
    } catch (error) {
      console.error('Erro ao listar produtos por categoria:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar produtos por termo de busca
  async searchProducts(req: Request, res: Response<ApiResponse>) {
    try {
      const { q } = req.query;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      if (!q || typeof q !== 'string') {
        return res.status(400).json({
          success: false,
          message: 'Termo de busca é obrigatório',
          data: null
        });
      }

      const products = await prisma.product.findMany({
        where: {
          isActive: true,
          OR: [
            {
              name: {
                contains: q,
                mode: 'insensitive'
              }
            },
            {
              sku: {
                contains: q,
                mode: 'insensitive'
              }
            },
            {
              barcode: {
                contains: q,
                mode: 'insensitive'
              }
            }
          ]
        },
        include: {
          category: {
            select: {
              id: true,
              name: true
            }
          },
          variations: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              sku: true,
              stockQuantity: true,
              salePrice: true
            }
          }
        },
        orderBy: {
          name: 'asc'
        },
        take: 20
      });

      return res.json({
        success: true,
        message: 'Busca realizada com sucesso',
        data: products
      });
    } catch (error) {
      console.error('Erro ao buscar produtos:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
