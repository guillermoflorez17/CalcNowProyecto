const nominaService = require('../services/nomina.service');

exports.calcular = async(req, res) => {
    try {
        const resultado = nominaService.ejecutarCalculo(req.body);

        //  GUARDAR AQUÍ MISMO
        const id = await nominaService.guardarDirecto(
            req.body,
            resultado
        );

        res.status(200).json({
            ...resultado,
            id_nomina: id
        });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};