#!/bin/bash
# scripts/backup-database.sh

# --- Configurações ---
# Caminho absoluto para o diretório de backups (fora da pasta do projeto para segurança)
BACKUP_DIR="$HOME/backups/wss13_construction_db" # Usamos /var/backups para ser um local de sistema

# Nome do banco de dados (CONFIRMADO: 'wss13_construction')
DB_NAME="wss13_construction"

# Usuário MySQL com permissões mínimas para backup (criado anteriormente)
DB_USER="backup_user"

# Caminho para o arquivo de credenciais seguro
# Certifique-se de que o arquivo existe e tem permissões 600
MY_CNF_FILE="$HOME/.my.cnf"

# Timestamp para o nome do arquivo de backup
DATE=$(date +"%Y%m%d_%H%M%S")

# Nome completo do arquivo de backup com compressão
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

# Quantidade de backups a serem mantidos
RETENTION_COUNT=5

# --- Pré-verificações ---
echo "💾 Iniciando backup do banco '$DB_NAME'..."

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

# Verificar se o arquivo .my.cnf existe e tem permissões corretas
if [ ! -f "$MY_CNF_FILE" ]; then
    echo "❌ ERRO: Arquivo de credenciais '$MY_CNF_FILE' não encontrado."
    echo "Por favor, crie-o com as credenciais do '$DB_USER' e permissões 600."
    exit 1
fi
# Verificação de permissões e ajuste (se necessário)
if [ "$(stat -c "%a" "$MY_CNF_FILE")" != "600" ]; then
    echo "⚠️ AVISO: Permissões de '$MY_CNF_FILE' não são 600. Ajustando..."
    chmod 600 "$MY_CNF_FILE"
fi

# --- Execução do Backup ---
# ATENÇÃO AQUI: Esta é a linha do mysqldump. Ela DEVE usar --defaults-extra-file e o DB_USER.
mysqldump --defaults-extra-file="$MY_CNF_FILE" \
          --single-transaction \
          --routines \
          --triggers \
          -u "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

# --- Pós-processamento e Verificação ---
# Verifica o status de mysqldump (PIPESTATUS[0]) e gzip (PIPESTATUS[1])
if [ ${PIPESTATUS[0]} -eq 0 ] && [ ${PIPESTATUS[1]} -eq 0 ]; then
    echo "✅ Backup criado com sucesso: '$BACKUP_FILE'"

    # Remover backups antigos (mantendo os X mais recentes)
    # Garante que apenas os backups do DB_NAME específico sejam removidos
    ls -t "$BACKUP_DIR/$DB_NAME-*.sql.gz" 2>/dev/null | tail -n +$((RETENTION_COUNT + 1)) | xargs -r rm
    echo "�� Backups antigos removidos (mantendo os $RETENTION_COUNT mais recentes)."
else
    echo "❌ ERRO: Falha ao criar backup do banco '$DB_NAME'."
    echo "Verifique os logs do mysqldump e as permissões do usuário '$DB_USER'."
    # Adicionado para mostrar o erro exato do mysqldump se houver
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "Erro do mysqldump (exit code: ${PIPESTATUS[0]})"
    fi
    if [ ${PIPESTATUS[1]} -ne 0 ]; then
        echo "Erro do gzip (exit code: ${PIPESTATUS[1]})"
    fi
    exit 1
fi
