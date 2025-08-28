import { Router } from 'express';
import { saleController } from '../controllers/saleController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authenticateToken);

// GET /api/sales - Listar todas as vendas
router.get('/', saleController.listSales);

// GET /api/sales/stats - Estatísticas de vendas
router.get('/stats', saleController.getSalesStats);

// GET /api/sales/:id - Buscar venda por ID
router.get('/:id', saleController.getSaleById);

// POST /api/sales - Criar nova venda
router.post('/', saleController.createSale);

// POST /api/sales/installment-preview - Calcular preview de parcelas
router.post('/installment-preview', saleController.calculateInstallmentPreview);

// PUT /api/sales/:id - Atualizar venda
router.put('/:id', saleController.updateSale);

// POST /api/sales/:id/cancel - Cancelar venda
router.post('/:id/cancel', saleController.cancelSale);

export default router;
