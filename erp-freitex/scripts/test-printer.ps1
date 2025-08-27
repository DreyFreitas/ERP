# Script para testar configuração de impressoras
# Autor: ERP Freitex Softwares
# Data: 2025-08-21

Write-Host "Testando configuração de impressoras..." -ForegroundColor Yellow

# Verificar se o backend está rodando
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000/api/health" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "OK: Backend está funcionando" -ForegroundColor Green
    } else {
        Write-Host "ERRO: Backend respondeu com status $($response.StatusCode)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERRO: Backend não está acessível" -ForegroundColor Red
    exit 1
}

# Verificar se o frontend está acessível
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "OK: Frontend está acessível" -ForegroundColor Green
    } else {
        Write-Host "AVISO: Frontend respondeu com status $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "AVISO: Frontend não está acessível" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Para testar a impressão:" -ForegroundColor Cyan
Write-Host "1. Abra o navegador em: http://localhost:7000" -ForegroundColor White
Write-Host "2. Faça login no sistema" -ForegroundColor White
Write-Host "3. Vá para PDV" -ForegroundColor White
Write-Host "4. Faça uma venda de teste" -ForegroundColor White
Write-Host "5. Finalize a venda com a opção 'Imprimir' marcada" -ForegroundColor White
Write-Host "6. Abra o Console do navegador (F12) para ver os logs" -ForegroundColor White
Write-Host "7. Verifique se aparecem as mensagens de debug" -ForegroundColor White

Write-Host ""
Write-Host "Possíveis problemas:" -ForegroundColor Cyan
Write-Host "- Pop-ups bloqueados pelo navegador" -ForegroundColor White
Write-Host "- Impressora não configurada como padrão no Windows" -ForegroundColor White
Write-Host "- Driver de impressora não instalado" -ForegroundColor White
Write-Host "- Impressora offline ou sem papel" -ForegroundColor White

Write-Host ""
Write-Host "Para verificar impressoras do Windows:" -ForegroundColor Cyan
Write-Host "1. Pressione Win+R" -ForegroundColor White
Write-Host "2. Digite: control printers" -ForegroundColor White
Write-Host "3. Verifique se sua impressora está listada e ativa" -ForegroundColor White

