import express from 'express';
import { categoryController } from '../controllers/categoryController';
import { authenticateToken } from '../middleware/auth';

const router = express.Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authenticateToken);

// GET /api/categories - Listar todas as categorias
router.get('/', categoryController.listCategories);

// GET /api/categories/:id - Buscar categoria por ID
router.get('/:id', categoryController.getCategoryById);

// POST /api/categories - Criar nova categoria
router.post('/', categoryController.createCategory);

// PUT /api/categories/:id - Atualizar categoria
router.put('/:id', categoryController.updateCategory);

// DELETE /api/categories/:id - Deletar categoria
router.delete('/:id', categoryController.deleteCategory);

export default router;
