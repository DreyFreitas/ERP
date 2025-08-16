import { Router } from 'express';
import { StockController } from '../controllers/stockController';
import { authenticateToken } from '../middleware/auth';

const router = Router();
const stockController = new StockController();

// Middleware de autenticação para todas as rotas
router.use(authenticateToken);

// Rotas de movimentação de estoque
router.post('/entry', stockController.registerEntry);
router.post('/exit', stockController.registerExit);
router.post('/adjust', stockController.adjustStock);

// Rotas de consulta
router.get('/movements', stockController.getStockMovements);
router.get('/movements/:id', stockController.getStockMovement);
router.get('/current', stockController.getCurrentStock);

export default router;
