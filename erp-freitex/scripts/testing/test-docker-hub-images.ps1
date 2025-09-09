# Script para testar as imagens do Docker Hub
# ERP Freitex Softwares

param(
    [string]$DockerUsername = "dreyfreitas"
)

$ProjectName = "erp-freitex"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "Testando imagens do Docker Hub" "Cyan"
Write-ColorOutput "===============================" "Cyan"

# Tags das imagens
$FrontendTag = "${DockerUsername}/${ProjectName}-frontend:latest"
$BackendTag = "${DockerUsername}/${ProjectName}-backend:latest"
$NginxTag = "${DockerUsername}/${ProjectName}-nginx:latest"

Write-ColorOutput "Imagens a serem testadas:" "Yellow"
Write-ColorOutput "   Frontend: $FrontendTag" "White"
Write-ColorOutput "   Backend:  $BackendTag" "White"
Write-ColorOutput "   Nginx:    $NginxTag" "White"
Write-Host ""

# Função para testar imagem
function Test-Image {
    param(
        [string]$Tag,
        [string]$Name
    )
    
    Write-ColorOutput "Testando imagem $Name..." "Cyan"
    Write-ColorOutput "   Tag: $Tag" "White"
    
    # Verificar se a imagem existe localmente
    $imageExists = docker images $Tag --format "{{.Repository}}:{{.Tag}}" 2>$null
    if ($imageExists) {
        Write-ColorOutput "   ✅ Imagem encontrada localmente" "Green"
    } else {
        Write-ColorOutput "   ⚠️  Imagem não encontrada localmente, fazendo pull..." "Yellow"
        docker pull $Tag
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "   ✅ Pull realizado com sucesso" "Green"
        } else {
            Write-ColorOutput "   ❌ Erro no pull da imagem" "Red"
            return $false
        }
    }
    
    # Testar se a imagem pode ser executada
    Write-ColorOutput "   Testando execução da imagem..." "White"
    $testContainer = "test-$Name-$(Get-Random)"
    
    try {
        # Executar container em modo detached para teste
        docker run -d --name $testContainer $Tag > $null 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "   ✅ Container executado com sucesso" "Green"
            
            # Parar e remover container de teste
            docker stop $testContainer > $null 2>&1
            docker rm $testContainer > $null 2>&1
            
            return $true
        } else {
            Write-ColorOutput "   ❌ Erro ao executar container" "Red"
            return $false
        }
    } catch {
        Write-ColorOutput "   ❌ Erro no teste: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Testar todas as imagens
$allTestsPassed = $true

Write-ColorOutput "Iniciando testes..." "Yellow"
Write-Host ""

# Testar Frontend
if (-not (Test-Image $FrontendTag "Frontend")) {
    $allTestsPassed = $false
}
Write-Host ""

# Testar Backend
if (-not (Test-Image $BackendTag "Backend")) {
    $allTestsPassed = $false
}
Write-Host ""

# Testar Nginx
if (-not (Test-Image $NginxTag "Nginx")) {
    $allTestsPassed = $false
}
Write-Host ""

# Resultado final
if ($allTestsPassed) {
    Write-ColorOutput "🎉 Todos os testes passaram! As imagens estão funcionando corretamente." "Green"
    Write-Host ""
    Write-ColorOutput "✅ Você pode usar as imagens do Docker Hub com:" "Yellow"
    Write-ColorOutput "   docker-compose -f docker/docker-compose.prod.yml up" "White"
} else {
    Write-ColorOutput "❌ Alguns testes falharam. Verifique as imagens." "Red"
}

Write-Host ""
Write-ColorOutput "Teste concluído!" "Cyan"
