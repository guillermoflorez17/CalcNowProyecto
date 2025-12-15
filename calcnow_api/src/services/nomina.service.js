exports.guardarDirecto = async(entrada, resultado) => {

    if (!entrada.id_usuario) {
        throw new Error("id_usuario es obligatorio para guardar la nómina");
    }

    const datosParaGuardar = {
        sueldo_bruto_anual: entrada.salario_bruto_anual,
        pagas_anuales: entrada.pagas,
        edad: entrada.edad,
        ubicacion_fiscal: entrada.ubicacion,
        grupo_profesional: entrada.grupo,

        grado_discapacidad: entrada.discapacidad === "33% o más" ? 33 : entrada.discapacidad === "65% o más" ? 65 : 0,

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