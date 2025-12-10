const NominaModel = require('../models/nomina.model');

exports.ejecutarCalculo = (datos) => {
    if (!datos.salario_bruto_anual) throw new Error("El salario bruto es obligatorio");

    const nomina = new NominaModel(
        datos.salario_bruto_anual,
        datos.pagas,
        datos.discapacidad,
        datos.hijos,
        datos.edad,
        datos.grupo_profesional
    );
    return nomina.obtenerResultados();
};