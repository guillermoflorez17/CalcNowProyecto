const NominaModel = require('../models/nomina.model');

exports.ejecutarCalculo = (datos) => {
    // 1. Instanciar modelo de dominio
    const nomina = new NominaModel(
        datos.salario_bruto_anual,
        datos.pagas,
        datos.discapacidad,
        datos.hijos,
        datos.edad,
        datos.grupo_profesional
    );
    // 2. Devolver resultados matemáticos
    return nomina.obtenerResultados();
};

exports.guardarHistorial = async (idUsuario, datosEntrada, resultadoCalculo) => {
    // 3. Llamar al método estático del modelo para SQL
    // Preparamos el objeto plano que espera el modelo
    const datosParaGuardar = {
        id_usuario: idUsuario,
        bruto: datosEntrada.salario_bruto_anual,
        pagas: datosEntrada.pagas || 12,
        edad: datosEntrada.edad || 0,
        grupo: datosEntrada.grupo_profesional,
        discapacidad: datosEntrada.discapacidad || 0,
        hijos: datosEntrada.hijos === "Si" ? 1 : 0,
        ss: resultadoCalculo.seguridad_social,
        neto: resultadoCalculo.salario_neto_mensual
    };

    const id = await NominaModel.create(datosParaGuardar);
    return { success: true, id_nomina: id };
};

exports.obtenerHistorial = async (idUsuario) => {
    return await NominaModel.findByUserId(idUsuario);
};

exports.eliminarHistorial = async (id) => {
    return await NominaModel.delete(id);
};