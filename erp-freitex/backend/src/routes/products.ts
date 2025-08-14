import { Router } from 'express';
import { productController } from '../controllers/productController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// GET /api/products - Listar todos os produtos
router.get('/', productController.listProducts);

// GET /api/products/search - Buscar produtos
router.get('/search', productController.searchProducts);

// GET /api/products/category/:categoryId - Buscar produtos por categoria
router.get('/category/:categoryId', productController.getProductsByCategory);

// GET /api/products/:id - Buscar produto por ID
router.get('/:id', productController.getProductById);

// POST /api/products - Criar novo produto
router.post('/', productController.createProduct);

// PUT /api/products/:id - Atualizar produto
router.put('/:id', productController.updateProduct);

// DELETE /api/products/:id - Deletar produto
router.delete('/:id', productController.deleteProduct);

export default router;
