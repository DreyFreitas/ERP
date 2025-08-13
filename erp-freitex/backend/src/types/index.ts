import { Request } from 'express';

// Tipos de usuário
export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  permissions?: any;
  companyId?: string;
  isActive: boolean;
  lastLogin?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export enum UserRole {
  MASTER = 'master',
  ADMIN = 'admin',
  MANAGER = 'manager',
  SELLER = 'seller',
  STOCK = 'stock',
  FINANCIAL = 'financial',
}

// Tipos de empresa
export interface Company {
  id: string;
  name: string;
  cnpj?: string;
  email: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  logoUrl?: string;
  planType: PlanType;
  planStatus: PlanStatus;
  trialEndsAt?: Date;
  subscriptionEndsAt?: Date;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export enum PlanType {
  BASIC = 'basic',
  PROFESSIONAL = 'professional',
  ENTERPRISE = 'enterprise',
}

export enum PlanStatus {
  ACTIVE = 'active',
  SUSPENDED = 'suspended',
  CANCELLED = 'cancelled',
}

// Tipos de autenticação
export interface LoginCredentials {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: User;
  company?: Company;
  accessToken: string;
  refreshToken: string;
}

export interface AuthRequest extends Request {
  user?: User;
  companyId?: string;
}

// Tipos de API
export interface ApiResponse<T = any> {
  success: boolean;
  data: T | null;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Tipos de validação
export interface ValidationError {
  field: string;
  message: string;
}

// Tipos de configuração
export interface AppConfig {
  port: number;
  nodeEnv: string;
  jwtSecret: string;
  jwtRefreshSecret: string;
  databaseUrl: string;
  redisUrl?: string;
}
