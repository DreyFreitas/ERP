import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Interface para filtros de relatórios
interface ReportFilters {
  startDate?: string;
  endDate?: string;
  period?: 'day' | 'week' | 'month' | 'quarter' | 'year';
  categoryId?: string;
  customerId?: string;
  productId?: string;
  paymentMethodId?: string;
}

// Relatório de Vendas
export const getSalesReport = async (req: Request, res: Response) => {
  try {
    const companyId = (req as any).user?.companyId;
    const filters: ReportFilters = req.query;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Construir filtros de data
    const dateFilter: any = {};
    if (filters.startDate) {
      dateFilter.gte = new Date(filters.startDate);
    }
    if (filters.endDate) {
      dateFilter.lte = new Date(filters.endDate);
    }

    // Construir where clause
    const where: any = {
      companyId,
      isActive: true
    };

    if (Object.keys(dateFilter).length > 0) {
      where.createdAt = dateFilter;
    }

    if (filters.customerId) {
      where.customerId = filters.customerId;
    }

    if (filters.paymentMethodId) {
      where.paymentMethodId = filters.paymentMethodId;
    }

    // Buscar vendas
    const sales = await prisma.sale.findMany({
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
      orderBy: { createdAt: 'desc' }
    });

    // Calcular estatísticas
    const totalSales = sales.length;
    const totalRevenue = sales.reduce((sum, sale) => sum + (sale.finalAmount || sale.totalAmount), 0);
    const averageTicket = totalSales > 0 ? totalRevenue / totalSales : 0;

    // Produtos mais vendidos
    const productSales = new Map();
    sales.forEach(sale => {
      sale.items.forEach(item => {
        const key = item.productId;
        if (!productSales.has(key)) {
          productSales.set(key, {
            productId: item.productId,
            productName: item.product.name,
            sku: item.product.sku,
            quantity: 0,
            revenue: 0
          });
        }
        const product = productSales.get(key);
        product.quantity += item.quantity;
        product.revenue += item.totalPrice;
      });
    });

    const topProducts = Array.from(productSales.values())
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 10);

    // Vendas por método de pagamento
    const paymentMethodSales = new Map();
    sales.forEach(sale => {
      const methodName = sale.paymentMethod?.name || 'Não informado';
      if (!paymentMethodSales.has(methodName)) {
        paymentMethodSales.set(methodName, {
          methodName,
          count: 0,
          revenue: 0
        });
      }
      const method = paymentMethodSales.get(methodName);
      method.count += 1;
      method.revenue += sale.finalAmount || sale.totalAmount;
    });

    const salesByPaymentMethod = Array.from(paymentMethodSales.values())
      .map(method => ({
        ...method,
        percentage: totalRevenue > 0 ? (method.revenue / totalRevenue) * 100 : 0
      }));

    // Vendas por cliente
    const customerSales = new Map();
    sales.forEach(sale => {
      if (sale.customer) {
        const customerId = sale.customer.id;
        if (!customerSales.has(customerId)) {
          customerSales.set(customerId, {
            customerId,
            customerName: sale.customer.name,
            count: 0,
            revenue: 0
          });
        }
        const customer = customerSales.get(customerId);
        customer.count += 1;
        customer.revenue += sale.finalAmount || sale.totalAmount;
      }
    });

    const salesByCustomer = Array.from(customerSales.values())
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 10);

    // Vendas diárias
    const dailySales = new Map();
    sales.forEach(sale => {
      const date = sale.createdAt.toISOString().split('T')[0];
      if (!dailySales.has(date)) {
        dailySales.set(date, {
          date,
          count: 0,
          revenue: 0
        });
      }
      const day = dailySales.get(date);
      day.count += 1;
      day.revenue += sale.finalAmount || sale.totalAmount;
    });

    const dailySalesArray = Array.from(dailySales.values())
      .sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());

    const report = {
      period: filters.period || 'month',
      totalSales,
      totalRevenue,
      averageTicket,
      dailySales: dailySalesArray,
      topProducts,
      salesByPaymentMethod,
      salesByCustomer
    };

    return res.status(200).json({
      success: true,
      data: report
    });

  } catch (error) {
    console.error('Erro ao gerar relatório de vendas:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Relatório Financeiro
export const getFinancialReport = async (req: Request, res: Response) => {
  try {
    const companyId = (req as any).user?.companyId;
    const filters: ReportFilters = req.query;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Construir filtros de data
    const dateFilter: any = {};
    if (filters.startDate) {
      dateFilter.gte = new Date(filters.startDate);
    }
    if (filters.endDate) {
      dateFilter.lte = new Date(filters.endDate);
    }

    // Buscar transações financeiras
    const where: any = {
      companyId,
      isActive: true
    };

    if (Object.keys(dateFilter).length > 0) {
      where.createdAt = dateFilter;
    }

    const transactions = await prisma.financialTransaction.findMany({
      where,
      include: {
        account: {
          select: {
            name: true,
            accountType: true
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    // Calcular estatísticas
    const totalIncome = transactions
      .filter(t => t.transactionType === 'INCOME')
      .reduce((sum, t) => sum + t.amount, 0);

    const totalExpenses = transactions
      .filter(t => t.transactionType === 'EXPENSE')
      .reduce((sum, t) => sum + Math.abs(t.amount), 0);

    const netIncome = totalIncome - totalExpenses;

    const pendingReceivables = transactions
      .filter(t => t.transactionType === 'INCOME' && t.status === 'PENDING')
      .reduce((sum, t) => sum + t.amount, 0);

    const pendingPayables = transactions
      .filter(t => t.transactionType === 'EXPENSE' && t.status === 'PENDING')
      .reduce((sum, t) => sum + Math.abs(t.amount), 0);

    // Despesas por categoria
    const expensesByCategory = new Map();
    transactions
      .filter(t => t.transactionType === 'EXPENSE')
      .forEach(transaction => {
        const category = transaction.category || 'Sem categoria';
        if (!expensesByCategory.has(category)) {
          expensesByCategory.set(category, {
            category,
            amount: 0
          });
        }
        const cat = expensesByCategory.get(category);
        cat.amount += Math.abs(transaction.amount);
      });

    const expensesByCategoryArray = Array.from(expensesByCategory.values())
      .map(expense => ({
        ...expense,
        percentage: totalExpenses > 0 ? (expense.amount / totalExpenses) * 100 : 0
      }));

    // Saldos das contas
    const accountBalances = await prisma.financialAccount.findMany({
      where: { companyId, isActive: true },
      select: {
        name: true,
        accountType: true,
        currentBalance: true
      }
    });

    // Tendência mensal (últimos 12 meses)
    const monthlyTrend = [];
    for (let i = 11; i >= 0; i--) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
      const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

      const monthTransactions = transactions.filter(t => 
        t.createdAt >= startOfMonth && t.createdAt <= endOfMonth
      );

      const monthIncome = monthTransactions
        .filter(t => t.transactionType === 'INCOME')
        .reduce((sum, t) => sum + t.amount, 0);

      const monthExpenses = monthTransactions
        .filter(t => t.transactionType === 'EXPENSE')
        .reduce((sum, t) => sum + Math.abs(t.amount), 0);

      monthlyTrend.push({
        month: startOfMonth.toLocaleDateString('pt-BR', { month: 'short', year: 'numeric' }),
        income: monthIncome,
        expenses: monthExpenses,
        net: monthIncome - monthExpenses
      });
    }

    const report = {
      period: filters.period || 'month',
      totalIncome,
      totalExpenses,
      netIncome,
      pendingReceivables,
      pendingPayables,
      monthlyTrend,
      expensesByCategory: expensesByCategoryArray,
      accountBalances
    };

    return res.status(200).json({
      success: true,
      data: report
    });

  } catch (error) {
    console.error('Erro ao gerar relatório financeiro:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Relatório de Estoque
export const getStockReport = async (req: Request, res: Response) => {
  try {
    const companyId = (req as any).user?.companyId;
    const filters: ReportFilters = req.query;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Buscar produtos
    const products = await prisma.product.findMany({
      where: {
        companyId,
        isActive: true
      },
      include: {
        variations: {
          where: { isActive: true },
          include: {
            stockMovements: {
              orderBy: { createdAt: 'desc' },
              take: 1
            }
          }
        }
      }
    });

    // Calcular estatísticas
    const totalProducts = products.length;
    const totalVariations = products.reduce((sum, product) => sum + product.variations.length, 0);

    // Produtos com estoque baixo
    const lowStockItems = [];
    const outOfStockItems = [];

    products.forEach(product => {
      product.variations.forEach(variation => {
        const currentStock = variation.currentStock || 0;
        const minStock = variation.minStock || 0;

        if (currentStock === 0) {
          outOfStockItems.push({
            productId: product.id,
            productName: product.name,
            variationName: variation.name,
            sku: variation.sku || product.sku
          });
        } else if (currentStock <= minStock) {
          lowStockItems.push({
            productId: product.id,
            productName: product.name,
            variationName: variation.name,
            currentStock,
            minStock,
            sku: variation.sku || product.sku
          });
        }
      });
    });

    // Movimentações de estoque (últimos 30 dias)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const stockMovements = await prisma.stockMovement.findMany({
      where: {
        companyId,
        createdAt: {
          gte: thirtyDaysAgo
        }
      },
      include: {
        product: {
          select: {
            name: true
          }
        },
        variation: {
          select: {
            name: true
          }
        }
      },
      orderBy: { createdAt: 'desc' },
      take: 50
    });

    const stockMovementsArray = stockMovements.map(movement => ({
      date: movement.createdAt.toISOString().split('T')[0],
      type: movement.movementType,
      productName: movement.product.name,
      variationName: movement.variation?.name,
      quantity: movement.quantity,
      unitCost: movement.unitCost,
      totalCost: movement.unitCost ? movement.unitCost * movement.quantity : undefined
    }));

    // Valor total do estoque
    let totalStockValue = 0;
    let totalCost = 0;
    let totalItems = 0;

    products.forEach(product => {
      product.variations.forEach(variation => {
        const stock = variation.currentStock || 0;
        const cost = variation.costPrice || 0;
        totalStockValue += stock * cost;
        totalCost += cost;
        totalItems += stock;
      });
    });

    const averageCost = totalItems > 0 ? totalCost / totalItems : 0;

    const report = {
      totalProducts,
      totalVariations,
      lowStockItems,
      outOfStockItems,
      stockMovements: stockMovementsArray,
      stockValue: {
        totalValue: totalStockValue,
        averageCost
      }
    };

    return res.status(200).json({
      success: true,
      data: report
    });

  } catch (error) {
    console.error('Erro ao gerar relatório de estoque:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Relatório de Clientes
export const getCustomerReport = async (req: Request, res: Response) => {
  try {
    const companyId = (req as any).user?.companyId;
    const filters: ReportFilters = req.query;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Construir filtros de data
    const dateFilter: any = {};
    if (filters.startDate) {
      dateFilter.gte = new Date(filters.startDate);
    }
    if (filters.endDate) {
      dateFilter.lte = new Date(filters.endDate);
    }

    // Buscar clientes
    const customers = await prisma.customer.findMany({
      where: {
        companyId,
        isActive: true
      },
      include: {
        sales: {
          where: Object.keys(dateFilter).length > 0 ? { createdAt: dateFilter } : {},
          select: {
            id: true,
            totalAmount: true,
            finalAmount: true,
            createdAt: true
          }
        },
        financialTransactions: {
          where: {
            transactionType: 'INCOME',
            status: 'PENDING'
          },
          select: {
            amount: true
          }
        }
      }
    });

    // Calcular estatísticas
    const totalCustomers = customers.length;
    const activeCustomers = customers.filter(c => c.sales.length > 0).length;

    // Novos clientes (últimos 30 dias)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    const newCustomers = customers.filter(c => c.createdAt >= thirtyDaysAgo).length;

    // Clientes com contas em aberto
    const customersWithOpenAccounts = customers.filter(c => c.financialTransactions.length > 0).length;
    const totalOpenAmount = customers.reduce((sum, c) => 
      sum + c.financialTransactions.reduce((sum2, t) => sum2 + t.amount, 0), 0
    );

    // Top clientes
    const topCustomers = customers
      .map(customer => {
        const totalPurchases = customer.sales.length;
        const totalValue = customer.sales.reduce((sum, sale) => sum + (sale.finalAmount || sale.totalAmount), 0);
        const lastPurchase = customer.sales.length > 0 
          ? customer.sales.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())[0].createdAt
          : null;
        const openAmount = customer.financialTransactions.reduce((sum, t) => sum + t.amount, 0);

        return {
          customerId: customer.id,
          customerName: customer.name,
          totalPurchases,
          lastPurchase: lastPurchase ? lastPurchase.toISOString() : null,
          openAmount
        };
      })
      .filter(c => c.totalPurchases > 0)
      .sort((a, b) => b.totalPurchases - a.totalPurchases)
      .slice(0, 10);

    // Clientes por segmento
    const customersBySegment = new Map();
    customers.forEach(customer => {
      const segment = customer.segment || 'Não informado';
      if (!customersBySegment.has(segment)) {
        customersBySegment.set(segment, {
          segment,
          count: 0
        });
      }
      const seg = customersBySegment.get(segment);
      seg.count += 1;
    });

    const customersBySegmentArray = Array.from(customersBySegment.values())
      .map(segment => ({
        ...segment,
        percentage: totalCustomers > 0 ? (segment.count / totalCustomers) * 100 : 0
      }));

    // Crescimento de clientes (últimos 12 meses)
    const customerGrowth = [];
    for (let i = 11; i >= 0; i--) {
      const date = new Date();
      date.setMonth(date.getMonth() - i);
      const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
      const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

      const newCustomersInMonth = customers.filter(c => 
        c.createdAt >= startOfMonth && c.createdAt <= endOfMonth
      ).length;

      const totalCustomersInMonth = customers.filter(c => 
        c.createdAt <= endOfMonth
      ).length;

      customerGrowth.push({
        month: startOfMonth.toLocaleDateString('pt-BR', { month: 'short', year: 'numeric' }),
        newCustomers: newCustomersInMonth,
        totalCustomers: totalCustomersInMonth
      });
    }

    const report = {
      totalCustomers,
      activeCustomers,
      newCustomers,
      customersWithOpenAccounts,
      totalOpenAmount,
      topCustomers,
      customersBySegment: customersBySegmentArray,
      customerGrowth
    };

    return res.status(200).json({
      success: true,
      data: report
    });

  } catch (error) {
    console.error('Erro ao gerar relatório de clientes:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Exportar relatório para PDF
export const exportReportToPDF = async (req: Request, res: Response) => {
  try {
    const reportType = req.params.type;
    const companyId = (req as any).user?.companyId;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Por enquanto, retornar um placeholder
    // Em uma implementação real, você usaria uma biblioteca como puppeteer ou jsPDF
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename=relatorio_${reportType}.pdf`);
    
    // Placeholder - em produção, gerar PDF real
    res.send('PDF placeholder - implementar geração real de PDF');

  } catch (error) {
    console.error('Erro ao exportar relatório para PDF:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Exportar relatório para Excel
export const exportReportToExcel = async (req: Request, res: Response) => {
  try {
    const reportType = req.params.type;
    const companyId = (req as any).user?.companyId;

    if (!companyId) {
      return res.status(401).json({
        success: false,
        message: 'Usuário não autenticado'
      });
    }

    // Por enquanto, retornar um placeholder
    // Em uma implementação real, você usaria uma biblioteca como xlsx
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', `attachment; filename=relatorio_${reportType}.xlsx`);
    
    // Placeholder - em produção, gerar Excel real
    res.send('Excel placeholder - implementar geração real de Excel');

  } catch (error) {
    console.error('Erro ao exportar relatório para Excel:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};
