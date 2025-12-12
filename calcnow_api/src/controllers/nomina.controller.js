const nominaService = require('../services/nomina.service');

exports.calcular = (req, res) => {
    try {
        const resultado = nominaService.ejecutarCalculo(req.body);
        res.status(200).json(resultado);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.guardar = async(req, res) => {
    try {
        const { id_usuario, datos_entrada, resultado_calculo } = req.body;
        const id = await nominaService.guardarHistorial(
            id_usuario,
            datos_entrada,
            resultado_calculo
        );
        res.status(201).json({ id_nomina: id });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.historial = async(req, res) => {
    try {
        const { id_usuario } = req.params;
        const lista = await nominaService.obtenerHistorial(id_usuario);
        res.json(lista);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.eliminar = async(req, res) => {
    try {
        const { id } = req.params;
        const resultado = await nominaService.eliminarHistorial(id);
        res.json({ eliminado: resultado });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};