const db = require('../config/database');

const obrasController = {
    // Listar todas as obras
    async listarObras(req, res) {
        try {
            const [rows] = await db.execute(`
                SELECT 
                    o.*,
                    e.nome_engenheiro,
                    COUNT(p.id) as problemas_abertos,
                    DATEDIFF(o.prazo_entrega, NOW()) as dias_restantes
                FROM obras o 
                LEFT JOIN engenheiros e ON o.engenheiro_responsavel = e.id
                LEFT JOIN problemas p ON o.id = p.obra_id AND p.status = 'aberto'
                WHERE o.ativo = 1
                GROUP BY o.id
                ORDER BY o.created_at DESC
            `);
            
            res.json({
                success: true,
                data: rows,
                total: rows.length
            });
        } catch (error) {
            console.error('Erro ao listar obras:', error);
            res.status(500).json({ success: false, error: error.message });
        }
    },

    // Buscar obra específica
    async buscarObra(req, res) {
        try {
            const { id } = req.params;
            const [rows] = await db.execute(`
                SELECT 
                    o.*,
                    e.nome_engenheiro,
                    e.email,
                    e.whatsapp
                FROM obras o 
                LEFT JOIN engenheiros e ON o.engenheiro_responsavel = e.id
                WHERE o.id = ? AND o.ativo = 1
            `, [id]);
            
            if (rows.length === 0) {
                return res.status(404).json({ success: false, error: 'Obra não encontrada' });
            }
            
            res.json({ success: true, data: rows[0] });
        } catch (error) {
            console.error('Erro ao buscar obra:', error);
            res.status(500).json({ success: false, error: error.message });
        }
    },

    // Atualizar progresso da obra
    async atualizarProgresso(req, res) {
        try {
            const { id } = req.params;
            const { progresso_percentual } = req.body;
            
            await db.execute(
                'UPDATE obras SET progresso_percentual = ?, updated_at = NOW() WHERE id = ?',
                [progresso_percentual, id]
            );
            
            res.json({ success: true, message: 'Progresso atualizado com sucesso' });
        } catch (error) {
            console.error('Erro ao atualizar progresso:', error);
            res.status(500).json({ success: false, error: error.message });
        }
    }
};

module.exports = obrasController;
