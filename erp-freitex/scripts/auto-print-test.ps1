# Teste de impressão automática
Write-Host "=== TESTE DE IMPRESSAO AUTOMATICA ===" -ForegroundColor Cyan

# Criar arquivo de teste
$testContent = @"
=== COMPROVANTE DE VENDA ===
ERP FREITEX SOFTWARES
Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')

Venda #$(Get-Random -Minimum 1000 -Maximum 9999)
Vendedor: Teste Automático

ITENS:
- Produto Teste 1    R$ 50,00
  Qtd: 2            R$ 100,00
- Produto Teste 2    R$ 30,00
  Qtd: 1            R$ 30,00

TOTAL:              R$ 130,00
Recebido:           R$ 150,00
Troco:              R$ 20,00

Obrigado pela preferência!
Volte sempre!

$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
"@

$testFile = ".\comprovante-teste.txt"
$testContent | Out-File -FilePath $testFile -Encoding UTF8

Write-Host "Arquivo de teste criado: $testFile" -ForegroundColor Green

# Tentar impressão automática via PowerShell
Write-Host ""
Write-Host "Tentando impressão automática..." -ForegroundColor Yellow

try {
    # Método 1: Usando Start-Process com Verb Print
    Write-Host "Método 1: Start-Process com Verb Print" -ForegroundColor Cyan
    Start-Process -FilePath $testFile -Verb Print -ErrorAction SilentlyContinue
    Write-Host "✅ Comando executado - verifique se a impressão saiu" -ForegroundColor Green
    
    Start-Sleep -Seconds 2
    
    # Método 2: Usando Print-Object (se disponível)
    Write-Host "Método 2: Print-Object" -ForegroundColor Cyan
    try {
        $content = Get-Content $testFile -Raw
        $content | Out-Printer -ErrorAction SilentlyContinue
        Write-Host "✅ Print-Object executado" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Print-Object não disponível" -ForegroundColor Yellow
    }
    
    Start-Sleep -Seconds 2
    
    # Método 3: Usando WMI
    Write-Host "Método 3: WMI Print" -ForegroundColor Cyan
    try {
        $printers = Get-WmiObject -Class Win32_Printer | Where-Object { $_.Default -eq $true }
        if ($printers) {
            $printer = $printers[0]
            Write-Host "Impressora padrão: $($printer.Name)" -ForegroundColor White
            
            # Tentar imprimir via WMI
            $content = Get-Content $testFile -Raw
            $printer.Print($content)
            Write-Host "✅ WMI Print executado" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠️  WMI Print falhou" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ Erro na impressão automática" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== RESULTADO ===" -ForegroundColor Cyan
Write-Host "Se a impressão saiu automaticamente, o sistema funciona!" -ForegroundColor Green
Write-Host "Se não saiu, precisamos configurar a impressora no Windows" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para verificar se a impressão foi enviada:" -ForegroundColor Cyan
Write-Host "1. Abra 'Dispositivos e Impressoras'" -ForegroundColor White
Write-Host "2. Clique com botão direito na sua impressora" -ForegroundColor White
Write-Host "3. Selecione 'Ver o que está sendo impresso'" -ForegroundColor White
Write-Host "4. Verifique se há documentos na fila" -ForegroundColor White
