# Script de Atualização Rápida - ERP Freitex
# Use este script quando fizer pequenas alterações

param(
    [string]$DockerUsername = "dreyfreitas",
    [string]$Version = "latest",
    [switch]$Frontend,
    [switch]$Backend,
    [switch]$Nginx,
    [switch]$All
)

$ProjectName = "erp-freitex"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "🔄 Atualização Rápida - ERP Freitex" "Cyan"
Write-ColorOutput "===================================" "Cyan"

# Se nenhum serviço especificado, atualizar todos
if (-not $Frontend -and -not $Backend -and -not $Nginx) {
    $All = $true
}

# Tags das imagens
$FrontendTag = "${DockerUsername}/${ProjectName}-frontend:${Version}"
$BackendTag = "${DockerUsername}/${ProjectName}-backend:${Version}"
$NginxTag = "${DockerUsername}/${ProjectName}-nginx:${Version}"

Write-ColorOutput "Username: $DockerUsername" "Green"
Write-ColorOutput "Versão: $Version" "Green"
Write-Host ""

# Função para build e push rápido
function Update-Image {
    param(
        [string]$Context,
        [string]$Dockerfile,
        [string]$Tag,
        [string]$Name
    )
    
    Write-ColorOutput "🔄 Atualizando $Name..." "Yellow"
    
    # Build
    Write-ColorOutput "   📦 Fazendo build..." "White"
    docker build -f $Dockerfile -t $Tag $Context
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "   ✅ Build concluído" "Green"
        
        # Push
        Write-ColorOutput "   📤 Fazendo push..." "White"
        docker push $Tag
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "   ✅ Push concluído" "Green"
        } else {
            Write-ColorOutput "   ❌ Erro no push" "Red"
            return $false
        }
    } else {
        Write-ColorOutput "   ❌ Erro no build" "Red"
        return $false
    }
    
    Write-Host ""
    return $true
}

# Navegar para o diretório do projeto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
Set-Location $projectRoot

$success = $true

# Atualizar Frontend
if ($All -or $Frontend) {
    if (-not (Update-Image "frontend" "docker/Dockerfile.frontend" $FrontendTag "Frontend")) {
        $success = $false
    }
}

# Atualizar Backend
if ($All -or $Backend) {
    if (-not (Update-Image "backend" "docker/Dockerfile.backend" $BackendTag "Backend")) {
        $success = $false
    }
}

# Atualizar Nginx
if ($All -or $Nginx) {
    if (-not (Update-Image "docker" "docker/Dockerfile.nginx" $NginxTag "Nginx")) {
        $success = $false
    }
}

# Resultado final
if ($success) {
    Write-ColorOutput "🎉 Atualização concluída com sucesso!" "Green"
    Write-Host ""
    Write-ColorOutput "📋 Imagens atualizadas:" "Cyan"
    if ($All -or $Frontend) { Write-ColorOutput "   Frontend: $FrontendTag" "White" }
    if ($All -or $Backend) { Write-ColorOutput "   Backend:  $BackendTag" "White" }
    if ($All -or $Nginx) { Write-ColorOutput "   Nginx:    $NginxTag" "White" }
} else {
    Write-ColorOutput "❌ Algumas atualizações falharam" "Red"
}

Write-Host ""
Write-ColorOutput "💡 Dica: Use -Frontend, -Backend ou -Nginx para atualizar apenas um serviço" "Yellow"
