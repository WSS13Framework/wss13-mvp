-- =====================================
-- WSS13 - Database Setup
-- =====================================

DROP DATABASE IF EXISTS wss13_obras;
CREATE DATABASE wss13_obras;
USE wss13_obras;

-- Tabela de obras
CREATE TABLE obras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_obra VARCHAR(255) NOT NULL,
    endereco TEXT,
    status ENUM('planejamento', 'em_andamento', 'pausada', 'concluida') DEFAULT 'planejamento',
    progresso_percentual DECIMAL(5,2) DEFAULT 0,
    orcamento_total DECIMAL(12,2),
    custo_executado DECIMAL(12,2) DEFAULT 0,
    data_inicio DATE,
    prazo_entrega DATE,
    engenheiro_responsavel INT,
    ativo BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de engenheiros
CREATE TABLE engenheiros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_engenheiro VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    whatsapp VARCHAR(20),
    telegram_id VARCHAR(50),
    crea VARCHAR(20),
    especialidade VARCHAR(100),
    obra_id INT,
    ativo BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (obra_id) REFERENCES obras(id)
);

-- Tabela de comunicações
CREATE TABLE comunicacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    obra_id INT NOT NULL,
    tipo ENUM('problema_urgente', 'atualizacao_planta', 'atraso_material', 'qualidade', 'seguranca', 'financeiro') NOT NULL,
    urgencia ENUM('baixa', 'media', 'alta', 'critica') DEFAULT 'media',
    mensagem TEXT NOT NULL,
    usuario_id INT,
    status ENUM('pendente', 'lida', 'resolvida') DEFAULT 'pendente',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (obra_id) REFERENCES obras(id),
    FOREIGN KEY (usuario_id) REFERENCES engenheiros(id)
);

-- Inserir dados de exemplo
INSERT INTO obras (nome_obra, endereco, orcamento_total, data_inicio, prazo_entrega) VALUES
('Residencial Vista Verde', 'Rua das Flores, 123 - Niterói/RJ', 2500000.00, '2024-01-15', '2025-01-15'),
('Edifício Comercial Centro', 'Av. Principal, 456 - Niterói/RJ', 5000000.00, '2024-02-01', '2025-06-01'),
('Casa Unifamiliar Alto Padrão', 'Rua do Alto, 789 - Niterói/RJ', 1200000.00, '2024-03-01', '2024-12-01');

INSERT INTO engenheiros (nome_engenheiro, email, whatsapp, especialidade) VALUES
('João Silva', 'joao@wss13.com.br', '21987654321', 'Estrutural'),
('Maria Santos', 'maria@wss13.com.br', '21987654322', 'Arquitetura'),
('Pedro Costa', 'pedro@wss13.com.br', '21987654323', 'Instalações');
