const NominaModel = require('../models/nomina.model');

// Calculo basico de nomina. Sustituye por reglas reales cuando se definan.
exports.ejecutarCalculo = (entrada) => {
    const brutoAnual = Number(entrada.salario_bruto_anual ?? entrada.sueldo_bruto_anual ?? 0);
    const pagas = Number(entrada.pagas ?? entrada.pagas_anuales ?? 12);

    if (!brutoAnual || brutoAnual <= 0 || !pagas || pagas <= 0) {
        throw new Error("Datos de salario/pagas invalidos");
    }

    const brutoMensual = brutoAnual / pagas;
    const seguridadSocial = brutoMensual * 0.0635; // aproximacion
    const irpf = brutoMensual * 0.15; // aproximacion
    const netoMensual = brutoMensual - seguridadSocial - irpf;

    return {
        salario_bruto_mensual: Number(brutoMensual.toFixed(2)),
        seguridad_social: Number(seguridadSocial.toFixed(2)),
        irpf: Number(irpf.toFixed(2)),
        salario_neto_mensual: Number(netoMensual.toFixed(2)),
    };
};

exports.guardarDirecto = async(entrada, resultado) => {
    if (!entrada.id_usuario) {
        throw new Error("id_usuario es obligatorio para guardar la nomina");
    }

    const datosParaGuardar = {
        sueldo_bruto_anual: entrada.salario_bruto_anual,
        pagas_anuales: entrada.pagas,
        edad: entrada.edad,
        ubicacion_fiscal: entrada.ubicacion,
        grupo_profesional: entrada.grupo,
        grado_discapacidad: entrada.discapacidad === "33% o mas" ? 33 : entrada.discapacidad === "65% o mas" ? 65 : 0,
        estado_civil: entrada.estado_civil,
        hijos: entrada.hijos === "Si" ? 1 : 0,
        dependientes: entrada.dependientes === "Si" ? 1 : 0,
        traslado_trabajo: entrada.traslado_trabajo === "Si" ? 1 : 0,
        conyuge_rentas_altas: entrada.conyuge_rentas_altas === "Si" ? 1 : 0,
        cuota_seguridad_social: resultado.seguridad_social,
        sueldo_neto_mensual: resultado.salario_neto_mensual,
        id_usuario: entrada.id_usuario
    };

    return await NominaModel.create(datosParaGuardar);
};

exports.historial = async(idUsuario) => {
    return await NominaModel.findByUserId(idUsuario);
};

exports.eliminar = async(id) => {
    return await NominaModel.delete(id);
};
