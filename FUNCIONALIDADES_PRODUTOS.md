# Funcionalidades de Produtos - ERP Freitex

## Visão Geral

O sistema de produtos do ERP Freitex foi implementado com funcionalidades completas para gerenciamento de catálogo, incluindo upload de imagens, categorização e controle de estoque.

## Funcionalidades Implementadas

### 1. Cadastro de Produtos

#### Campos Disponíveis:
- **Nome do Produto** (obrigatório)
- **SKU** (Código Interno) - Código único interno da empresa
- **Código de Barras** - Código de barras universal do produto
- **Descrição** - Descrição detalhada do produto
- **Preço de Venda** (obrigatório)
- **Preço de Custo** - Preço de aquisição
- **Estoque Mínimo** - Quantidade mínima em estoque
- **Categoria** - Categorização do produto
- **Imagens** - Upload de múltiplas imagens

### 2. Upload de Imagens

#### Características:
- **Múltiplas imagens**: Até 5 imagens por produto
- **Formatos suportados**: JPEG, PNG, WebP
- **Tamanho máximo**: 5MB por imagem
- **Preview**: Visualização das imagens antes do envio
- **Remoção**: Possibilidade de remover imagens individualmente

#### Processo de Upload:
1. Selecionar imagens através do botão "Selecionar Imagens"
2. Visualizar preview das imagens selecionadas
3. Clicar em "Enviar Imagens" para fazer upload
4. As imagens são salvas no servidor e associadas ao produto

### 3. Sistema de Categorias

#### Funcionalidades:
- **Listagem de categorias**: Visualização de todas as categorias ativas
- **Criação de categorias**: Modal para criar novas categorias
- **Hierarquia**: Suporte a categorias pai/filho
- **Validação**: Não permite duplicação de nomes

#### Modal de Nova Categoria:
- **Nome da Categoria** (obrigatório)
- **Descrição** (opcional)
- **Validação**: Nome único obrigatório

### 4. Tabela de Produtos

#### Colunas Exibidas:
- **Imagem**: Thumbnail da primeira imagem do produto
- **Produto**: Nome do produto
- **SKU**: Código interno
- **Código de Barras**: Código de barras universal
- **Categoria**: Categoria do produto
- **Preço**: Preço de venda formatado
- **Estoque**: Quantidade total em estoque
- **Status**: Indicador visual do status do estoque
- **Ações**: Botões de editar e deletar

#### Status de Estoque:
- **Em Estoque**: Verde (estoque adequado)
- **Estoque Baixo**: Laranja (menos de 10 unidades)
- **Sem Estoque**: Vermelho (estoque zero)

### 5. Estatísticas

#### Cards Informativos:
- **Total de Produtos**: Número total de produtos cadastrados
- **Produtos Ativos**: Produtos com status ativo
- **Estoque Baixo**: Produtos com estoque abaixo de 10 unidades
- **Sem Estoque**: Produtos com estoque zero

### 6. Busca e Filtros

#### Funcionalidades:
- **Busca por nome**: Filtra produtos pelo nome
- **Busca por SKU**: Filtra produtos pelo código interno
- **Busca em tempo real**: Resultados atualizados conforme digitação

## Arquitetura Técnica

### Backend

#### Dependências Adicionadas:
- `multer`: Para upload de arquivos
- `@types/multer`: Tipos TypeScript para multer

#### Novos Arquivos:
- `src/middleware/upload.ts`: Middleware para upload de imagens
- `src/controllers/uploadController.ts`: Controlador de upload
- `src/controllers/categoryController.ts`: Controlador de categorias
- `src/routes/upload.ts`: Rotas de upload
- `src/routes/categories.ts`: Rotas de categorias

#### Configurações:
- **Storage**: Arquivos salvos em `/uploads`
- **Limites**: 5MB por arquivo, máximo 5 arquivos
- **Filtros**: Apenas imagens (JPEG, PNG, WebP)
- **Nomes únicos**: Timestamp + número aleatório

### Frontend

#### Novos Serviços:
- `src/services/uploadService.ts`: Serviço para upload de imagens
- `src/services/categoryService.ts`: Serviço para gerenciar categorias

#### Componentes Atualizados:
- `src/pages/CompanyProducts.tsx`: Interface completa de produtos

#### Funcionalidades:
- **Upload múltiplo**: Seleção e envio de múltiplas imagens
- **Preview**: Visualização das imagens antes do envio
- **Modal de categoria**: Criação rápida de novas categorias
- **Validação**: Validação de campos obrigatórios
- **Feedback**: Notificações de sucesso/erro

### Docker

#### Configurações:
- **Volume**: `uploads_data` para persistir imagens
- **Diretório**: `/app/uploads` no container
- **Permissões**: Acesso de leitura/escrita

## Endpoints da API

### Upload
- `POST /api/upload/product-images`: Upload de imagens de produtos
- `DELETE /api/upload/images/:filename`: Deletar imagem

### Categorias
- `GET /api/categories`: Listar categorias
- `POST /api/categories`: Criar categoria
- `PUT /api/categories/:id`: Atualizar categoria
- `DELETE /api/categories/:id`: Deletar categoria

### Produtos (atualizados)
- `POST /api/products`: Criar produto (inclui campo `images`)
- `PUT /api/products/:id`: Atualizar produto
- `GET /api/products`: Listar produtos (inclui imagens)

## Como Usar

### 1. Criar um Produto
1. Acesse a página de Produtos
2. Clique em "Novo Produto"
3. Preencha os campos obrigatórios (Nome e Preço de Venda)
4. Adicione imagens (opcional):
   - Clique em "Selecionar Imagens"
   - Escolha as imagens desejadas
   - Clique em "Enviar Imagens"
5. Selecione uma categoria ou crie uma nova
6. Clique em "Criar Produto"

### 2. Criar uma Categoria
1. No modal de "Novo Produto", clique em "Nova Categoria"
2. Preencha o nome da categoria (obrigatório)
3. Adicione uma descrição (opcional)
4. Clique em "Criar Categoria"

### 3. Gerenciar Produtos
- **Visualizar**: Todos os produtos aparecem na tabela
- **Buscar**: Use o campo de busca para filtrar produtos
- **Deletar**: Clique no ícone de lixeira para remover um produto
- **Editar**: Clique no ícone de edição (funcionalidade futura)

## Considerações de Segurança

- **Autenticação**: Todas as rotas requerem token JWT
- **Validação**: Validação de tipos de arquivo e tamanhos
- **Sanitização**: Nomes de arquivo únicos para evitar conflitos
- **Permissões**: Controle de acesso por empresa

## Próximas Funcionalidades

- [ ] Edição de produtos
- [ ] Variações de produtos (tamanho, cor, etc.)
- [ ] Histórico de movimentação de estoque
- [ ] Relatórios de produtos
- [ ] Integração com código de barras (scanner)
- [ ] Backup automático de imagens
