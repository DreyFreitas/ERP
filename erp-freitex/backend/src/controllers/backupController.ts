import { Request, Response } from 'express';
import { AuthRequest } from '../types';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as fs from 'fs';
import * as path from 'path';
import { prisma } from '../lib/prisma';

const execAsync = promisify(exec);

interface BackupInfo {
  id: string;
  filename: string;
  size: string;
  createdAt: Date;
  status: 'completed' | 'failed' | 'in_progress';
  type: 'full';
  description?: string;
  filePath: string;
}

// Função para formatar tamanho do arquivo
const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

// Função para obter informações do arquivo
const getFileInfo = (filePath: string): { size: string; exists: boolean } => {
  try {
    if (fs.existsSync(filePath)) {
      const stats = fs.statSync(filePath);
      return { size: formatFileSize(stats.size), exists: true };
    }
    return { size: '0 Bytes', exists: false };
  } catch (error) {
    return { size: '0 Bytes', exists: false };
  }
};

// Criar backup completo do banco de dados
export const createBackup = async (req: Request, res: Response) => {
  try {
    const { description } = req.body;
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `backup_full_${timestamp}.sql`;
    
    // Diretório de backups
    const backupDir = path.join(__dirname, '../../backups');
    if (!fs.existsSync(backupDir)) {
      fs.mkdirSync(backupDir, { recursive: true });
    }
    
    const filePath = path.join(backupDir, filename);
    
    // Configuração do banco de dados a partir da DATABASE_URL
    const databaseUrl = process.env.DATABASE_URL || 'postgresql://postgres:postgres@postgres:5432/erp_freitex?schema=public';
    const url = new URL(databaseUrl);
    
    const dbConfig = {
      host: url.hostname,
      port: url.port || '5432',
      database: url.pathname.substring(1).split('?')[0],
      username: url.username,
      password: url.password
    };

    // Comando para criar backup completo
    const pgDumpCommand = `PGPASSWORD="${dbConfig.password}" pg_dump -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.username} -d ${dbConfig.database} --no-password --verbose --clean --no-owner --no-privileges --no-comments > "${filePath}"`;

    console.log('Iniciando backup completo do banco de dados...');
    console.log(`Comando: ${pgDumpCommand.replace(dbConfig.password, '***')}`);

    // Executar comando de backup
    const { stdout, stderr } = await execAsync(pgDumpCommand);

    // pg_dump envia informações detalhadas para stderr, mas isso é normal
    // Só consideramos erro se houver mensagens de erro reais
    if (stderr && !stderr.includes('WARNING') && !stderr.includes('pg_dump:') && !stderr.includes('last built-in OID')) {
      console.error('Erro no backup:', stderr);
      return res.status(500).json({
        success: false,
        message: 'Erro ao criar backup do banco de dados',
        error: stderr
      });
    }

    console.log('pg_dump executado com sucesso');
    if (stderr) {
      console.log('Informações do pg_dump:', stderr.substring(0, 200) + '...');
    }

    // Verificar se o arquivo foi criado
    const fileInfo = getFileInfo(filePath);
    if (!fileInfo.exists) {
      return res.status(500).json({
        success: false,
        message: 'Arquivo de backup não foi criado'
      });
    }

    // Criar registro do backup no banco
    const backupRecord = await prisma.backup.create({
      data: {
        filename,
        filePath,
        size: fileInfo.size,
        status: 'completed',
        type: 'full',
        description: description || 'Backup completo do sistema',
        createdAt: new Date()
      }
    });

    console.log(`Backup criado com sucesso: ${filename}`);
    console.log(`Tamanho: ${fileInfo.size}`);
    console.log(`Caminho: ${filePath}`);

    return res.status(201).json({
      success: true,
      message: 'Backup criado com sucesso',
      data: {
        id: backupRecord.id,
        filename: backupRecord.filename,
        size: backupRecord.size,
        createdAt: backupRecord.createdAt,
        status: backupRecord.status,
        type: backupRecord.type,
        description: backupRecord.description
      }
    });

  } catch (error) {
    console.error('Erro ao criar backup:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor ao criar backup',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};

// Listar todos os backups
export const listBackups = async (req: AuthRequest, res: Response) => {
  try {
    console.log('🔍 Listando backups...');
    console.log('📋 Headers da requisição:', req.headers);
    console.log('👤 Usuário autenticado:', req.user ? `${req.user.name} (${req.user.role})` : 'Não autenticado');
    
    // Verificar se a tabela existe primeiro
    try {
      const tableExists = await prisma.$queryRaw`
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = 'backups'
        ) as table_exists;
      `;
      console.log('📋 Tabela backups existe?', tableExists);
      
      // Se a tabela não existir, tentar criá-la
      if (!tableExists || !(tableExists as any)[0]?.table_exists) {
        console.log('🔧 Tabela backups não existe, tentando criar...');
        await prisma.$executeRaw`
          CREATE TABLE IF NOT EXISTS "public"."backups" (
            "id" TEXT NOT NULL,
            "filename" TEXT NOT NULL,
            "filePath" TEXT NOT NULL,
            "size" TEXT NOT NULL,
            "status" TEXT NOT NULL DEFAULT 'completed',
            "type" TEXT NOT NULL DEFAULT 'full',
            "description" TEXT,
            "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
            "updatedAt" TIMESTAMP(3) NOT NULL,
            CONSTRAINT "backups_pkey" PRIMARY KEY ("id")
          );
        `;
        console.log('✅ Tabela backups criada com sucesso!');
      }
    } catch (tableError) {
      console.error('❌ Erro ao verificar/criar tabela backups:', tableError);
    }
    
    const backups = await prisma.backup.findMany({
      orderBy: { createdAt: 'desc' }
    });
    
    console.log(`📊 Encontrados ${backups.length} backups no banco de dados`);

    // Atualizar informações dos arquivos
    const backupsWithFileInfo = backups.map(backup => {
      const fileInfo = getFileInfo(backup.filePath);
      return {
        id: backup.id,
        filename: backup.filename,
        size: fileInfo.exists ? fileInfo.size : '0 Bytes',
        createdAt: backup.createdAt,
        status: fileInfo.exists ? backup.status : 'failed',
        type: backup.type,
        description: backup.description
      };
    });

    return res.status(200).json({
      success: true,
      data: backupsWithFileInfo
    });

  } catch (error) {
    console.error('Erro ao listar backups:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao listar backups',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};

// Download de backup
export const downloadBackup = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    
    const backup = await prisma.backup.findUnique({
      where: { id }
    });

    if (!backup) {
      return res.status(404).json({
        success: false,
        message: 'Backup não encontrado'
      });
    }

    if (!fs.existsSync(backup.filePath)) {
      return res.status(404).json({
        success: false,
        message: 'Arquivo de backup não encontrado'
      });
    }

    // Configurar headers para download
    res.setHeader('Content-Type', 'application/sql');
    res.setHeader('Content-Disposition', `attachment; filename="${backup.filename}"`);
    
    // Enviar arquivo
    const fileStream = fs.createReadStream(backup.filePath);
    fileStream.pipe(res);
    
    // Retornar para evitar erro de TypeScript
    return;

  } catch (error) {
    console.error('Erro ao fazer download do backup:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao fazer download do backup',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};

// Excluir backup
export const deleteBackup = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    
    const backup = await prisma.backup.findUnique({
      where: { id }
    });

    if (!backup) {
      return res.status(404).json({
        success: false,
        message: 'Backup não encontrado'
      });
    }

    // Excluir arquivo físico
    if (fs.existsSync(backup.filePath)) {
      fs.unlinkSync(backup.filePath);
    }

    // Excluir registro do banco
    await prisma.backup.delete({
      where: { id }
    });

    return res.status(200).json({
      success: true,
      message: 'Backup excluído com sucesso'
    });

  } catch (error) {
    console.error('Erro ao excluir backup:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao excluir backup',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};

// Restaurar backup (apenas para usuários master)
export const restoreBackup = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    
    // Verificar se é usuário master
    if (req.user?.role !== 'master') {
      return res.status(403).json({
        success: false,
        message: 'Apenas usuários master podem restaurar backups'
      });
    }

    const backup = await prisma.backup.findUnique({
      where: { id }
    });

    if (!backup) {
      return res.status(404).json({
        success: false,
        message: 'Backup não encontrado'
      });
    }

    if (!fs.existsSync(backup.filePath)) {
      return res.status(404).json({
        success: false,
        message: 'Arquivo de backup não encontrado'
      });
    }

    // Configuração do banco de dados a partir da DATABASE_URL
    const databaseUrl = process.env.DATABASE_URL || 'postgresql://postgres:postgres@postgres:5432/erp_freitex?schema=public';
    const url = new URL(databaseUrl);
    
    const dbConfig = {
      host: url.hostname,
      port: url.port || '5432',
      database: url.pathname.substring(1).split('?')[0],
      username: url.username,
      password: url.password
    };

    // Primeiro, filtrar o arquivo para remover linhas incompatíveis
    const filteredFilePath = `${backup.filePath}.filtered`;
    const filterCommand = `grep -v "transaction_timeout" "${backup.filePath}" > "${filteredFilePath}"`;
    
    console.log('Filtrando arquivo de backup...');
    await execAsync(filterCommand);

    // Comando para restaurar backup
    const psqlCommand = `PGPASSWORD="${dbConfig.password}" psql -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.username} -d ${dbConfig.database} --no-password -f "${filteredFilePath}"`;

    console.log('Iniciando restauração do backup...');
    console.log(`Comando: ${psqlCommand.replace(dbConfig.password, '***')}`);

    // Executar comando de restauração
    const { stdout, stderr } = await execAsync(psqlCommand);
    
    // Limpar arquivo filtrado
    if (fs.existsSync(filteredFilePath)) {
      fs.unlinkSync(filteredFilePath);
    }

    if (stderr && !stderr.includes('WARNING')) {
      console.error('Erro na restauração:', stderr);
      return res.status(500).json({
        success: false,
        message: 'Erro ao restaurar backup',
        error: stderr
      });
    }

    console.log('Backup restaurado com sucesso');

    return res.status(200).json({
      success: true,
      message: 'Backup restaurado com sucesso'
    });

  } catch (error) {
    console.error('Erro ao restaurar backup:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao restaurar backup',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};

// Importar backup externo
export const importBackup = async (req: Request, res: Response) => {
  try {
    // Verificar se o arquivo foi enviado
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Nenhum arquivo de backup foi enviado'
      });
    }

    const filePath = req.file.path;
    const originalName = req.file.originalname;
    const fileSize = req.file.size;

    console.log('Iniciando importação de backup externo...');
    console.log(`Arquivo: ${originalName}`);
    console.log(`Tamanho: ${(fileSize / 1024).toFixed(2)} KB`);
    console.log(`Caminho: ${filePath}`);

    // Verificar se é um arquivo SQL válido
    const fileContent = fs.readFileSync(filePath, 'utf8');
    if (!fileContent.includes('PostgreSQL database dump') && !fileContent.includes('COPY public.')) {
      // Limpar arquivo inválido
      fs.unlinkSync(filePath);
      return res.status(400).json({
        success: false,
        message: 'Arquivo não parece ser um backup PostgreSQL válido'
      });
    }

    // Configuração do banco de dados a partir da DATABASE_URL
    const databaseUrl = process.env.DATABASE_URL || 'postgresql://postgres:postgres@postgres:5432/erp_freitex?schema=public';
    const url = new URL(databaseUrl);
    
    const dbConfig = {
      host: url.hostname,
      port: url.port || '5432',
      database: url.pathname.substring(1).split('?')[0],
      username: url.username,
      password: url.password
    };

    // Primeiro, filtrar o arquivo para remover linhas incompatíveis
    const filteredFilePath = `${filePath}.filtered`;
    const filterCommand = `grep -v "transaction_timeout" "${filePath}" > "${filteredFilePath}"`;
    
    console.log('Filtrando arquivo de backup...');
    await execAsync(filterCommand);

    // Comando para restaurar backup
    const psqlCommand = `PGPASSWORD="${dbConfig.password}" psql -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.username} -d ${dbConfig.database} --no-password -f "${filteredFilePath}"`;

    console.log('Iniciando restauração do backup importado...');
    console.log(`Comando: ${psqlCommand.replace(dbConfig.password, '***')}`);

    // Executar comando de restauração
    const { stdout, stderr } = await execAsync(psqlCommand);
    
    // Limpar arquivo filtrado
    if (fs.existsSync(filteredFilePath)) {
      fs.unlinkSync(filteredFilePath);
    }

    if (stderr && !stderr.includes('WARNING')) {
      console.error('Erro na restauração:', stderr);
      return res.status(500).json({
        success: false,
        message: 'Erro ao restaurar backup importado',
        error: stderr
      });
    }

    console.log('Backup importado e restaurado com sucesso!');

    // Registrar o backup importado no banco de dados
    const backupRecord = await prisma.backup.create({
      data: {
        filename: originalName,
        filePath: filePath,
        size: `${(fileSize / 1024).toFixed(2)} KB`,
        status: 'completed',
        type: 'full',
        description: `Backup importado: ${originalName}`
      }
    });

    return res.status(200).json({
      success: true,
      message: 'Backup importado e restaurado com sucesso!',
      data: {
        id: backupRecord.id,
        filename: backupRecord.filename,
        size: backupRecord.size,
        createdAt: backupRecord.createdAt
      }
    });

  } catch (error) {
    console.error('Erro ao importar backup:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao importar backup',
      error: error instanceof Error ? error.message : 'Erro desconhecido'
    });
  }
};
