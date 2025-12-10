const hipotecaService = require('../services/hipoteca.service');

exports.calcularHipoteca = (req, res) => {
    console.log("🏠 Hipoteca Request:", req.body);
    const { monto, interes, anios } = req.body;

    // Llamamos al servicio
    const response = hipotecaService.calcularPrestamo(monto, interes, anios);

    if (response.success) {
        return res.json(response.data);
    } else {
        return res.status(400).json(response);
    }
};