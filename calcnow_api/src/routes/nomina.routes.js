const express = require("express");
const router = express.Router();
const { calcularNomina } = require("../controllers/nomina.controller");

// POST http://localhost:3000/api/nomina/calcular
router.post("/calcular", calcularNomina);

module.exports = router;