import express from 'express';
import { authenticateToken } from '../middleware/auth';
import {
  getSalesReport,
  getFinancialReport,
  getStockReport,
  getCustomerReport,
  exportReportToPDF,
  exportReportToExcel
} from '../controllers/reportsController';

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Relatórios
router.get('/sales', getSalesReport);
router.get('/financial', getFinancialReport);
router.get('/stock', getStockReport);
router.get('/customers', getCustomerReport);

// Exportação
router.get('/export/:type/pdf', exportReportToPDF);
router.get('/export/:type/excel', exportReportToExcel);

export default router;
