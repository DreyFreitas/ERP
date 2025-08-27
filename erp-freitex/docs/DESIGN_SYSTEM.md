# 🎨 Design System - ERP Freitex Softwares

## 🎯 Cores da Marca

### Cores Principais
```css
/* Azul Escuro - Cor Principal */
--primary-dark: #001f40;
--primary-dark-rgb: 0, 31, 64;

/* Azul Ciano - Cor Secundária */
--primary-cyan: #00c7cd;
--primary-cyan-rgb: 0, 199, 205;
```

### Paleta de Cores Completa

#### Cores Primárias
```css
/* Azul Escuro - Principal */
--primary-900: #001f40; /* Logo */
--primary-800: #002a56;
--primary-700: #00356c;
--primary-600: #004082;
--primary-500: #004b98;
--primary-400: #0056ae;
--primary-300: #0061c4;
--primary-200: #006cda;
--primary-100: #0077f0;

/* Azul Ciano - Secundário */
--secondary-900: #00c7cd; /* Logo */
--secondary-800: #00d4da;
--secondary-700: #00e1e7;
--secondary-600: #00eef4;
--secondary-500: #00fbff;
--secondary-400: #1affff;
--secondary-300: #33ffff;
--secondary-200: #4dffff;
--secondary-100: #66ffff;
```

#### Cores Neutras
```css
/* Cinzas */
--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-200: #e5e7eb;
--gray-300: #d1d5db;
--gray-400: #9ca3af;
--gray-500: #6b7280;
--gray-600: #4b5563;
--gray-700: #374151;
--gray-800: #1f2937;
--gray-900: #111827;
```

#### Cores de Status
```css
/* Sucesso */
--success-50: #f0fdf4;
--success-100: #dcfce7;
--success-500: #22c55e;
--success-600: #16a34a;
--success-700: #15803d;

/* Aviso */
--warning-50: #fffbeb;
--warning-100: #fef3c7;
--warning-500: #f59e0b;
--warning-600: #d97706;
--warning-700: #b45309;

/* Erro */
--error-50: #fef2f2;
--error-100: #fee2e2;
--error-500: #ef4444;
--error-600: #dc2626;
--error-700: #b91c1c;

/* Informação */
--info-50: #eff6ff;
--info-100: #dbeafe;
--info-500: #3b82f6;
--info-600: #2563eb;
--info-700: #1d4ed8;
```

## 🎨 Aplicação das Cores

### Interface Principal
```css
/* Header/Navbar */
--header-bg: var(--primary-900);
--header-text: #ffffff;
--header-accent: var(--secondary-900);

/* Sidebar */
--sidebar-bg: var(--primary-800);
--sidebar-text: #ffffff;
--sidebar-hover: var(--primary-700);
--sidebar-active: var(--secondary-900);

/* Botões */
--btn-primary-bg: var(--primary-900);
--btn-primary-hover: var(--primary-800);
--btn-primary-text: #ffffff;

--btn-secondary-bg: var(--secondary-900);
--btn-secondary-hover: var(--secondary-800);
--btn-secondary-text: #ffffff;

--btn-outline-border: var(--primary-900);
--btn-outline-text: var(--primary-900);
--btn-outline-hover: var(--primary-50);
```

### Componentes Específicos

#### Dashboard
```css
/* Cards */
--card-bg: #ffffff;
--card-border: var(--gray-200);
--card-shadow: 0 1px 3px rgba(0, 31, 64, 0.1);

/* Métricas */
--metric-primary: var(--primary-900);
--metric-secondary: var(--secondary-900);
--metric-success: var(--success-500);
--metric-warning: var(--warning-500);
--metric-error: var(--error-500);
```

#### PDV (Ponto de Venda)
```css
/* Interface PDV */
--pdv-bg: var(--gray-50);
--pdv-header: var(--primary-900);
--pdv-cart: #ffffff;
--pdv-product-hover: var(--primary-50);

/* Botões PDV */
--pdv-btn-primary: var(--primary-900);
--pdv-btn-success: var(--success-500);
--pdv-btn-warning: var(--warning-500);
```

