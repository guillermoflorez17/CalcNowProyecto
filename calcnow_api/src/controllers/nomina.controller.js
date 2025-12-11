const nominaService = require('../services/nomina.service');

exports.calcular = (req, res) => {
    try {
        // Los datos vienen en el cuerpo de la petición (req.body)
        const resultado = nominaService.ejecutarCalculo(req.body);
        res.status(200).json({ success: true, data: resultado });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

exports.guardar = async (req, res) => {
    try {
        const { id_usuario, datos_entrada, resultado_calculo } = req.body;
        const resultado = await nominaService.guardarHistorial(id_usuario, datos_entrada, resultado_calculo);
        res.status(201).json(resultado);
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.historial = async (req, res) => {
    try {
        const { id_usuario } = req.params;
        const lista = await nominaService.obtenerHistorial(id_usuario);
        res.status(200).json({ success: true, data: lista });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const resultado = await nominaService.eliminarHistorial(id);
        res.status(200).json({ success: true, resultado });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};