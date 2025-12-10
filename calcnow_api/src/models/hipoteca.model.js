class HipotecaModel {
    constructor(monto, tasaAnual, anios) {
        this.P = parseFloat(monto);
        this.r = (parseFloat(tasaAnual) / 100) / 12; 
        this.n = parseFloat(anios) * 12;             
    }

    calcularTabla() {
        let cuota = 0;
        if (this.r === 0) {
            cuota = this.P / this.n;
        } else {
            const factor = Math.pow(1 + this.r, this.n);
            cuota = this.P * ((this.r * factor) / (factor - 1));
        }
        const totalPagado = cuota * this.n;
        return {
            cuota_mensual: cuota.toFixed(2),
            total_pagado: totalPagado.toFixed(2),
            total_intereses: (totalPagado - this.P).toFixed(2)
        };
    }
}
module.exports = HipotecaModel;