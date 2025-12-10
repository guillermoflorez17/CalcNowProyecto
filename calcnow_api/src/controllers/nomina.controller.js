const nominaService = require('../services/nomina.service');

exports.calcularNomina = (req, res) => {
    try {
        console.log("💼 Nómina Request:", req.body);
        
        // Llamamos al método 'ejecutarCalculo' del servicio
        const resultado = nominaService.ejecutarCalculo(req.body);

        return res.json({
            success: true,
            // Mapeamos la respuesta para que tu Flutter la entienda igual que antes
            salario_neto_mensual: resultado.neto_mensual,
            salario_neto_anual: resultado.neto_anual,
            retencion_anual: resultado.retencion_anual,
            tipo_retencion: resultado.tipo_retencion,
            seguridad_social: resultado.seguridad_social,
            pagas: resultado.num_pagas
        });

    } catch (error) {
        console.error("🔥 Error Nómina:", error.message);
        return res.status(400).json({ 
            success: false, 
            error: error.message 
        });
    }
};