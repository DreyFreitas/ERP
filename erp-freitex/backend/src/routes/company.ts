import { Router } from 'express';
import { companyController } from '../controllers/companyController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// GET /api/company/dashboard - Dashboard da empresa
router.get('/dashboard', companyController.getCompanyDashboard);

export default router;
