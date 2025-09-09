const http = require('http');

function testHealthCheck() {
    const options = {
        hostname: 'localhost',
        port: 7001,
        path: '/health',
        method: 'GET',
        timeout: 5000
    };

    const req = http.request(options, (res) => {
        console.log(`✅ Health check status: ${res.statusCode}`);
        
        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });
        
        res.on('end', () => {
            try {
                const response = JSON.parse(data);
                console.log('📋 Health check response:');
                console.log(JSON.stringify(response, null, 2));
                
                if (response.status === 'healthy') {
                    console.log('🎉 Backend está saudável!');
                } else {
                    console.log('⚠️  Backend não está saudável');
                }
            } catch (error) {
                console.log('📄 Raw response:', data);
            }
        });
    });

    req.on('error', (error) => {
        console.error('❌ Erro ao testar health check:', error.message);
    });

    req.on('timeout', () => {
        console.error('⏰ Timeout ao testar health check');
        req.destroy();
    });

    req.end();
}

console.log('🔍 Testando health check do backend...');
testHealthCheck();
