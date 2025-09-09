import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import path from 'path';

// Importar rotas
import authRoutes from './routes/auth';
import companyRoutes from './routes/companies';
import userRoutes from './routes/users';
import companyDashboardRoutes from './routes/company';
import productRoutes from './routes/products';
import categoryRoutes from './routes/categories';
import uploadRoutes from './routes/upload';
import stockRoutes from './routes/stock';
import customerRoutes from './routes/customers';
import financialRoutes from './routes/financial';
import settingsRoutes from './routes/settings';
import paymentTermRoutes from './routes/paymentTerms';
import salesRoutes from './routes/sales';
import backupRoutes from './routes/backupRoutes';
import subscriptionRoutes from './routes/subscriptionRoutes';



// Carregar variáveis de ambiente
dotenv.config();

const app = express();
const PORT = process.env.PORT || 7001;

// Configurar trust proxy para funcionar com Nginx
app.set('trust proxy', 1);

// CORS - Permitir todas as origens em desenvolvimento
app.use(cors({
  origin: true, // Permitir todas as origens
  credentials: true
}));

// Middleware de segurança
app.use(helmet());

// Rate limiting (temporariamente desabilitado para desenvolvimento)
// const limiter = rateLimit({
//   windowMs: 15 * 60 * 1000, // 15 minutos
//   max: 100, // limite de 100 requests por IP
//   message: 'Muitas requisições deste IP, tente novamente mais tarde.'
// });
// app.use('/api/', limiter);

// Logging
app.use(morgan('combined'));

// Parse JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rota de teste simples
app.get('/api/test', (req, res) => {
  res.json({
    success: true,
    message: 'API funcionando!',
    timestamp: new Date().toISOString()
  });
});

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api/companies', companyRoutes);
app.use('/api/users', userRoutes);
app.use('/api/company', companyDashboardRoutes);
app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/stock', stockRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/financial', financialRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/payment-terms', paymentTermRoutes);
app.use('/api/sales', salesRoutes);
app.use('/api/backup', backupRoutes);
app.use('/api/subscriptions', subscriptionRoutes);



// Servir arquivos estáticos (uploads) - DEPOIS das rotas da API
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Health check robusto
app.get('/health', async (req, res) => {
  try {
    // Verificar conexão com o banco de dados
    const { PrismaClient } = await import('@prisma/client');
    const prisma = new PrismaClient();
    
    await prisma.$queryRaw`SELECT 1`;
    
    // Verificar se as tabelas existem
    const tableCount = await prisma.$queryRaw<[{ count: bigint }]>`
      SELECT COUNT(*) as count 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `;
    
    const tablesExist = Number(tableCount[0].count) > 0;
    
    await prisma.$disconnect();
    
    res.status(200).json({
      status: 'healthy',
      database: 'connected',
      tables: tablesExist ? 'created' : 'not_created',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV
    });
  } catch (error) {
    console.error('Health check failed:', error);
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error instanceof Error ? error.message : 'Unknown error',
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    });
  }
});

// API Routes (serão adicionadas depois)
app.get('/api', (req, res) => {
  res.json({
    message: 'ERP Freitex API',
    version: '1.0.0',
    status: 'running'
  });
});

// Error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Erro interno do servidor',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use('*', (req, res) => {
  console.log('404 - Rota não encontrada:', req.method, req.originalUrl);
  res.status(404).json({
    success: false,
    message: 'Rota não encontrada'
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔗 API: http://localhost:${PORT}/api`);
  console.log(`🔐 Auth: http://localhost:${PORT}/api/auth`);
  console.log(`🌍 Ambiente: ${process.env.NODE_ENV || 'development'}`);
});

export default app;
