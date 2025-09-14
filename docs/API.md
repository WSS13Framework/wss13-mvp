# 📡 WSS13 API Documentation

Base URL: `http://localhost:3001/api`

## 🔐 Autenticação

Atualmente sem autenticação (MVP). Em produção usar JWT.

## 📋 Endpoints

### Obras

#### GET /obras
Lista todas as obras ativas

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nome_obra": "Residencial Vista Verde",
      "endereco": "Rua das Flores, 123",
      "progresso_percentual": 45.50,
      "status": "em_andamento",
      "nome_engenheiro": "João Silva",
      "problemas_abertos": 2,
      "dias_restantes": 180
    }
  ],
  "total": 1
}
```

#### GET /obras/:id
Busca obra específica

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "nome_obra": "Residencial Vista Verde",
    "endereco": "Rua das Flores, 123",
    "progresso_percentual": 45.50,
    "orcamento_total": 2500000.00,
    "custo_executado": 1125000.00,
    "nome_engenheiro": "João Silva",
    "email": "joao@wss13.com.br",
    "whatsapp": "21987654321"
  }
}
```

#### PUT /obras/:id/progresso
Atualiza progresso da obra

**Body:**
```json
{
  "progresso_percentual": 55.75
}
```

**Response:**
```json
{
  "success": true,
  "message": "Progresso atualizado com sucesso"
}
```

### Comunicações

#### POST /comunicacoes
Criar nova comunicação

**Body:**
```json
{
  "obra_id": 1,
  "tipo": "problema_urgente",
  "urgencia": "alta",
  "mensagem": "Problema detectado na fundação",
  "usuario_id": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Comunicação registrada",
  "id": 123
}
```

#### GET /comunicacoes/:obra_id
Listar comunicações da obra

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "tipo": "problema_urgente",
      "urgencia": "alta",
      "mensagem": "Problema detectado na fundação",
      "status": "pendente",
      "data_criacao": "2024-01-15T10:30:00Z",
      "nome_usuario": "João Silva"
    }
  ]
}
```

### Dashboard

#### GET /dashboard
Dados do dashboard executivo

**Response:**
```json
{
  "success": true,
  "data": {
    "resumo": {
      "total_obras": 3,
      "obras_no_prazo": 2,
      "obras_atrasadas": 1,
      "total_problemas": 5
    },
    "obras": [...],
    "insights_ia": "Base nos dados analisados...",
    "timestamp": "2024-01-15T15:30:00Z"
  }
}
```

## 📊 Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `500` - Internal Server Error

## 🔗 Webhooks n8n

### POST /webhook/obra/comunicacao
Recebe comunicações via n8n

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "obra_id": 1,
  "tipo": "problema_urgente",
  "urgencia": "critica",
  "mensagem": "Vazamento detectado no subsolo",
  "usuario_id": 1,
  "nome_obra": "Residencial Vista Verde",
  "usuario_nome": "João Silva"
}
```

### POST /webhook/obra/plantas/upload
Upload de plantas via n8n

**Body:**
```json
{
  "obra_id": 1,
  "tipo_planta": "estrutural",
  "planta_url": "https://exemplo.com/planta.pdf",
  "usuario_id": 1,
  "observacoes": "Nova versão com correções"
}
```

## 🧪 Testes

### Curl Examples

**Listar obras:**
```bash
curl -X GET http://localhost:3001/api/obras
```

**Criar comunicação:**
```bash
curl -X POST http://localhost:3001/api/comunicacoes \
  -H "Content-Type: application/json" \
  -d '{
    "obra_id": 1,
    "tipo": "problema_urgente",
    "urgencia": "alta",
    "mensagem": "Teste de comunicação",
    "usuario_id": 1
  }'
```

**Webhook n8n:**
```bash
curl -X POST http://localhost:5678/webhook/obra/comunicacao \
  -H "Content-Type: application/json" \
  -d '{
    "obra_id": 1,
    "tipo": "problema_urgente",
    "urgencia": "critica",
    "mensagem": "Teste via webhook",
    "usuario_id": 1
  }'
```
