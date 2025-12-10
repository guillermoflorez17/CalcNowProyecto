const DivisasModel = require('../models/divisas.model');

exports.procesarCambio = (cantidad, origen, destino) => {
    const operacion = new DivisasModel(origen, destino, cantidad);
    const resultado = operacion.convertir();

    if (resultado.valido) {
        return {
            success: true,
            resultado: resultado.resultado,
            tasa: resultado.tasa_aplicada
        };
    } else {
        return { success: false, message: "Divisa no soportada" };
    }
};