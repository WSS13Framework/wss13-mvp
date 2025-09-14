#!/bin/bash

echo "⚙️  Configurando n8n em produção..."

# Este script deve ser executado no servidor
if [ "$1" != "--server" ]; then
    echo "📝 Instruções para configurar n8n no servidor:"
    echo ""
    echo "1. SSH no seu servidor:"
    echo "   ssh root@SEU_IP"
    echo ""
    echo "2. Instalar n8n:"
    echo "   npm install -g n8n"
    echo ""
    echo "3. Configurar variáveis de ambiente:"
    echo "   export N8N_HOST=0.0.0.0"
    echo "   export N8N_PORT=5678"
    echo "   export N8N_PROTOCOL=https"
    echo "   export N8N_WEBHOOK_URL=https://wss13.com.br/webhook/"
    echo "   export WEBHOOK_URL=https://wss13.com.br/webhook/"
    echo ""
    echo "4. Iniciar n8n:"
    echo "   pm2 start n8n --name 'n8n-wss13'"
    echo "   pm2 save"
    echo ""
    echo "5. Acessar: https://wss13.com.br:5678"
    echo ""
    echo "6. Importar workflows da pasta n8n-workflows/"
    exit 0
fi

# Código para execução no servidor
echo "🔧 Instalando n8n..."
npm install -g n8n

echo "⚙️  Configurando variáveis..."
cat >> ~/.bashrc << 'N8N_ENV'
# n8n Configuration
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_PROTOCOL=https
export N8N_WEBHOOK_URL=https://wss13.com.br/webhook/
export WEBHOOK_URL=https://wss13.com.br/webhook/
N8N_ENV

source ~/.bashrc

echo "🚀 Iniciando n8n com PM2..."
pm2 start n8n --name "n8n-wss13"
pm2 save

echo "✅ n8n configurado!"
echo "🌐 Acesse: https://wss13.com.br:5678"
