// ----------------------------------------
// Cálculo del IRPF según tramos oficiales
// ----------------------------------------
const calcularTipoIRPF = (baseIRPF, estado_civil, hijos, discapacidad) => {
    let tipo = 0;

    // Tramos oficiales estatales
    if (baseIRPF <= 12450) tipo = 0.19;
    else if (baseIRPF <= 20200) tipo = 0.24;
    else if (baseIRPF <= 35200) tipo = 0.30;
    else if (baseIRPF <= 60000) tipo = 0.37;
    else tipo = 0.45;

    // Ajustes por estado civil
    if (estado_civil === "Casado") tipo -= 0.01;

    // Hijos
    if (hijos === "Si") tipo -= 0.01;

    // Discapacidad
    if (discapacidad === "33%") tipo -= 0.01;
    if (discapacidad === "65%" || discapacidad === "+65%") tipo -= 0.02;

    // Nunca menos del 5%
    if (tipo < 0.05) tipo = 0.05;

    return tipo;
};


// ------------------------------------------------------
// Controlador principal: CALCULAR NÓMINA
// ------------------------------------------------------
exports.calcularNomina = (req, res) => {
    try {
        const {
            salario_bruto_anual,
            pagas,
            discapacidad,
            estado_civil,
            hijos
        } = req.body;

        if (!salario_bruto_anual || !pagas) {
            return res.status(400).json({
                error: "Faltan datos obligatorios"
            });
        }

        const salario = Number(salario_bruto_anual);
        const numPagas = Number(pagas);

        // -------- Seguridad Social (6.35%) ------
        const seguridadSocial = salario * 0.0635;

        // -------- Base IRPF ------
        const baseIRPF = salario - seguridadSocial;

        // -------- Tipo IRPF ------
        const tipoIRPF = calcularTipoIRPF(baseIRPF, estado_civil, hijos, discapacidad);

        // -------- Retenciones ------
        const retencionAnual = baseIRPF * tipoIRPF;

        // -------- Netos ------
        const netoAnual = salario - seguridadSocial - retencionAnual;
        const netoMensual = netoAnual / numPagas;

        return res.json({
            salario_neto_anual: netoAnual.toFixed(2),
            salario_neto_mensual: netoMensual.toFixed(2),
            retencion_anual: retencionAnual.toFixed(2),
            tipo_retencion: (tipoIRPF * 100).toFixed(2) + "%",
            seguridad_social: seguridadSocial.toFixed(2),
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({
            error: "Error en el cálculo de nómina"
        });
    }
};