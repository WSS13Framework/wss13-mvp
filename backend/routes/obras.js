const express = require('express');
const router = express.Router();
const obrasController = require('../controllers/obrasController');

router.get('/', obrasController.listarObras);
router.get('/:id', obrasController.buscarObra);
router.put('/:id/progresso', obrasController.atualizarProgresso);

module.exports = router;
