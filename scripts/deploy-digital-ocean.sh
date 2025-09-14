#!/bin/bash

echo "🚀 Deploy WSS13 para Digital Ocean..."

# Variáveis (configurar com seus dados)
DROPLET_IP="SEU_IP_AQUI"
DOMAIN="wss13.com.br"
USER="root"

echo "🔍 Verificando configurações..."

if [ "$DROPLET_IP" == "SEU_IP_AQUI" ]; then
    echo "❌ Configure o IP do seu droplet na variável DROPLET_IP"
    exit 1
fi

# Criar arquivo de configuração para produção
cat > ../backend/.env.production << 'PROD_EOF'
# Production Environment
NODE_ENV=production
PORT=3001

# Database
DB_HOST=localhost
DB_USER=wss13_user
DB_PASSWORD=GERAR_SENHA_FORTE
DB_NAME=wss13_obras

# Domain
DOMAIN=wss13.com.br
WEBHOOK_URL=https://wss13.com.br/webhook

# API Keys (configurar no servidor)
OPENAI_API_KEY=
TELEGRAM_BOT_TOKEN=
PROD_EOF

echo "📦 Criando pacote para deploy..."
tar -czf ../wss13-mvp.tar.gz -C .. --exclude='node_modules' --exclude='.git' --exclude='*.log' wss13-mvp/

echo "📤 Enviando para o servidor..."
scp ../wss13-mvp.tar.gz $USER@$DROPLET_IP:/tmp/

echo "⚙️  Executando setup no servidor..."
ssh $USER@$DROPLET_IP << 'REMOTE_EOF'
    # Atualizar sistema
    apt update && apt upgrade -y
    
    # Instalar dependências
    apt install -y nodejs npm mysql-server nginx certbot python3-certbot-nginx
    
    # Configurar MySQL
    mysql_secure_installation
    
    # Extrair projeto
    cd /var/www
    tar -xzf /tmp/wss13-mvp.tar.gz
    chown -R www-data:www-data wss13-mvp
    
    # Instalar dependências Node.js
    cd wss13-mvp/backend
    npm install --production
    
    # Configurar Nginx
    cat > /etc/nginx/sites-available/wss13 << 'NGINX_EOF'
server {
    listen 80;
    server_name wss13.com.br www.wss13.com.br;
    
    # Frontend
    location / {
        root /var/www/wss13-mvp/frontend;
        index index.html;
        try_files $uri $uri/ =404;
    }
    
    # Backend API
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
    
    # n8n webhook
    location /webhook/ {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX_EOF
    
    # Ativar site
    ln -s /etc/nginx/sites-available/wss13 /etc/nginx/sites-enabled/
    rm /etc/nginx/sites-enabled/default
    nginx -t && systemctl reload nginx
    
    # Configurar SSL
    certbot --nginx -d wss13.com.br -d www.wss13.com.br --non-interactive --agree-tos --email seu-email@exemplo.com
    
    # Configurar PM2 para manter aplicação rodando
    npm install -g pm2
    cd /var/www/wss13-mvp/backend
    pm2 start index.js --name "wss13-backend"
    pm2 startup
    pm2 save
    
    echo "✅ Deploy concluído!"
    echo "🌐 Site disponível em: https://wss13.com.br"
REMOTE_EOF

echo "🎉 Deploy concluído!"
echo "🌐 Acesse: https://wss13.com.br"
