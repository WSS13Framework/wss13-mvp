#!/bin/bash

BACKUP_DIR="../backups"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/wss13_obras_$DATE.sql"

echo "💾 Fazendo backup do banco WSS13..."

# Criar diretório de backup se não existir
mkdir -p $BACKUP_DIR

# Fazer backup
mysqldump -u root -p wss13_obras > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "✅ Backup criado: $BACKUP_FILE"
    
    # Manter apenas os 5 backups mais recentes
    ls -t $BACKUP_DIR/wss13_obras_*.sql | tail -n +6 | xargs -r rm
    echo "🧹 Backups antigos removidos (mantendo os 5 mais recentes)"
else
    echo "❌ Erro ao criar backup"
    exit 1
fi
