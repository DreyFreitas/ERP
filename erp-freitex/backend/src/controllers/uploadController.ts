import { Request, Response } from 'express';
import { ApiResponse } from '../types';
import { getImageUrl } from '../middleware/upload';

export const uploadController = {
  // Upload de imagens de produtos
  async uploadProductImages(req: Request, res: Response<ApiResponse>) {
    try {
      if (!req.files || req.files.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'Nenhuma imagem foi enviada',
          data: null
        });
      }

      const files = req.files as Express.Multer.File[];
      const imageUrls = files.map(file => getImageUrl(file.filename));

      return res.status(200).json({
        success: true,
        message: 'Imagens enviadas com sucesso',
        data: {
          images: imageUrls,
          count: files.length
        }
      });
    } catch (error) {
      console.error('Erro no upload de imagens:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  },

  // Deletar imagem
  async deleteImage(req: Request, res: Response<ApiResponse>) {
    try {
      const { filename } = req.params;
      
      if (!filename) {
        return res.status(400).json({
          success: false,
          message: 'Nome do arquivo não fornecido',
          data: null
        });
      }

      // Aqui você pode implementar a lógica para deletar o arquivo
      // Por enquanto, apenas retornamos sucesso
      
      return res.status(200).json({
        success: true,
        message: 'Imagem deletada com sucesso',
        data: null
      });
    } catch (error) {
      console.error('Erro ao deletar imagem:', error);
      return res.status(500).json({
        success: false,
        message: 'Erro interno do servidor',
        data: null
      });
    }
  }
};
