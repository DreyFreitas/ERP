# Teste simples de impressão automática
Write-Host "=== TESTE DE IMPRESSAO AUTOMATICA ===" -ForegroundColor Cyan

# Criar conteúdo de teste
$testContent = @"
=== COMPROVANTE DE VENDA ===
ERP FREITEX SOFTWARES
Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')

Venda #123
Vendedor: Teste Automático

ITENS:
- Produto Teste    R$ 50,00
  Qtd: 2            R$ 100,00

TOTAL:              R$ 100,00
Recebido:           R$ 100,00
Troco:              R$ 0,00

Método: Dinheiro

Obrigado pela preferência!
Volte sempre!

$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
"@

Write-Host "Conteúdo criado, tentando impressão automática..." -ForegroundColor Yellow

# Tentar impressão automática
try {
    # Método 1: Out-Printer (mais direto)
    Write-Host "Método 1: Out-Printer" -ForegroundColor Cyan
    $testContent | Out-Printer -ErrorAction SilentlyContinue
    Write-Host "✅ Out-Printer executado - verifique se a impressão saiu!" -ForegroundColor Green
    
    Start-Sleep -Seconds 2
    
    # Método 2: Salvar em arquivo e imprimir
    Write-Host "Método 2: Arquivo + Print" -ForegroundColor Cyan
    $tempFile = ".\teste-impressao-$(Get-Date -Format 'HHmmss').txt"
    $testContent | Out-File -FilePath $tempFile -Encoding UTF8
    Start-Process -FilePath $tempFile -Verb Print -ErrorAction SilentlyContinue
    Write-Host "✅ Arquivo enviado para impressão!" -ForegroundColor Green
    
    # Limpar arquivo temporário
    Start-Sleep -Seconds 3
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
    }
    
} catch {
    Write-Host "❌ Erro na impressão: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== RESULTADO ===" -ForegroundColor Cyan
Write-Host "Se a impressão saiu automaticamente, o sistema funciona!" -ForegroundColor Green
Write-Host "Agora teste no PDV do ERP!" -ForegroundColor Yellow
