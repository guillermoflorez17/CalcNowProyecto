const express = require('express');
const router = express.Router();
const nominaController = require('../controllers/nomina.controller');

router.post('/calcular', nominaController.calcular);
router.post('/guardar', nominaController.guardar);
router.get('/historial/:id_usuario', nominaController.historial);
router.delete('/:id', nominaController.eliminar);

module.exports = router;