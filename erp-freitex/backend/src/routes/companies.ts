import { Router } from 'express';
import { companyController } from '../controllers/companyController';
import { authenticateToken, requireMaster } from '../middleware/auth';

const router = Router();

// Todas as rotas requerem autenticação e permissão de master
router.use(authenticateToken);
router.use(requireMaster);

// GET /api/companies - Listar todas as empresas
router.get('/', companyController.listCompanies);

// GET /api/companies/stats - Obter estatísticas
router.get('/stats', companyController.getCompanyStats);

// GET /api/companies/:id - Buscar empresa por ID
router.get('/:id', companyController.getCompanyById);

// POST /api/companies - Criar nova empresa
router.post('/', companyController.createCompany);

// PUT /api/companies/:id - Atualizar empresa
router.put('/:id', companyController.updateCompany);

// PATCH /api/companies/:id/toggle-status - Ativar/Desativar empresa
router.patch('/:id/toggle-status', companyController.toggleCompanyStatus);

export default router;
