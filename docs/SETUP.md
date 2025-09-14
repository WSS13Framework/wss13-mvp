# 🛠 Guia de Instalação WSS13

## 📋 Pré-requisitos

### Sistema Operacional
- Pop_OS 22.04+ (ou Ubuntu 22.04+)
- 4GB RAM mínimo
- 10GB espaço livre

### Software Necessário
- Node.js 18+
- MySQL 8.0+
- Git
- Tilix (terminal preferido)

## 🚀 Instalação Rápida

### 1. Preparar Ambiente

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install -y nodejs npm mysql-server git curl tilix

# Verificar versões
node --version  # deve ser 18+
npm --version
mysql --version
```

### 2. Configurar MySQL

```bash
# Configurar MySQL
sudo mysql_secure_installation

# Criar usuário (opcional)
sudo mysql
mysql> CREATE USER 'wss13'@'localhost' IDENTIFIED BY 'senha_forte';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'wss13'@'localhost';
mysql> FLUSH PRIVILEGES;
mysql> EXIT;
```

### 3. Baixar e Configurar Projeto

```bash
# Clonar projeto
git clone https://github.com/seu-usuario/wss13-mvp.git
cd wss13-mvp

# Dar permissões aos scripts
chmod +x scripts/*.sh

# Configurar banco de dados
./scripts/setup-database.sh
```

### 4. Iniciar Serviços

```bash
# Iniciar todos os serviços
./scripts/start-all.sh
```

## ⚙️ Configuração Avançada

### n8n Setup

1. **Instalar n8n globalmente:**
```bash
npm install -g n8n
```

2. **Iniciar n8n:**
```bash
n8n start
```

3. **Acessar:** http://localhost:5678

4. **Importar workflows:**
   - Vá em Settings > Import
   - Selecione arquivos da pasta `n8n-workflows/`

### Configurar Credenciais n8n

1. **MySQL:**
   - Host: localhost
   - Database: wss13_obras
   - User: root (ou wss13)
   - Password: sua_senha

2. **OpenAI (opcional para MVP):**
   - API Key: sk-...
   - Organization: (deixe vazio)

3. **Telegram (opcional):**
   - Bot Token: obtido do @BotFather

### Configurar Telegram Bot

1. **Criar bot:**
```
1. Abra Telegram
2. Procure @BotFather
3. Digite /newbot
4. Siga instruções
5. Copie o token
```

2. **Configurar no n8n:**
   - Credentials > Add Credential
   - Telegram API
   - Cole o token

## 🐞 Solução de Problemas

### Erro: Porta 3001 em uso
```bash
# Matar processos na porta
sudo lsof -t -i:3001 | xargs kill -9
```

### Erro: MySQL não conecta
```bash
# Reiniciar MySQL
sudo systemctl restart mysql

# Verificar status
sudo systemctl status mysql
```

### Erro: n8n não acessa banco
1. Verificar credenciais no n8n
2. Testar conexão manual:
```bash
mysql -u root -p -e "USE wss13_obras; SHOW TABLES;"
```

### Erro: Frontend não carrega dados
1. Verificar se backend está rodando: http://localhost:3001/health
2. Verificar console do navegador (F12)
3. Verificar CORS no backend

## 📊 Verificar Instalação

### 1. Backend
```bash
curl http://localhost:3001/health
# Resposta esperada: {"status":"OK","timestamp":"..."}
```

### 2. Banco de Dados
```bash
mysql -u root -p -e "USE wss13_obras; SELECT COUNT(*) FROM obras;"
# Resposta esperada: 3 obras
```

### 3. Frontend
- Abrir arquivo: `frontend/index.html`
- Verificar se obras aparecem na tabela

### 4. n8n
- Acessar: http://localhost:5678
- Verificar se workflows estão importados

## 🚀 Deploy Produção

### Digital Ocean

1. **Criar Droplet:**
   - Ubuntu 22.04
   - 2GB RAM mínimo
   - Configurar domínio wss13.com.br

2. **Executar deploy:**
```bash
./scripts/deploy-digital-ocean.sh
```

3. **Configurar n8n:**
```bash
./scripts/setup-n8n-production.sh
```

### Variáveis de Produção

Criar arquivo `.env.production`:
```env
NODE_ENV=production
PORT=3001
DB_HOST=localhost
DB_USER=wss13_user
DB_PASSWORD=senha_forte_producao
DB_NAME=wss13_obras
DOMAIN=wss13.com.br
OPENAI_API_KEY=sk-...
TELEGRAM_BOT_TOKEN=123456:ABC...
```

## 📞 Suporte

Se tiver problemas:

1. **Verificar logs:**
```bash
./scripts/show-logs.sh
```

2. **Resetar ambiente:**
```bash
./scripts/stop-all.sh
./scripts/setup-database.sh
./scripts/start-all.sh
```

3. **Contato:**
   - Email: suporte@wss13.com.br
   - Telegram: @wss13support
   - Issues: GitHub do projeto
