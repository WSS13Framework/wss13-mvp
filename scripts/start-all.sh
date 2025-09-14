#!/bin/bash

echo "🚀 Iniciando WSS13 MVP..."

# Função para verificar se porta está em uso
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Porta $1 já está em uso"
        return 1
    else
        echo "✅ Porta $1 disponível"
        return 0
    fi
}

# Verificar portas necessárias
echo "🔍 Verificando portas..."
check_port 3001 # Backend
check_port 5678 # n8n
check_port 3306 # MySQL

# Iniciar MySQL se não estiver rodando
if ! pgrep -x "mysqld" > /dev/null; then
    echo "🗄️  Iniciando MySQL..."
    sudo systemctl start mysql
    sleep 3
fi

# Navegar para o diretório do backend
cd ../backend

# Instalar dependências se necessário
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependências do backend..."
    npm install
fi

# Iniciar backend em background
echo "🔧 Iniciando backend..."
npm run dev &
BACKEND_PID=$!

# Aguardar um pouco para o backend iniciar
sleep 5

# Verificar se backend está funcionando
if curl -s http://localhost:3001/health > /dev/null; then
    echo "✅ Backend iniciado com sucesso!"
else
    echo "❌ Erro ao iniciar backend"
fi

# Abrir frontend no navegador
if command -v google-chrome &> /dev/null; then
    echo "🌐 Abrindo dashboard no navegador..."
    google-chrome ../frontend/index.html &
elif command -v firefox &> /dev/null; then
    echo "🌐 Abrindo dashboard no Firefox..."
    firefox ../frontend/index.html &
else
    echo "📁 Abra manualmente: file://$(pwd)/../frontend/index.html"
fi

echo ""
echo "🎉 WSS13 MVP iniciado!"
echo "📊 Dashboard: file://$(pwd)/../frontend/index.html"
echo "🔧 Backend API: http://localhost:3001"
echo "⚙️  n8n: http://localhost:5678"
echo ""
echo "💡 Para parar todos os serviços: ./stop-all.sh"
echo "📝 Para ver logs: ./show-logs.sh"
echo ""

# Salvar PID do backend
echo $BACKEND_PID > backend.pid

# Manter script rodando
echo "Pressione Ctrl+C para parar todos os serviços..."
trap 'echo "🛑 Parando serviços..."; kill $BACKEND_PID 2>/dev/null; exit' INT
wait
