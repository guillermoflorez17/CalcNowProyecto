const HipotecaService = require('../services/hipoteca.service');

exports.calcularHipoteca = (req, res) => {
    const { monto, interes, anios } = req.body;

    // 1. Validación de entrada
    if (!monto || !interes || !anios) {
        return res.status(400).json({ 
            success: false, 
            message: "Faltan datos requeridos" 
        });
    }

    // 2. Llamada al Servicio (Lógica)
    const resultado = HipotecaService.calcularAmortizacion(monto, interes, anios);

    // 3. Respuesta
    return res.json({
        success: true,
        data: resultado
    });
};