# Script para diagnosticar e corrigir problemas de impressora
Write-Host "=== DIAGNÓSTICO DE IMPRESSORA ===" -ForegroundColor Cyan

# 1. Verificar impressoras instaladas
Write-Host "1. Verificando impressoras instaladas..." -ForegroundColor Yellow
try {
    $printers = Get-Printer -ErrorAction SilentlyContinue
    if ($printers) {
        Write-Host "   ✅ Impressoras encontradas:" -ForegroundColor Green
        $printers | ForEach-Object {
            $status = if ($_.PrinterStatus -eq "Idle") { "✅" } else { "⚠️" }
            Write-Host "      $status $($_.Name) - $($_.PrinterStatus)" -ForegroundColor White
        }
    } else {
        Write-Host "   ❌ Nenhuma impressora encontrada" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Erro ao verificar impressoras" -ForegroundColor Red
}

Write-Host ""

# 2. Verificar serviços de impressão
Write-Host "2. Verificando serviços de impressão..." -ForegroundColor Yellow
try {
    $spooler = Get-Service -Name "Spooler" -ErrorAction SilentlyContinue
    if ($spooler) {
        $status = if ($spooler.Status -eq "Running") { "✅" } else { "❌" }
        Write-Host "   $status Spooler de Impressão: $($spooler.Status)" -ForegroundColor White
    } else {
        Write-Host "   ❌ Serviço Spooler não encontrado" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Erro ao verificar serviços" -ForegroundColor Red
}

Write-Host ""

# 3. Verificar drivers de impressora
Write-Host "3. Verificando drivers de impressora..." -ForegroundColor Yellow
try {
    $drivers = Get-PrinterDriver -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*HP*" -or $_.Name -like "*LaserJet*" }
    if ($drivers) {
        Write-Host "   ✅ Drivers HP encontrados:" -ForegroundColor Green
        $drivers | ForEach-Object {
            Write-Host "      - $($_.Name)" -ForegroundColor White
        }
    } else {
        Write-Host "   ⚠️  Nenhum driver HP encontrado" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Erro ao verificar drivers" -ForegroundColor Red
}

Write-Host ""

# 4. Verificar portas de impressão
Write-Host "4. Verificando portas de impressão..." -ForegroundColor Yellow
try {
    $ports = Get-PrinterPort -ErrorAction SilentlyContinue
    if ($ports) {
        Write-Host "   ✅ Portas encontradas:" -ForegroundColor Green
        $ports | ForEach-Object {
            Write-Host "      - $($_.Name) ($($_.PrinterHostAddress))" -ForegroundColor White
        }
    } else {
        Write-Host "   ❌ Nenhuma porta encontrada" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Erro ao verificar portas" -ForegroundColor Red
}

Write-Host ""

# 5. Instruções de correção
Write-Host "=== INSTRUÇÕES DE CORREÇÃO ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Se sua impressora 'HP-CM1-FINAN' não aparecer:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Abra 'Configurações' do Windows" -ForegroundColor White
Write-Host "2. Vá em 'Dispositivos' > 'Impressoras e scanners'" -ForegroundColor White
Write-Host "3. Clique em 'Adicionar impressora ou scanner'" -ForegroundColor White
Write-Host "4. Selecione sua impressora HP LaserJet 400 M401n" -ForegroundColor White
Write-Host "5. Instale os drivers necessários" -ForegroundColor White
Write-Host ""
Write-Host "OU use o método alternativo:" -ForegroundColor Yellow
Write-Host "1. Pressione Win+R" -ForegroundColor White
Write-Host "2. Digite: control printers" -ForegroundColor White
Write-Host "3. Clique em 'Adicionar impressora'" -ForegroundColor White
Write-Host ""
Write-Host "Se a impressora estiver conectada via rede:" -ForegroundColor Yellow
Write-Host "1. Verifique se está na mesma rede" -ForegroundColor White
Write-Host "2. Teste o ping para o IP da impressora" -ForegroundColor White
Write-Host "3. Configure a porta TCP/IP correta" -ForegroundColor White
Write-Host ""
Write-Host "Após configurar, execute este script novamente para verificar." -ForegroundColor Cyan
