#!/bin/bash

echo "🧪 Testando WSS13 MVP..."

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

passed=0
failed=0

# Função para testes
test_endpoint() {
    local url=$1
    local expected=$2
    local description=$3
    
    echo -n "Testing $description... "
    
    response=$(curl -s -w "%{http_code}" -o /tmp/test_response "$url")
    status_code="${response: -3}"
    
    if [ "$status_code" = "$expected" ]; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((passed++))
    else
        echo -e "${RED}❌ FAIL (got $status_code, expected $expected)${NC}"
        ((failed++))
    fi
}

echo "🔍 Iniciando testes do MVP..."
echo ""

# Teste 1: Health Check Backend
test_endpoint "http://localhost:3001/health" "200" "Backend Health Check"

# Teste 2: Listar Obras
test_endpoint "http://localhost:3001/api/obras" "200" "API - Listar Obras"

# Teste 3: Buscar Obra Específica
test_endpoint "http://localhost:3001/api/obras/1" "200" "API - Buscar Obra ID 1"

# Teste 4: n8n Health
test_endpoint "http://localhost:5678/healthz" "200" "n8n Health Check"

# Teste 5: MySQL Connection
echo -n "Testing MySQL Connection... "
if mysql -u root${MYSQL_PASSWORD:-""} -e "USE wss13_obras; SELECT 1;" &>/dev/null; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((passed++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((failed++))
fi

# Teste 6: Verificar Tabelas
echo -n "Testing Database Tables... "
table_count=$(mysql -u root${MYSQL_PASSWORD:-""} -s -N -e "USE wss13_obras; SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'wss13_obras';" 2>/dev/null)
if [ "$table_count" -ge "5" ]; then
    echo -e "${GREEN}✅ PASS ($table_count tables)${NC}"
    ((passed++))
else
    echo -e "${RED}❌ FAIL (found $table_count tables, expected 5+)${NC}"
    ((failed++))
fi

# Teste 7: Dados de Exemplo
echo -n "Testing Sample Data... "
obra_count=$(mysql -u root${MYSQL_PASSWORD:-""} -s -N -e "USE wss13_obras; SELECT COUNT(*) FROM obras;" 2>/dev/null)
if [ "$obra_count" -ge "3" ]; then
    echo -e "${GREEN}✅ PASS ($obra_count obras)${NC}"
    ((passed++))
else
    echo -e "${RED}❌ FAIL (found $obra_count obras, expected 3+)${NC}"
    ((failed++))
fi

# Teste 8: Frontend Files
echo -n "Testing Frontend Files... "
if [ -f "../frontend/index.html" ]; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((passed++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((failed++))
fi

# Teste 9: Webhook Test (se n8n estiver rodando)
echo -n "Testing Webhook Communication... "
webhook_response=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{"obra_id":1,"tipo":"teste","urgencia":"baixa","mensagem":"Teste automatizado","usuario_id":1}' \
    "http://localhost:5678/webhook/obra/comunicacao" 2>/dev/null)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((passed++))
else
    echo -e "${YELLOW}⚠️  SKIP (n8n webhook não disponível)${NC}"
fi

echo ""
echo "📊 Resultados dos Testes:"
echo -e "✅ Passou: ${GREEN}$passed${NC}"
echo -e "❌ Falhou: ${RED}$failed${NC}"

if [ $failed -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Todos os testes passaram! MVP está funcionando corretamente.${NC}"
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Configurar credenciais do n8n (OpenAI, Telegram)"
    echo "2. Importar workflows para o n8n"
    echo "3. Testar comunicação via Telegram"
    echo "4. Fazer deploy para produção"
    exit 0
else
    echo ""
    echo -e "${RED}💥 Alguns testes falharam. Verifique a configuração.${NC}"
    echo ""
    echo "🔧 Comandos úteis para debug:"
    echo "- ./show-logs.sh (ver logs)"
    echo "- ./stop-all.sh && ./start-all.sh (reiniciar)"
    echo "- mysql -u root (acessar banco)"
    exit 1
fi
