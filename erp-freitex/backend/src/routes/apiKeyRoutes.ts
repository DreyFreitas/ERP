import { Router } from 'express';
import { authenticateToken } from '../middleware/auth';
import {
  getApiKeys,
  createApiKey,
  updateApiKey,
  deleteApiKey,
  getApiKeyById
} from '../controllers/apiKeyController';

const router = Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Rotas para gerenciamento de API Keys
router.get('/', getApiKeys);
router.post('/', createApiKey);
router.get('/:id', getApiKeyById);
router.put('/:id', updateApiKey);
router.delete('/:id', deleteApiKey);

export default router;
