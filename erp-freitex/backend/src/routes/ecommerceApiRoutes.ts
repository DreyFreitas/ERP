import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { validateApiKey, checkApiKeyPermission } from '../controllers/apiKeyController';
import { ApiKeyRequest } from '../types';

const router = Router();
const prisma = new PrismaClient();

// Middleware para validar API Key em todas as rotas
router.use(validateApiKey);

// GET /api/products - Listar produtos
router.get('/products', checkApiKeyPermission('products:read'), async (req: ApiKeyRequest, res) => {
  try {
    const { page = 1, limit = 10, category, search } = req.query;
    const companyId = req.companyId;

    const skip = (Number(page) - 1) * Number(limit);
    const take = Number(limit);

    // Construir filtros
    const where: any = {
      companyId: companyId,
      isActive: true
    };

    if (category) {
      where.categoryId = category;
    }

    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: 'insensitive' } },
        { description: { contains: search as string, mode: 'insensitive' } },
        { sku: { contains: search as string, mode: 'insensitive' } }
      ];
    }

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        include: {
          category: true,
          variations: {
            where: { isActive: true }
          },
          _count: {
            select: { variations: true }
          }
        },
        skip,
        take,
        orderBy: { createdAt: 'desc' }
      }),
      prisma.product.count({ where })
    ]);

    return res.status(200).json({
      success: true,
      data: products,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / Number(limit))
      }
    });
  } catch (error) {
    console.error('Erro ao buscar produtos:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/products/:id - Obter produto específico
router.get('/products/:id', checkApiKeyPermission('products:read'), async (req: ApiKeyRequest, res) => {
  try {
    const { id } = req.params;
    const companyId = req.companyId;

    const product = await prisma.product.findFirst({
      where: {
        id: id,
        companyId: companyId,
        isActive: true
      },
      include: {
        category: true,
        variations: {
          where: { isActive: true }
        }
      }
    });

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Produto não encontrado'
      });
    }

    return res.status(200).json({
      success: true,
      data: product
    });
  } catch (error) {
    console.error('Erro ao buscar produto:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/products/:id/stock - Verificar estoque do produto
router.get('/products/:id/stock', checkApiKeyPermission('stock:read'), async (req: ApiKeyRequest, res) => {
  try {
    const { id } = req.params;
    const companyId = req.companyId;

    const product = await prisma.product.findFirst({
      where: {
        id: id,
        companyId: companyId,
        isActive: true
      },
      include: {
        variations: {
          where: { isActive: true },
          select: {
            id: true,
            size: true,
            color: true,
            model: true,
            sku: true,
            stockQuantity: true
          }
        }
      }
    });

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Produto não encontrado'
      });
    }

    // Calcular estoque total
    const totalStock = product.variations.reduce((total, variation) => {
      return total + variation.stockQuantity;
    }, 0);

    return res.status(200).json({
      success: true,
      data: {
        productId: product.id,
        productName: product.name,
        totalStock,
        variations: product.variations,
        hasStock: totalStock > 0
      }
    });
  } catch (error) {
    console.error('Erro ao verificar estoque:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/categories - Listar categorias
router.get('/categories', checkApiKeyPermission('categories:read'), async (req: ApiKeyRequest, res) => {
  try {
    const companyId = req.companyId;

    const categories = await prisma.category.findMany({
      where: {
        companyId: companyId,
        isActive: true
      },
      include: {
        parent: true,
        children: {
          where: { isActive: true }
        },
        _count: {
          select: { products: true }
        }
      },
      orderBy: { name: 'asc' }
    });

    return res.status(200).json({
      success: true,
      data: categories
    });
  } catch (error) {
    console.error('Erro ao buscar categorias:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/customers - Listar clientes
router.get('/customers', checkApiKeyPermission('customers:read'), async (req: ApiKeyRequest, res) => {
  try {
    const { page = 1, limit = 20, search } = req.query;
    const companyId = req.companyId;

    const skip = (Number(page) - 1) * Number(limit);
    const take = Number(limit);

    const where: any = {
      companyId: companyId,
      isActive: true
    };

    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: 'insensitive' } },
        { email: { contains: search as string, mode: 'insensitive' } },
        { cpfCnpj: { contains: search as string, mode: 'insensitive' } }
      ];
    }

    const [customers, total] = await Promise.all([
      prisma.customer.findMany({
        where,
        select: {
          id: true,
          name: true,
          email: true,
          phone: true,
          cpfCnpj: true,
          customerType: true,
          customerSegment: true,
          creditLimit: true,
          creditAvailable: true,
          createdAt: true
        },
        skip,
        take,
        orderBy: { name: 'asc' }
      }),
      prisma.customer.count({ where })
    ]);

    return res.status(200).json({
      success: true,
      data: customers,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / Number(limit))
      }
    });
  } catch (error) {
    console.error('Erro ao buscar clientes:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// POST /api/customers - Criar novo cliente
router.post('/customers', checkApiKeyPermission('customers:write'), async (req: ApiKeyRequest, res) => {
  try {
    const companyId = req.companyId;
    const { name, email, phone, cpfCnpj, address, city, state, zipCode } = req.body;

    // Validações
    if (!name || !name.trim()) {
      return res.status(400).json({
        success: false,
        message: 'Nome é obrigatório'
      });
    }

    // Verificar se já existe cliente com mesmo CPF/CNPJ
    if (cpfCnpj) {
      const existingCustomer = await prisma.customer.findFirst({
        where: {
          companyId: companyId,
          cpfCnpj: cpfCnpj
        }
      });

      if (existingCustomer) {
        return res.status(400).json({
          success: false,
          message: 'Já existe um cliente com este CPF/CNPJ'
        });
      }
    }

    // Verificar se já existe cliente com mesmo email
    if (email) {
      const existingCustomer = await prisma.customer.findFirst({
        where: {
          companyId: companyId,
          email: email
        }
      });

      if (existingCustomer) {
        return res.status(400).json({
          success: false,
          message: 'Já existe um cliente com este email'
        });
      }
    }

    const customer = await prisma.customer.create({
      data: {
        companyId: companyId!,
        name: name.trim(),
        email: email?.trim() || null,
        phone: phone?.trim() || null,
        cpfCnpj: cpfCnpj?.trim() || null,
        address: address?.trim() || null,
        city: city?.trim() || null,
        state: state?.trim() || null,
        zipCode: zipCode?.trim() || null
      }
    });

    return res.status(201).json({
      success: true,
      data: customer,
      message: 'Cliente criado com sucesso'
    });
  } catch (error) {
    console.error('Erro ao criar cliente:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/sales - Listar vendas
router.get('/sales', checkApiKeyPermission('sales:read'), async (req: ApiKeyRequest, res) => {
  try {
    const { page = 1, limit = 20, date_from, date_to } = req.query;
    const companyId = req.companyId;

    const skip = (Number(page) - 1) * Number(limit);
    const take = Number(limit);

    const where: any = {
      companyId: companyId,
      isActive: true
    };

    // Filtro por data
    if (date_from || date_to) {
      where.createdAt = {};
      if (date_from) {
        where.createdAt.gte = new Date(date_from as string);
      }
      if (date_to) {
        where.createdAt.lte = new Date(date_to as string);
      }
    }

    const [sales, total] = await Promise.all([
      prisma.sale.findMany({
        where,
        include: {
          customer: {
            select: {
              id: true,
              name: true,
              email: true
            }
          },
          paymentMethod: {
            select: {
              id: true,
              name: true
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
                  size: true,
                  color: true,
                  model: true
                }
              }
            }
          }
        },
        skip,
        take,
        orderBy: { createdAt: 'desc' }
      }),
      prisma.sale.count({ where })
    ]);

    return res.status(200).json({
      success: true,
      data: sales,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / Number(limit))
      }
    });
  } catch (error) {
    console.error('Erro ao buscar vendas:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// GET /api/health - Health check da API
router.get('/health', async (req: ApiKeyRequest, res) => {
  try {
    return res.status(200).json({
      success: true,
      message: 'API funcionando corretamente',
      timestamp: new Date().toISOString(),
      company: req.apiKey?.companyId
    });
  } catch (error) {
    console.error('Erro no health check:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

export default router;
