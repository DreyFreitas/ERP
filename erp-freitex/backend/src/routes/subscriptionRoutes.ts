import express from 'express';
import { authenticateToken } from '../middleware/auth';
import {
  listSubscriptions,
  getSubscriptionStats,
  createSubscription,
  updateSubscription,
  markAsPaid,
  generateNextMonthSubscriptions,
  deleteSubscription
} from '../controllers/subscriptionController';

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Listar mensalidades
router.get('/', listSubscriptions);

// Obter estatísticas
router.get('/stats', getSubscriptionStats);

// Criar nova mensalidade (apenas usuários master)
router.post('/', authenticateToken, createSubscription);

// Atualizar mensalidade (apenas usuários master)
router.put('/:id', authenticateToken, updateSubscription);

// Marcar como pago (apenas usuários master)
router.post('/:id/pay', authenticateToken, markAsPaid);

// Gerar mensalidades para o próximo mês (apenas usuários master)
router.post('/generate-next-month', authenticateToken, generateNextMonthSubscriptions);

// Excluir mensalidade (apenas usuários master)
router.delete('/:id', authenticateToken, deleteSubscription);

export default router;

