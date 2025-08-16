import { Router } from 'express';
import { customerController } from '../controllers/customerController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authMiddleware);

// Rotas de clientes
router.get('/', customerController.listCustomers);
router.get('/stats', customerController.getCustomerStats);
router.get('/:id', customerController.getCustomerById);
router.get('/:id/open-accounts', customerController.getCustomerOpenAccounts);
router.post('/', customerController.createCustomer);
router.put('/:id', customerController.updateCustomer);
router.delete('/:id', customerController.deleteCustomer);

export default router;
