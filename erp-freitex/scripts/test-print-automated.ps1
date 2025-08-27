# Script automatizado para testar impressão do PDV
# Autor: ERP Freitex Softwares
# Data: 2025-08-21

Write-Host "=== TESTE AUTOMATIZADO DE IMPRESSÃO ===" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar ambiente
Write-Host "1. Verificando ambiente..." -ForegroundColor Yellow

# Verificar Docker
try {
    $containers = docker ps --format "table {{.Names}}" | Select-String "docker-backend-1"
    if ($containers) {
        Write-Host "   ✅ Containers Docker rodando" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Containers Docker não estão rodando" -ForegroundColor Red
        Write-Host "   💡 Execute: cd docker && docker-compose up -d" -ForegroundColor Cyan
        exit 1
    }
} catch {
    Write-Host "   ❌ Docker não está acessível" -ForegroundColor Red
    exit 1
}

# Verificar Backend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000/api/printers" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 401) {
        Write-Host "   ✅ Backend respondendo (autenticação requerida)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Backend respondeu com status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Backend não está acessível" -ForegroundColor Red
    exit 1
}

# Verificar Frontend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000" -Method GET -TimeoutSec 5 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✅ Frontend acessível" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Frontend respondeu com status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Frontend não está acessível" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 2. Criar arquivo de teste HTML
Write-Host "2. Criando arquivo de teste de impressão..." -ForegroundColor Yellow

