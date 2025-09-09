import express from 'express';
import { authenticateToken } from '../middleware/auth';
import { uploadBackup } from '../middleware/upload';
import {
  createBackup,
  listBackups,
  downloadBackup,
  deleteBackup,
  restoreBackup,
  importBackup
} from '../controllers/backupController';

const router = express.Router();

// Endpoint de teste (sem autenticação)
router.get('/test', (req, res) => {
  res.json({
    success: true,
    message: 'Endpoint de backup funcionando!',
    timestamp: new Date().toISOString()
  });
});

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Criar novo backup (apenas usuários master)
router.post('/', createBackup);

// Listar todos os backups
router.get('/', listBackups);

// Download de backup específico
router.get('/:id/download', downloadBackup);

// Excluir backup (apenas usuários master)
router.delete('/:id', deleteBackup);

// Restaurar backup (apenas usuários master)
router.post('/:id/restore', restoreBackup);

// Importar backup externo (apenas usuários master)
router.post('/import', uploadBackup, importBackup);

export default router;