#### Formulários
```css
/* Inputs */
--input-border: var(--gray-300);
--input-focus: var(--primary-900);
--input-error: var(--error-500);
--input-success: var(--success-500);

/* Labels */
--label-text: var(--gray-700);
--label-required: var(--error-500);
```

## 🎨 Gradientes

### Gradientes Principais
```css
/* Gradiente Principal */
--gradient-primary: linear-gradient(135deg, var(--primary-900) 0%, var(--primary-700) 100%);

/* Gradiente Secundário */
--gradient-secondary: linear-gradient(135deg, var(--secondary-900) 0%, var(--secondary-700) 100%);

/* Gradiente Hero */
--gradient-hero: linear-gradient(135deg, var(--primary-900) 0%, var(--secondary-900) 100%);

/* Gradiente Card */
--gradient-card: linear-gradient(135deg, #ffffff 0%, var(--gray-50) 100%);
```

## 🎨 Sombras

### Sistema de Sombras
```css
/* Sombras */
--shadow-sm: 0 1px 2px rgba(0, 31, 64, 0.05);
--shadow-md: 0 4px 6px rgba(0, 31, 64, 0.1);
--shadow-lg: 0 10px 15px rgba(0, 31, 64, 0.1);
--shadow-xl: 0 20px 25px rgba(0, 31, 64, 0.15);

/* Sombras Específicas */
--shadow-card: 0 1px 3px rgba(0, 31, 64, 0.1);
--shadow-button: 0 2px 4px rgba(0, 31, 64, 0.15);
--shadow-modal: 0 25px 50px rgba(0, 31, 64, 0.25);
```

## 🎨 Tipografia

### Fontes
```css
/* Fontes */
--font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
```

### Tamanhos
```css
/* Tamanhos de Fonte */
--text-xs: 0.75rem;   /* 12px */
--text-sm: 0.875rem;  /* 14px */
--text-base: 1rem;    /* 16px */
--text-lg: 1.125rem;  /* 18px */
--text-xl: 1.25rem;   /* 20px */
--text-2xl: 1.5rem;   /* 24px */
--text-3xl: 1.875rem; /* 30px */
--text-4xl: 2.25rem;  /* 36px */
```

### Pesos
```css
/* Pesos de Fonte */
--font-light: 300;
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

## 🎨 Espaçamento

### Sistema de Espaçamento
```css
/* Espaçamentos */
--space-1: 0.25rem;  /* 4px */
--space-2: 0.5rem;   /* 8px */
--space-3: 0.75rem;  /* 12px */
--space-4: 1rem;     /* 16px */
--space-5: 1.25rem;  /* 20px */
--space-6: 1.5rem;   /* 24px */
--space-8: 2rem;     /* 32px */
--space-10: 2.5rem;  /* 40px */
--space-12: 3rem;    /* 48px */
--space-16: 4rem;    /* 64px */
--space-20: 5rem;    /* 80px */
```

## 🎨 Bordas e Raios

### Sistema de Bordas
```css
/* Raios de Borda */
--radius-sm: 0.25rem;  /* 4px */
--radius-md: 0.375rem; /* 6px */
--radius-lg: 0.5rem;   /* 8px */
--radius-xl: 0.75rem;  /* 12px */
--radius-2xl: 1rem;    /* 16px */
--radius-full: 9999px;

/* Bordas */
--border-thin: 1px;
--border-medium: 2px;
--border-thick: 3px;
```

## 🎨 Breakpoints

### Responsividade
```css
/* Breakpoints */
--breakpoint-sm: 640px;
--breakpoint-md: 768px;
--breakpoint-lg: 1024px;
--breakpoint-xl: 1280px;
--breakpoint-2xl: 1536px;
```

## 🎨 Implementação no Material-UI

### Tema Customizado
```typescript
import { createTheme } from '@mui/material/styles';

