import { Router } from 'express';
import { settingsController } from '../controllers/settingsController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// ========================================
// FORMAS DE PAGAMENTO
// ========================================

// GET /api/settings/payment-methods - Listar formas de pagamento
router.get('/payment-methods', settingsController.listPaymentMethods);

// POST /api/settings/payment-methods - Criar forma de pagamento
router.post('/payment-methods', settingsController.createPaymentMethod);

// PUT /api/settings/payment-methods/:id - Atualizar forma de pagamento
router.put('/payment-methods/:id', settingsController.updatePaymentMethod);

// DELETE /api/settings/payment-methods/:id - Deletar forma de pagamento
router.delete('/payment-methods/:id', settingsController.deletePaymentMethod);

// ========================================
// PRAZOS DE PAGAMENTO
// ========================================

// GET /api/settings/payment-terms - Listar prazos de pagamento
router.get('/payment-terms', settingsController.listPaymentTerms);

// POST /api/settings/payment-terms - Criar prazo de pagamento
router.post('/payment-terms', settingsController.createPaymentTerm);

// PUT /api/settings/payment-terms/:id - Atualizar prazo de pagamento
router.put('/payment-terms/:id', settingsController.updatePaymentTerm);

// DELETE /api/settings/payment-terms/:id - Deletar prazo de pagamento
router.delete('/payment-terms/:id', settingsController.deletePaymentTerm);

export default router;
