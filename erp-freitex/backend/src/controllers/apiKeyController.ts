import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import crypto from 'crypto';
import { AuthRequest, ApiKeyRequest } from '../types';

const prisma = new PrismaClient();

// Interface para dados de criação de API Key
interface CreateApiKeyData {
  name: string;
  permissions: string[];
}

// Interface para dados de atualização de API Key
interface UpdateApiKeyData {
  name?: string;
  permissions?: string[];
  isActive?: boolean;
}

// Gerar API Key única
const generateApiKey = (): string => {
  const prefix = 'sk_live_';
  const randomPart = crypto.randomBytes(16).toString('hex');
  return prefix + randomPart;
};

// Listar todas as API Keys da empresa
export const getApiKeys = async (req: AuthRequest, res: Response) => {
  try {
    const companyId = req.user?.companyId;

    if (!companyId) {
      return res.status(400).json({
        success: false,
        message: 'ID da empresa não encontrado'
      });
    }

    const apiKeys = await prisma.apiKey.findMany({
      where: {
        companyId: companyId
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    return res.status(200).json({
      success: true,
      data: apiKeys
    });
  } catch (error) {
    console.error('Erro ao buscar API Keys:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Criar nova API Key
export const createApiKey = async (req: AuthRequest, res: Response) => {
  try {
    const companyId = req.user?.companyId;
    const { name, permissions }: CreateApiKeyData = req.body;

    if (!companyId) {
      return res.status(400).json({
        success: false,
        message: 'ID da empresa não encontrado'
      });
    }

    // Validações
    if (!name || !name.trim()) {
      return res.status(400).json({
        success: false,
        message: 'Nome da API Key é obrigatório'
      });
    }

    if (!permissions || !Array.isArray(permissions) || permissions.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Pelo menos uma permissão deve ser selecionada'
      });
    }

    // Verificar se já existe uma API Key com o mesmo nome para a empresa
    const existingApiKey = await prisma.apiKey.findFirst({
      where: {
        companyId: companyId,
        name: name.trim()
      }
    });

    if (existingApiKey) {
      return res.status(400).json({
        success: false,
        message: 'Já existe uma API Key com este nome'
      });
    }

    // Gerar API Key única
    let apiKey: string;
    let isUnique = false;
    
    while (!isUnique) {
      apiKey = generateApiKey();
      const existingKey = await prisma.apiKey.findUnique({
        where: { key: apiKey }
      });
      if (!existingKey) {
        isUnique = true;
      }
    }

    // Criar API Key
    const newApiKey = await prisma.apiKey.create({
      data: {
        companyId: companyId,
        name: name.trim(),
        key: apiKey!,
        permissions: permissions,
        isActive: true
      }
    });

    return res.status(201).json({
      success: true,
      data: newApiKey,
      message: 'API Key criada com sucesso'
    });
  } catch (error) {
    console.error('Erro ao criar API Key:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Atualizar API Key
export const updateApiKey = async (req: AuthRequest, res: Response) => {
  try {
    const companyId = req.user?.companyId;
    const { id } = req.params;
    const { name, permissions, isActive }: UpdateApiKeyData = req.body;

    if (!companyId) {
      return res.status(400).json({
        success: false,
        message: 'ID da empresa não encontrado'
      });
    }

    // Verificar se a API Key existe e pertence à empresa
    const existingApiKey = await prisma.apiKey.findFirst({
      where: {
        id: id,
        companyId: companyId
      }
    });

    if (!existingApiKey) {
      return res.status(404).json({
        success: false,
        message: 'API Key não encontrada'
      });
    }

    // Validações para atualização
    if (name && name.trim() && name.trim() !== existingApiKey.name) {
      // Verificar se já existe outra API Key com o mesmo nome
      const duplicateApiKey = await prisma.apiKey.findFirst({
        where: {
          companyId: companyId,
          name: name.trim(),
          id: { not: id }
        }
      });

      if (duplicateApiKey) {
        return res.status(400).json({
          success: false,
          message: 'Já existe uma API Key com este nome'
        });
      }
    }

    if (permissions && (!Array.isArray(permissions) || permissions.length === 0)) {
      return res.status(400).json({
        success: false,
        message: 'Pelo menos uma permissão deve ser selecionada'
      });
    }

    // Atualizar API Key
    const updateData: any = {};
    if (name !== undefined) updateData.name = name.trim();
    if (permissions !== undefined) updateData.permissions = permissions;
    if (isActive !== undefined) updateData.isActive = isActive;

    const updatedApiKey = await prisma.apiKey.update({
      where: { id: id },
      data: updateData
    });

    return res.status(200).json({
      success: true,
      data: updatedApiKey,
      message: 'API Key atualizada com sucesso'
    });
  } catch (error) {
    console.error('Erro ao atualizar API Key:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Deletar API Key
export const deleteApiKey = async (req: AuthRequest, res: Response) => {
  try {
    const companyId = req.user?.companyId;
    const { id } = req.params;

    if (!companyId) {
      return res.status(400).json({
        success: false,
        message: 'ID da empresa não encontrado'
      });
    }

    // Verificar se a API Key existe e pertence à empresa
    const existingApiKey = await prisma.apiKey.findFirst({
      where: {
        id: id,
        companyId: companyId
      }
    });

    if (!existingApiKey) {
      return res.status(404).json({
        success: false,
        message: 'API Key não encontrada'
      });
    }

    // Deletar API Key
    await prisma.apiKey.delete({
      where: { id: id }
    });

    return res.status(200).json({
      success: true,
      message: 'API Key removida com sucesso'
    });
  } catch (error) {
    console.error('Erro ao deletar API Key:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Obter API Key específica
export const getApiKeyById = async (req: AuthRequest, res: Response) => {
  try {
    const companyId = req.user?.companyId;
    const { id } = req.params;

    if (!companyId) {
      return res.status(400).json({
        success: false,
        message: 'ID da empresa não encontrado'
      });
    }

    const apiKey = await prisma.apiKey.findFirst({
      where: {
        id: id,
        companyId: companyId
      }
    });

    if (!apiKey) {
      return res.status(404).json({
        success: false,
        message: 'API Key não encontrada'
      });
    }

    return res.status(200).json({
      success: true,
      data: apiKey
    });
  } catch (error) {
    console.error('Erro ao buscar API Key:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Middleware para validar API Key (para uso em rotas da API pública)
export const validateApiKey = async (req: ApiKeyRequest, res: Response, next: Function) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'API Key não fornecida'
      });
    }

    const apiKey = authHeader.substring(7); // Remove 'Bearer '

    // Buscar API Key no banco
    const apiKeyData = await prisma.apiKey.findUnique({
      where: { key: apiKey },
      include: { company: true }
    });

    if (!apiKeyData) {
      return res.status(401).json({
        success: false,
        message: 'API Key inválida'
      });
    }

    if (!apiKeyData.isActive) {
      return res.status(401).json({
        success: false,
        message: 'API Key inativa'
      });
    }

    // Verificar se a empresa está ativa
    if (!apiKeyData.company.isActive) {
      return res.status(401).json({
        success: false,
        message: 'Empresa inativa'
      });
    }

    // Atualizar estatísticas de uso
    await prisma.apiKey.update({
      where: { id: apiKeyData.id },
      data: {
        lastUsed: new Date(),
        usageCount: { increment: 1 }
      }
    });

    // Adicionar informações da API Key ao request
    req.apiKey = {
      ...apiKeyData,
      lastUsed: apiKeyData.lastUsed || undefined
    };
    req.companyId = apiKeyData.companyId;

    return next();
  } catch (error) {
    console.error('Erro ao validar API Key:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
};

// Verificar permissões da API Key
export const checkApiKeyPermission = (requiredPermission: string) => {
  return (req: ApiKeyRequest, res: Response, next: Function) => {
    if (!req.apiKey) {
      return res.status(401).json({
        success: false,
        message: 'API Key não validada'
      });
    }

    if (!req.apiKey.permissions.includes(requiredPermission)) {
      return res.status(403).json({
        success: false,
        message: 'Permissão insuficiente para esta operação'
      });
    }

    return next();
  };
};
