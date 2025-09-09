# Script PowerShell para build e push das imagens Docker para Docker Hub
# ERP Freitex Softwares

param(
    [string]$DockerUsername = "dreyfreitas",
    [string]$Version = "latest"
)

# Configurações
$ProjectName = "erp-freitex"

# Função para escrever mensagens coloridas
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "ERP Freitex - Build e Push para Docker Hub" "Cyan"
Write-ColorOutput "==============================================" "Cyan"

# Verificar se o Docker está rodando
try {
    docker info | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker não está rodando"
    }
} catch {
    Write-ColorOutput "Docker não está rodando. Por favor, inicie o Docker Desktop." "Red"
    exit 1
}

Write-ColorOutput "Username configurado: $DockerUsername" "Green"

# Tags das imagens
$FrontendTag = "${DockerUsername}/${ProjectName}-frontend:${Version}"
$BackendTag = "${DockerUsername}/${ProjectName}-backend:${Version}"
$NginxTag = "${DockerUsername}/${ProjectName}-nginx:${Version}"

Write-ColorOutput "Tags das imagens:" "Cyan"
Write-ColorOutput "   Frontend: $FrontendTag" "White"
Write-ColorOutput "   Backend:  $BackendTag" "White"
Write-ColorOutput "   Nginx:    $NginxTag" "White"
Write-Host ""

# Função para build
function Build-Image {
    param(
        [string]$Context,
        [string]$Dockerfile,
        [string]$Tag,
        [string]$Name
    )
    
    Write-ColorOutput "Fazendo build da imagem $Name..." "Cyan"
    Write-ColorOutput "   Context: $Context" "White"
    Write-ColorOutput "   Dockerfile: $Dockerfile" "White"
    Write-ColorOutput "   Tag: $Tag" "White"
    
    $buildCommand = "docker build -f `"$Dockerfile`" -t `"$Tag`" `"$Context`""
    Invoke-Expression $buildCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Build da imagem $Name concluído com sucesso!" "Green"
    } else {
        Write-ColorOutput "Erro no build da imagem $Name" "Red"
        exit 1
    }
    Write-Host ""
}

# Função para push
function Push-Image {
    param(
        [string]$Tag,
        [string]$Name
    )
    
    Write-ColorOutput "Fazendo push da imagem $Name..." "Cyan"
    Write-ColorOutput "   Tag: $Tag" "White"
    
    $pushCommand = "docker push `"$Tag`""
    Invoke-Expression $pushCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "Push da imagem $Name concluído com sucesso!" "Green"
    } else {
        Write-ColorOutput "Erro no push da imagem $Name" "Red"
        exit 1
    }
    Write-Host ""
}

# Navegar para o diretório do projeto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

Write-ColorOutput "Diretório atual: $(Get-Location)" "Cyan"
Write-Host ""

# Build das imagens
Write-ColorOutput "Iniciando build das imagens..." "Yellow"
Write-Host ""

# Build Frontend
Build-Image "frontend" "docker/Dockerfile.frontend" $FrontendTag "Frontend"

# Build Backend
Build-Image "backend" "docker/Dockerfile.backend" $BackendTag "Backend"

# Build Nginx
Build-Image "docker" "docker/Dockerfile.nginx" $NginxTag "Nginx"

Write-ColorOutput "Todos os builds concluídos com sucesso!" "Green"
Write-Host ""

# Push das imagens
Write-ColorOutput "Iniciando push das imagens..." "Yellow"
Write-Host ""

# Push Frontend
Push-Image $FrontendTag "Frontend"

# Push Backend
Push-Image $BackendTag "Backend"

# Push Nginx
Push-Image $NginxTag "Nginx"

Write-ColorOutput "Todas as imagens foram enviadas para o Docker Hub com sucesso!" "Green"
Write-Host ""
Write-ColorOutput "Resumo das imagens:" "Cyan"
Write-ColorOutput "   Frontend: $FrontendTag" "White"
Write-ColorOutput "   Backend:  $BackendTag" "White"
Write-ColorOutput "   Nginx:    $NginxTag" "White"
Write-Host ""
Write-ColorOutput "Proximos passos:" "Yellow"
Write-ColorOutput "   1. Atualize o docker-compose.yml com as novas tags" "White"
Write-ColorOutput "   2. Teste as imagens em outro ambiente" "White"
Write-ColorOutput "   3. Configure CI/CD para builds automáticos" "White"
Write-Host ""
Write-ColorOutput "Processo concluído!" "Green"