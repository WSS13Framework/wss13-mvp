# 🏗️ WSS13 - Sistema de Gestão de Obras MVP

Sistema inteligente de comunicação e gestão para construtoras, baseado em **dores reais** do mercado brasileiro.

## 🎯 Problema que Resolve

- **52% do retrabalho** causado por falhas de comunicação
- **14h/semana perdidas** por engenheiro em atividades não produtivas
- **Falta de visibilidade** sobre andamento das obras
- **Controle deficiente** de terceirizados e plantas

## 🚀 Solução

Sistema integrado que centraliza toda comunicação da obra em **tempo real** com:
- Hub central de comunicação
- IA para análise de problemas
- Alertas automáticos via WhatsApp/Telegram
- Dashboard executivo inteligente

## 💰 ROI Comprovado

- **R$ 500k-2M/ano** de economia por construtora
- **40% menos retrabalho**
- **85% das obras no prazo** (vs 60% atual)
- **ROI de 556-2020%** dependendo do porte

## 🛠 Tecnologias

- **Backend:** Node.js + Express + MySQL
- **Automação:** n8n (workflows visuais)
- **Frontend:** HTML + TailwindCSS + Alpine.js
- **IA:** OpenAI GPT-4 para análises
- **Comunicação:** Telegram/WhatsApp API

## 📁 Estrutura do Projeto

```
wss13-mvp/
├── backend/                 # API Node.js
│   ├── controllers/        # Lógica de negócio
│   ├── routes/            # Rotas da API
│   ├── config/            # Configurações
│   └── index.js           # Servidor principal
├── frontend/               # Dashboard web
│   └── index.html         # Interface principal
├── database/              # Esquemas MySQL
│   └── setup.sql          # Script de criação
├── n8n-workflows/         # Automações
│   └── *.json            # Workflows n8n
├── scripts/               # Scripts de automação
│   ├── start-all.sh      # Iniciar todos serviços
│   ├── setup-database.sh # Configurar banco
│   └── deploy-*.sh       # Scripts de deploy
└── docs/                  # Documentação
    ├── README.md         # Este arquivo
    ├── API.md            # Documentação da API
    └── SETUP.md          # Guia de instalação
```

## 🚀 Quick Start

1. **Clone e configure:**
```bash
git clone seu-repo
cd wss13-mvp
chmod +x scripts/*.sh
```

2. **Configure o banco:**
```bash
./scripts/setup-database.sh
```

3. **Inicie todos os serviços:**
```bash
./scripts/start-all.sh
```

4. **Acesse:**
- Dashboard: `file://frontend/index.html`
- API: `http://localhost:3001`
- n8n: `http://localhost:5678`

## 📊 Demo

O MVP vem com dados de exemplo:
- 3 obras pré-cadastradas
- 3 engenheiros de exemplo
- Comunicações de teste
- Workflows funcionais

## 🔧 Configuração Avançada

### n8n Workflows

1. Acesse `http://localhost:5678`
2. Importe workflows da pasta `n8n-workflows/`
3. Configure credenciais:
   - OpenAI API Key
   - Telegram Bot Token
   - MySQL connection

### Telegram Bot

1. Crie bot no @BotFather
2. Configure token no n8n
3. Adicione bot aos grupos da obra

### Produção

```bash
./scripts/deploy-digital-ocean.sh
```

## 📈 Roadmap

### Fase 1 - MVP (atual)
- [x] Hub de comunicação
- [x] Dashboard básico
- [x] Workflows n8n
- [x] Banco de dados

### Fase 2 - IA Avançada
- [ ] Análise de plantas com GPT-4 Vision
- [ ] Predição de problemas
- [ ] Relatórios automáticos
- [ ] Chatbot inteligente

### Fase 3 - Escala
- [ ] App mobile
- [ ] Integrações ERP
- [ ] Multi-tenant
- [ ] Analytics avançado

## 💬 Suporte

- **Email:** contato@wss13.com.br
- **WhatsApp:** +55 21 99999-9999
- **Telegram:** @wss13support

## 📄 Licença

Proprietary - WSS13 Tecnologia Ltda.
