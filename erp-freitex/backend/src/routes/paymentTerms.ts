import { Router } from 'express';
import { paymentTermController } from '../controllers/paymentTermController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authenticateToken);

// GET /api/payment-terms - Listar todos os prazos de pagamento
router.get('/', paymentTermController.listPaymentTerms);

// GET /api/payment-terms/:id - Buscar prazo de pagamento por ID
router.get('/:id', paymentTermController.getPaymentTermById);

// POST /api/payment-terms - Criar novo prazo de pagamento
router.post('/', paymentTermController.createPaymentTerm);

// PUT /api/payment-terms/:id - Atualizar prazo de pagamento
router.put('/:id', paymentTermController.updatePaymentTerm);

// DELETE /api/payment-terms/:id - Deletar prazo de pagamento
router.delete('/:id', paymentTermController.deletePaymentTerm);

// POST /api/payment-terms/calculate-installments - Calcular parcelas
router.post('/calculate-installments', paymentTermController.calculateInstallments);

export default router;
