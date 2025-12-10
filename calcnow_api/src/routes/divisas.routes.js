const express = require('express');
const router = express.Router();
const { convertirDivisa } = require('../controllers/divisas.controller');

// POST http://localhost:3000/api/divisas/convertir
router.post('/convertir', convertirDivisa);

module.exports = router;