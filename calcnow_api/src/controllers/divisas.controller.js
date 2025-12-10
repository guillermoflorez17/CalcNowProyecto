const DivisaService = require('../services/divisas.service');

exports.convertirDivisa = (req, res) => {
    const { cantidad, origen, destino } = req.body;

    if (!cantidad || !origen || !destino) {
        return res.status(400).json({ success: false, message: "Datos incompletos" });
    }

    const respuestaServicio = DivisaService.convertirMoneda(cantidad, origen, destino);

    if (respuestaServicio.success) {
        return res.json({
            success: true,
            origen,
            destino,
            cantidad,
            resultado: respuestaServicio.resultado,
            tasa: respuestaServicio.tasa_aplicada
        });
    } else {
        return res.status(400).json({ 
            success: false, 
            message: "Divisa no soportada" 
        });
    }
};