class HipotecaService {
    static calcularAmortizacion(monto, tasaAnual, anios) {
        const P = parseFloat(monto);
        const r = (parseFloat(tasaAnual) / 100) / 12; 
        const n = parseFloat(anios) * 12;

        let cuota = 0;
        if (r === 0) {
            cuota = P / n;
        } else {
            const factor = Math.pow(1 + r, n);
            cuota = P * ((r * factor) / (factor - 1));
        }

        const totalPagado = cuota * n;
        
        // Devolvemos un objeto limpio con los resultados
        return {
            cuota_mensual: cuota.toFixed(2),
            total_pagado: totalPagado.toFixed(2),
            total_intereses: (totalPagado - P).toFixed(2)
        };
    }
}

module.exports = HipotecaService;