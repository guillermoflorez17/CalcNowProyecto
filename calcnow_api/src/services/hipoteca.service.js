const HipotecaModel = require('../models/hipoteca.model');

exports.calcularPrestamo = (monto, interes, anios) => {
    if (monto <= 0 || anios <= 0) {
        return { success: false, message: "Valores positivos requeridos" };
    }
    const prestamo = new HipotecaModel(monto, interes, anios);
    const resultado = prestamo.calcularTabla();
    return { success: true, data: resultado };
};