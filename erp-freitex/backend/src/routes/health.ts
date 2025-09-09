import { Router, Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const router = Router();
const prisma = new PrismaClient();

// Health check endpoint
router.get('/health', async (req: Request, res: Response) => {
  try {
    // Verificar conexão com o banco de dados
    await prisma.$queryRaw`SELECT 1`;
    
    // Verificar se as tabelas existem
    const tableCount = await prisma.$queryRaw<[{ count: bigint }]>`
      SELECT COUNT(*) as count 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `;
    
    const tablesExist = Number(tableCount[0].count) > 0;
    
    res.status(200).json({
      status: 'healthy',
      database: 'connected',
      tables: tablesExist ? 'created' : 'not_created',
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    });
  } catch (error) {
    console.error('Health check failed:', error);
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error instanceof Error ? error.message : 'Unknown error',
      timestamp: new Date().toISOString()
    });
  }
});

export default router;