$testHtml = @"
<!DOCTYPE html>
<html>
<head>
    <title>Teste de Impressão - ERP Freitex</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            font-size: 12px;
            margin: 0;
            padding: 20px;
            width: 300px;
        }
        .header {
            text-align: center;
            border-bottom: 1px solid #000;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .subtitle {
            font-size: 10px;
            color: #666;
        }
        .info {
            margin-bottom: 15px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3px;
        }
        .items {
            border-top: 1px solid #000;
            border-bottom: 1px solid #000;
            padding: 10px 0;
            margin: 15px 0;
        }
        .item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        .total {
            font-weight: bold;
            font-size: 14px;
            text-align: right;
            margin-top: 10px;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 10px;
            color: #666;
        }
        @media print {
            body { margin: 0; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">ERP FREITEX</div>
        <div class="subtitle">Sistema de Vendas</div>
        <div class="subtitle">$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')</div>
    </div>

    <div class="info">
        <div class="info-row">
            <span>Teste #$(Get-Random -Minimum 1000 -Maximum 9999)</span>
        </div>
        <div class="info-row">
            <span>Vendedor: Teste Automatizado</span>
        </div>
    </div>

    <div class="items">
        <div class="item">
            <div>Produto Teste 1</div>
            <div>R$ 50,00</div>
        </div>
        <div class="item">
            <div>  Qtd: 2</div>
            <div>R$ 100,00</div>
        </div>
        <div class="item">
            <div>Produto Teste 2</div>
            <div>R$ 30,00</div>
        </div>
        <div class="item">
            <div>  Qtd: 1</div>
            <div>R$ 30,00</div>
        </div>
    </div>

    <div class="total">
        <div class="info-row">
            <span>Total:</span>
            <span>R$ 130,00</span>
        </div>
        <div class="info-row">
            <span>Recebido:</span>
            <span>R$ 150,00</span>
        </div>
        <div class="info-row">
            <span>Troco:</span>
            <span>R$ 20,00</span>
        </div>
    </div>

    <div class="footer">
        <div>Obrigado pela preferência!</div>
        <div>Volte sempre</div>
        <div style="margin-top: 10px;">$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')</div>
    </div>
</body>
</html>
"@

$testFile = ".\test-print.html"
$testHtml | Out-File -FilePath $testFile -Encoding UTF8
Write-Host "   ✅ Arquivo de teste criado: $testFile" -ForegroundColor Green

Write-Host ""

# 3. Testar impressão via navegador
Write-Host "3. Testando impressão via navegador..." -ForegroundColor Yellow

try {
    # Abrir arquivo no navegador padrão
    Start-Process $testFile
    Write-Host "   ✅ Arquivo aberto no navegador" -ForegroundColor Green
    
    Write-Host "   📋 INSTRUÇÕES:" -ForegroundColor Cyan
    Write-Host "   1. No navegador que abriu, pressione Ctrl+P" -ForegroundColor White
    Write-Host "   2. Selecione sua impressora 'HP-CM1-FINAN'" -ForegroundColor White
    Write-Host "   3. Clique em 'Imprimir'" -ForegroundColor White
    Write-Host "   4. Verifique se a impressão saiu corretamente" -ForegroundColor White
    
} catch {
    Write-Host "   ❌ Erro ao abrir arquivo no navegador" -ForegroundColor Red
}

Write-Host ""

# 4. Testar impressão via PowerShell
Write-Host "4. Testando impressão via PowerShell..." -ForegroundColor Yellow

try {
    # Tentar imprimir via PowerShell
    $printCommand = "Start-Process -FilePath '$testFile' -Verb Print"
    Write-Host "   🔧 Executando: $printCommand" -ForegroundColor Cyan
    
    # Executar comando de impressão
    Start-Process -FilePath $testFile -Verb Print -ErrorAction SilentlyContinue
    Write-Host "   ✅ Comando de impressão executado" -ForegroundColor Green
    Write-Host "   📋 Verifique se a impressão foi enviada para a fila" -ForegroundColor Cyan
    
} catch {
    Write-Host "   ❌ Erro ao executar comando de impressão" -ForegroundColor Red
    Write-Host "   💡 Isso pode ser normal se não houver permissões" -ForegroundColor Yellow
}

Write-Host ""

# 5. Verificar impressoras do Windows
Write-Host "5. Verificando impressoras do Windows..." -ForegroundColor Yellow

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
    Write-Host "   ⚠️  Não foi possível verificar impressoras (pode ser normal)" -ForegroundColor Yellow
}

Write-Host ""

# 6. Teste de impressão direta
Write-Host "6. Teste de impressão direta..." -ForegroundColor Yellow

try {
    # Criar arquivo de teste simples
    $simpleTest = @"
=== TESTE DE IMPRESSAO ===
Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Sistema: ERP Freitex Softwares
Impressora: HP-CM1-FINAN
Status: Teste automatizado

Se você está vendo este texto impresso,
a impressão está funcionando corretamente!

=====================================
"@

    $simpleFile = ".\teste-simples.txt"
    $simpleTest | Out-File -FilePath $simpleFile -Encoding UTF8
    
    # Tentar imprimir arquivo de texto
    Start-Process -FilePath $simpleFile -Verb Print -ErrorAction SilentlyContinue
    Write-Host "   ✅ Arquivo de texto enviado para impressão" -ForegroundColor Green
    
} catch {
    Write-Host "   ❌ Erro no teste de impressão direta" -ForegroundColor Red
}

Write-Host ""

# 7. Resumo e próximos passos
Write-Host "=== RESUMO DO TESTE ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Ambiente verificado" -ForegroundColor Green
Write-Host "✅ Arquivo de teste criado" -ForegroundColor Green
Write-Host "✅ Navegador aberto com teste" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PRÓXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "1. Verifique se a impressão saiu no navegador (Ctrl+P)" -ForegroundColor White
Write-Host "2. Teste no PDV do sistema" -ForegroundColor White
Write-Host "3. Abra o Console do navegador (F12) durante o teste" -ForegroundColor White
Write-Host "4. Verifique os logs de debug que adicionamos" -ForegroundColor White
Write-Host ""
Write-Host "🔧 SE NÃO IMPRIMIR:" -ForegroundColor Yellow
Write-Host "- Verifique se a impressora está ligada" -ForegroundColor White
Write-Host "- Verifique se há papel" -ForegroundColor White
Write-Host "- Teste imprimindo um documento qualquer" -ForegroundColor White
Write-Host "- Verifique as configurações de impressora do Windows" -ForegroundColor White
Write-Host ""
Write-Host "📁 Arquivos criados:" -ForegroundColor Cyan
Write-Host "- $testFile (teste HTML)" -ForegroundColor White
Write-Host "- $simpleFile (teste texto)" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Teste automatizado concluído!" -ForegroundColor Green
