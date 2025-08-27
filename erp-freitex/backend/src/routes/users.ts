import { Router } from 'express';
import { userController } from '../controllers/userController';
import { authenticateToken, requireMaster } from '../middleware/auth';

const router = Router();

// Todas as rotas requerem autenticação e permissão de master
router.use(authenticateToken);
router.use(requireMaster);

// GET /api/users - Listar todos os usuários (masters e por empresa)
router.get('/', userController.listAllUsers);

// GET /api/users/stats - Obter estatísticas de usuários
router.get('/stats', userController.getUserStats);

// GET /api/users/company/:companyId - Listar usuários de uma empresa
router.get('/company/:companyId', userController.listUsersByCompany);

// GET /api/users/:id - Buscar usuário por ID
router.get('/:id', userController.getUserById);

// POST /api/users - Criar novo usuário
router.post('/', userController.createUser);

// PUT /api/users/:id - Atualizar usuário
router.put('/:id', userController.updateUser);

// PATCH /api/users/:id/toggle-status - Ativar/Desativar usuário
router.patch('/:id/toggle-status', userController.toggleUserStatus);

// POST /api/users/:id/reset-password - Redefinir senha do usuário
router.post('/:id/reset-password', userController.resetUserPassword);

export default router;