export const theme = createTheme({
  palette: {
    primary: {
      main: '#001f40',
      light: '#004b98',
      dark: '#001a35',
      contrastText: '#ffffff',
    },
    secondary: {
      main: '#00c7cd',
      light: '#00fbff',
      dark: '#009fa5',
      contrastText: '#ffffff',
    },
    success: {
      main: '#22c55e',
      light: '#4ade80',
      dark: '#16a34a',
    },
    warning: {
      main: '#f59e0b',
      light: '#fbbf24',
      dark: '#d97706',
    },
    error: {
      main: '#ef4444',
      light: '#f87171',
      dark: '#dc2626',
    },
    grey: {
      50: '#f9fafb',
      100: '#f3f4f6',
      200: '#e5e7eb',
      300: '#d1d5db',
      400: '#9ca3af',
      500: '#6b7280',
      600: '#4b5563',
      700: '#374151',
      800: '#1f2937',
      900: '#111827',
    },
  },
  typography: {
    fontFamily: '"Inter", "Roboto", "Helvetica", "Arial", sans-serif',
    h1: {
      fontWeight: 700,
      color: '#001f40',
    },
    h2: {
      fontWeight: 600,
      color: '#001f40',
    },
    h3: {
      fontWeight: 600,
      color: '#001f40',
    },
    h4: {
      fontWeight: 500,
      color: '#001f40',
    },
    h5: {
      fontWeight: 500,
      color: '#001f40',
    },
    h6: {
      fontWeight: 500,
      color: '#001f40',
    },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: '8px',
          textTransform: 'none',
          fontWeight: 500,
        },
        containedPrimary: {
          backgroundColor: '#001f40',
          '&:hover': {
            backgroundColor: '#001a35',
          },
        },
        containedSecondary: {
          backgroundColor: '#00c7cd',
          '&:hover': {
            backgroundColor: '#009fa5',
          },
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          boxShadow: '0 1px 3px rgba(0, 31, 64, 0.1)',
        },
      },
    },
  },
});
```

## 🎨 CSS Variables (Global)

### Arquivo CSS Global
```css
:root {
  /* Cores da Marca */
  --primary-dark: #001f40;
  --primary-cyan: #00c7cd;
  
  /* Paleta Completa */
  --primary-900: #001f40;
  --primary-800: #002a56;
  --primary-700: #00356c;
  --primary-600: #004082;
  --primary-500: #004b98;
  --primary-400: #0056ae;
  --primary-300: #0061c4;
  --primary-200: #006cda;
  --primary-100: #0077f0;
  
  --secondary-900: #00c7cd;
  --secondary-800: #00d4da;
  --secondary-700: #00e1e7;
  --secondary-600: #00eef4;
  --secondary-500: #00fbff;
  --secondary-400: #1affff;
  --secondary-300: #33ffff;
  --secondary-200: #4dffff;
  --secondary-100: #66ffff;
  
  /* Cores de Status */
  --success-500: #22c55e;
  --warning-500: #f59e0b;
  --error-500: #ef4444;
  --info-500: #3b82f6;
  
  /* Neutras */
  --gray-50: #f9fafb;
  --gray-100: #f3f4f6;
  --gray-200: #e5e7eb;
  --gray-300: #d1d5db;
  --gray-400: #9ca3af;
  --gray-500: #6b7280;
  --gray-600: #4b5563;
  --gray-700: #374151;
  --gray-800: #1f2937;
  --gray-900: #111827;
  
  /* Sombras */
  --shadow-sm: 0 1px 2px rgba(0, 31, 64, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 31, 64, 0.1);
  --shadow-lg: 0 10px 15px rgba(0, 31, 64, 0.1);
  --shadow-xl: 0 20px 25px rgba(0, 31, 64, 0.15);
  
  /* Raios */
  --radius-sm: 0.25rem;
  --radius-md: 0.375rem;
  --radius-lg: 0.5rem;
  --radius-xl: 0.75rem;
  --radius-2xl: 1rem;
  --radius-full: 9999px;
}
```

## 🎨 Exemplos de Uso

### Botões
```css
.btn-primary {
  background-color: var(--primary-900);
  color: white;
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}

.btn-secondary {
  background-color: var(--secondary-900);
  color: white;
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}
```

### Cards
```css
.card {
  background-color: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--gray-200);
}
```

### Gradientes
```css
.hero-section {
  background: var(--gradient-hero);
  color: white;
}

.card-gradient {
  background: var(--gradient-card);
}
```

---

**Nota**: Este design system deve ser implementado tanto no Material-UI quanto em CSS customizado para garantir consistência visual em todo o projeto ERP Freitex.
