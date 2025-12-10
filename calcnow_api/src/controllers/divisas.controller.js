const divisasService = require('../services/divisas.service');

exports.convertirDivisa = (req, res) => {
    console.log("💱 Divisas Request:", req.body);
    const { cantidad, origen, destino } = req.body;

    // Llamamos al servicio
    const response = divisasService.procesarCambio(cantidad, origen, destino);

    if (response.success) {
        return res.json(response);
    } else {
        return res.status(400).json(response);
    }
};