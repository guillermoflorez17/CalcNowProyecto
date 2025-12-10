const express = require('express');
const router = express.Router();
const { calcularHipoteca } = require('../controllers/hipoteca.controller');

// POST http://localhost:3000/api/hipoteca/calcular
router.post('/calcular', calcularHipoteca);

module.exports = router;