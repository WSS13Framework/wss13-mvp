#!/bin/bash

echo "🗄️  Configurando banco de dados WSS13..."

# Verificar se MySQL está rodando
if ! pgrep -x "mysqld" > /dev/null; then
    echo "🚀 Iniciando MySQL..."
    sudo systemctl start mysql
    sleep 3
fi

# Executar script SQL
echo "📝 Executando script de criação do banco..."
mysql -u root -p < ../database/setup.sql

if [ $? -eq 0 ]; then
    echo "✅ Banco de dados configurado com sucesso!"
    echo "📊 Dados de exemplo inseridos"
    echo ""
    echo "Credenciais padrão:"
    echo "- Database: wss13_obras"
    echo "- User: root"
    echo "- Password: (sua senha do MySQL)"
else
    echo "❌ Erro ao configurar banco de dados"
    exit 1
fi
