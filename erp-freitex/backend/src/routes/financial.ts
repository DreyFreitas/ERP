import { Router } from 'express';
import { financialController } from '../controllers/financialController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authenticateToken);

// ========================================
// ROTAS DE CONTAS FINANCEIRAS
// ========================================

// Listar contas financeiras
router.get('/accounts', financialController.listAccounts);

// Obter conta por ID
router.get('/accounts/:id', financialController.getAccountById);

// Criar conta financeira
router.post('/accounts', financialController.createAccount);

// Atualizar conta financeira
router.put('/accounts/:id', financialController.updateAccount);

// Deletar conta financeira
router.delete('/accounts/:id', financialController.deleteAccount);

// ========================================
// ROTAS DE TRANSAÇÕES FINANCEIRAS
// ========================================

// Listar transações
router.get('/transactions', financialController.listTransactions);

// Obter transação por ID
router.get('/transactions/:id', financialController.getTransactionById);

// Criar transação
router.post('/transactions', financialController.createTransaction);

// Atualizar transação
router.put('/transactions/:id', financialController.updateTransaction);

// Deletar transação
router.delete('/transactions/:id', financialController.deleteTransaction);

// ========================================
// ROTAS DE RELATÓRIOS E ESTATÍSTICAS
// ========================================

// Obter estatísticas financeiras
router.get('/stats', financialController.getFinancialStats);

// ========================================
// ROTAS DE CONTAS A RECEBER
// ========================================

// Listar contas a receber
router.get('/accounts-receivable', financialController.listAccountsReceivable);

// Listar vencimentos próximos
router.get('/upcoming-due-dates', financialController.listUpcomingDueDates);

// ========================================
// ROTAS DE TRANSAÇÕES RECORRENTES
// ========================================

// Gerar transações recorrentes
router.post('/transactions/recurring/generate', financialController.generateRecurringTransactions);

export default router;

