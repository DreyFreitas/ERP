const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function seedVariations() {
  try {
    console.log('🌱 Adicionando variações de produtos...');

    // Buscar o produto existente
    const product = await prisma.product.findFirst({
      where: {
        name: {
          contains: 'Jaqueta'
        }
      }
    });

    if (!product) {
      console.log('❌ Produto não encontrado');
      return;
    }

    console.log(`📦 Produto encontrado: ${product.name}`);

    // Criar variações
    const variations = [
      {
        productId: product.id,
        size: 'M',
        color: 'Azul',
        model: 'Casual',
        sku: 'JAC-M-AZU-001',
        salePrice: 89.90,
        stockQuantity: 15,
        isActive: true
      },
      {
        productId: product.id,
        size: 'L',
        color: 'Azul',
        model: 'Casual',
        sku: 'JAC-L-AZU-001',
        salePrice: 89.90,
        stockQuantity: 12,
        isActive: true
      },
      {
        productId: product.id,
        size: 'M',
        color: 'Preto',
        model: 'Casual',
        sku: 'JAC-M-PRE-001',
        salePrice: 89.90,
        stockQuantity: 8,
        isActive: true
      },
      {
        productId: product.id,
        size: 'L',
        color: 'Preto',
        model: 'Casual',
        sku: 'JAC-L-PRE-001',
        salePrice: 89.90,
        stockQuantity: 5,
        isActive: true
      },
      {
        productId: product.id,
        size: 'P',
        color: 'Cinza',
        model: 'Casual',
        sku: 'JAC-P-CIN-001',
        salePrice: 89.90,
        stockQuantity: 0,
        isActive: true
      }
    ];

    for (const variation of variations) {
      await prisma.productVariation.create({
        data: variation
      });
      console.log(`✅ Variação criada: ${variation.size} ${variation.color} - Estoque: ${variation.stockQuantity}`);
    }

    console.log('🎉 Variações criadas com sucesso!');

  } catch (error) {
    console.error('❌ Erro ao criar variações:', error);
  } finally {
    await prisma.$disconnect();
  }
}

seedVariations();
