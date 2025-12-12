const NominaModel = require('../models/nomina.model');

exports.ejecutarCalculo = (datos) => {
    const nomina = new NominaModel(
        Number(datos.salario_bruto_anual),
        Number(datos.pagas),
        datos.discapacidad,
        datos.hijos,
        Number(datos.edad),
        datos.grupo
    );

    return nomina.obtenerResultados();
};

exports.guardarHistorial = async(idUsuario, entrada, resultado) => {
    const datosParaGuardar = {
        sueldo_bruto_anual: entrada.salario_bruto_anual,
        pagas_anuales: entrada.pagas,
        edad: entrada.edad,
        ubicacion_fiscal: entrada.ubicacion,
        grupo_profesional: entrada.grupo,
        grado_discapacidad: entrada.discapacidad,
        estado_civil: entrada.estado_civil,
        hijos: entrada.hijos === "Si" ? 1 : 0,
        cuota_seguridad_social: resultado.seguridad_social,
        sueldo_neto_mensual: resultado.salario_neto_mensual,
        id_usuario: idUsuario
    };

    return await NominaModel.create(datosParaGuardar);
};

exports.obtenerHistorial = async(idUsuario) => {
    return await NominaModel.findByUserId(idUsuario);
};

exports.eliminarHistorial = async(id) => {
    return await NominaModel.delete(id);
};