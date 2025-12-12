const NominaModel = require('../models/nomina.model');

exports.ejecutarCalculo = (datos) => {
    // 1. Instanciar modelo de dominio con nombres CORRECTOS
    const nomina = new NominaModel(
        Number(datos.salario_bruto_anual),
        Number(datos.pagas),
        datos.discapacidad,
        datos.hijos,
        Number(datos.edad),
        datos.grupo // 👈 ANTES estaba mal (grupo_profesional)
    );

    // 2. Obtener resultados matemáticos
    return nomina.obtenerResultados();
};

exports.guardarHistorial = async(idUsuario, datosEntrada, resultadoCalculo) => {
    const datosParaGuardar = {
        id_usuario: idUsuario,
        bruto: datosEntrada.salario_bruto_anual,
        pagas: datosEntrada.pagas || 12,
        edad: datosEntrada.edad || 0,
        grupo: datosEntrada.grupo,
        discapacidad: datosEntrada.discapacidad || "Sin discapacidad",
        hijos: datosEntrada.hijos === "Si" ? 1 : 0,
        ss: resultadoCalculo.seguridad_social,
        neto: resultadoCalculo.salario_neto_mensual
    };

    const id = await NominaModel.create(datosParaGuardar);

    return {
        success: true,
        id_nomina: id
    };
};

exports.obtenerHistorial = async(idUsuario) => {
    return await NominaModel.findByUserId(idUsuario);
};

exports.eliminarHistorial = async(id) => {
    return await NominaModel.delete(id);
};