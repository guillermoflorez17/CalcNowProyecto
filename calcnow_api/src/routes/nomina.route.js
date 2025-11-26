const express = require("express");
const router = express.Router();
const { calcularNomina } = require("../controllers/nomina.controller.js");

router.post("/calcular", calcularNomina);

module.exports = router;