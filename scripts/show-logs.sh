#!/bin/bash

echo "📝 Logs do WSS13 MVP"
echo "===================="

# Logs do MySQL
echo "🗄️  MySQL Status:"
sudo systemctl status mysql --no-pager -l

echo ""
echo "🔧 Backend Logs:"
if [ -f ../backend/logs/app.log ]; then
    tail -n 20 ../backend/logs/app.log
else
    echo "Nenhum log encontrado. Execute 'npm run dev' no diretório backend para ver logs em tempo real."
fi

echo ""
echo "💡 Para logs em tempo real do backend:"
echo "cd ../backend && npm run dev"
