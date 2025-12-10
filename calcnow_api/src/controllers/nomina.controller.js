const NominaService = require('../services/nomina.service');

exports.calcularNomina = (req, res) => {
    try {
        console.log("💼 Petición de Nómina:", req.body);

        const {
            salario_bruto_anual,
            pagas,
            discapacidad,
            estado_civil,
            hijos,
            edad,
            grupo_profesional
        } = req.body;

        // Validación básica
        if (!salario_bruto_anual || !pagas) {
            return res.status(400).json({
                error: "Faltan datos obligatorios: salario_bruto_anual y pagas"
            });
        }

        // Llamamos al Servicio (Lógica 2025)
        const resultado = NominaService.calcularSalarioNeto(
            salario_bruto_anual,
            pagas,
            edad,
            grupo_profesional,
            discapacidad,
            hijos
        );

        // Devolvemos respuesta a Flutter con las claves que espera tu App
        return res.json({
            success: true,
            // Mapeamos a las variables que usa tu Front (nomina_screen.dart / refnomina_screen.dart)
            salario_neto_anual: resultado.neto_anual,
            salario_neto_mensual: resultado.neto_mensual,
            retencion_anual: resultado.retencion_anual,
            tipo_retencion: resultado.tipo_retencion,
            seguridad_social: resultado.seguridad_social,
            pagas: resultado.num_pagas
        });

    } catch (err) {
        console.error("🔥 Error en nómina:", err);
        return res.status(500).json({
            error: "Error interno en el cálculo de nómina"
        });
    }
};