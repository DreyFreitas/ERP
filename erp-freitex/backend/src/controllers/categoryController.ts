import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { ApiResponse } from '../types';

interface CreateCategoryData {
  name: string;
  description?: string;
  parentId?: string;
}

interface UpdateCategoryData {
  name?: string;
  description?: string;
  parentId?: string;
  isActive?: boolean;
}

export const categoryController = {
  // Listar todas as categorias da empresa
  async listCategories(req: Request, res: Response<ApiResponse>) {
    try {
      const user = (req as any).user;
      
      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      const categories = await prisma.category.findMany({
        where: {
          companyId: user.company.id,
          isActive: true
        },
        include: {
          parent: {
            select: {
              id: true,
              name: true
            }
          },
          children: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              name: true
            }
          }
        },
        orderBy: {
          name: 'asc'
        }
      });

      return res.json({
        success: true,
        message: 'Categorias listadas com sucesso',
        data: categories
      });
    } catch (error) {
      console.error('Erro ao listar categorias:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Buscar categoria por ID
  async getCategoryById(req: Request, res: Response<ApiResponse>) {
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

      const category = await prisma.category.findFirst({
        where: { 
          id,
          companyId: user.company.id
        },
        include: {
          parent: {
            select: {
              id: true,
              name: true
            }
          },
          children: {
            where: {
              isActive: true
            },
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      if (!category) {
        return res.status(404).json({
          success: false,
          message: 'Categoria não encontrada',
          data: null
        });
      }

      return res.json({
        success: true,
        message: 'Categoria encontrada com sucesso',
        data: category
      });
    } catch (error) {
      console.error('Erro ao buscar categoria:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Criar nova categoria
  async createCategory(req: Request, res: Response<ApiResponse>) {
    try {
      const categoryData: CreateCategoryData = req.body;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      // Validar dados obrigatórios
      if (!categoryData.name || categoryData.name.trim() === '') {
        return res.status(400).json({
          success: false,
          message: 'Nome da categoria é obrigatório',
          data: null
        });
      }

      // Verificar se já existe uma categoria com o mesmo nome na mesma empresa
      const existingCategory = await prisma.category.findFirst({
        where: {
          name: categoryData.name.trim(),
          companyId: user.company.id,
          isActive: true
        }
      });

      if (existingCategory) {
        return res.status(400).json({
          success: false,
          message: 'Já existe uma categoria com este nome nesta empresa',
          data: null
        });
      }

      const category = await prisma.category.create({
        data: {
          companyId: user.company.id,
          name: categoryData.name.trim(),
          description: categoryData.description?.trim(),
          parentId: categoryData.parentId,
          isActive: true
        },
        include: {
          parent: {
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      return res.status(201).json({
        success: true,
        message: 'Categoria criada com sucesso',
        data: category
      });
    } catch (error) {
      console.error('Erro ao criar categoria:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Atualizar categoria
  async updateCategory(req: Request, res: Response<ApiResponse>) {
    try {
      const { id } = req.params;
      const categoryData: UpdateCategoryData = req.body;
      const user = (req as any).user;

      if (!user.company) {
        return res.status(403).json({
          success: false,
          message: 'Usuário não está associado a uma empresa',
          data: null
        });
      }

      // Verificar se a categoria existe e pertence à empresa
      const existingCategory = await prisma.category.findFirst({
        where: { 
          id,
          companyId: user.company.id
        }
      });

      if (!existingCategory) {
        return res.status(404).json({
          success: false,
          message: 'Categoria não encontrada',
          data: null
        });
      }

      // Se estiver alterando o nome, verificar se já existe outra categoria com o mesmo nome na mesma empresa
      if (categoryData.name && categoryData.name.trim() !== existingCategory.name) {
        const duplicateCategory = await prisma.category.findFirst({
          where: {
            name: categoryData.name.trim(),
            companyId: user.company.id,
            isActive: true,
            id: { not: id }
          }
        });

        if (duplicateCategory) {
          return res.status(400).json({
            success: false,
            message: 'Já existe uma categoria com este nome nesta empresa',
            data: null
          });
        }
      }

      const category = await prisma.category.update({
        where: { id },
        data: {
          name: categoryData.name?.trim(),
          description: categoryData.description?.trim(),
          parentId: categoryData.parentId,
          isActive: categoryData.isActive
        },
        include: {
          parent: {
            select: {
              id: true,
              name: true
            }
          }
        }
      });

      return res.json({
        success: true,
        message: 'Categoria atualizada com sucesso',
        data: category
      });
    } catch (error) {
      console.error('Erro ao atualizar categoria:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Deletar categoria (soft delete)
  async deleteCategory(req: Request, res: Response<ApiResponse>) {
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

      // Verificar se a categoria existe e pertence à empresa
      const existingCategory = await prisma.category.findFirst({
        where: { 
          id,
          companyId: user.company.id
        },
        include: {
          products: {
            where: {
              isActive: true
            }
          },
          children: {
            where: {
              isActive: true
            }
          }
        }
      });

      if (!existingCategory) {
        return res.status(404).json({
          success: false,
          message: 'Categoria não encontrada',
          data: null
        });
      }

      // Verificar se há produtos associados
      if (existingCategory.products.length > 0) {
        return res.status(400).json({
          success: false,
          message: 'Não é possível deletar uma categoria que possui produtos associados',
          data: null
        });
      }

      // Verificar se há subcategorias
      if (existingCategory.children.length > 0) {
        return res.status(400).json({
          success: false,
          message: 'Não é possível deletar uma categoria que possui subcategorias',
          data: null
        });
      }

      await prisma.category.update({
        where: { id },
        data: { isActive: false }
      });

      return res.json({
        success: true,
        message: 'Categoria deletada com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao deletar categoria:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
