import express from 'express';
import { uploadController } from '../controllers/uploadController';
import { authenticateToken } from '../middleware/auth';
import { uploadProductImages } from '../middleware/upload';

const router = express.Router();

// Upload de imagens de produtos
router.post('/product-images', 
  authenticateToken, 
  uploadProductImages, 
  uploadController.uploadProductImages
);

// Deletar imagem
router.delete('/images/:filename', 
  authenticateToken, 
  uploadController.deleteImage
);

export default router;
