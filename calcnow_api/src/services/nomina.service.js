class NominaService {
    static calcularSalarioNeto(brutoAnual, numPagas, edad, grupo, discapacidad, hijos) {
        const salario = parseFloat(brutoAnual);
        const pagas = parseInt(numPagas) || 12;

        // ---------------------------------------------------------
        // 1. CÁLCULO SEGURIDAD SOCIAL (A cargo del trabajador)
        // ---------------------------------------------------------
        // Para 2025 estimamos:
        // - Contingencias Comunes: 4.70%
        // - Desempleo: 1.55% (General)
        // - Formación Profesional: 0.10%
        // - MEI (Mecanismo Equidad): ~0.14% (Sube en 2025)
        // TOTAL: ~6.49%
        
        // Tope máximo de cotización 2025 (Estimado ~4720€/mes -> ~56.640€/año)
        // Si gana más de esto, la SS deja de subir.
        const baseCotizacion = Math.min(salario, 56640); 
        const seguridadSocial = baseCotizacion * 0.0649; 

        // ---------------------------------------------------------
        // 2. CÁLCULO IRPF (Método Progresivo de Hacienda)
        // ---------------------------------------------------------
        const baseImponible = salario - seguridadSocial - 2000; // 2000€ de gasto deducible genérico
        
        // Mínimos Personales y Familiares (Lo que está exento de tributar)
        let minimoPersonal = 5550; // Básico

        // Ajuste por Hijos (Si envía "Si", asumimos 1 hijo para el cálculo estándar, 2400€)
        if (hijos === "Si" || hijos === true) {
            minimoPersonal += 2400; 
        }

        // Ajuste por Discapacidad
        if (discapacidad === "33%") minimoPersonal += 3000;
        else if (discapacidad === "65%" || discapacidad === "+65%") minimoPersonal += 9000;

        // Función para calcular cuota según tramos estatales
        const calcularCuota = (base) => {
            if (base <= 0) return 0;
            let cuota = 0;
            // Tramos 2025 (Estatales aproximados)
            if (base > 300000) { cuota += (base - 300000) * 0.47; base = 300000; }
            if (base > 60000)  { cuota += (base - 60000) * 0.45;  base = 60000; }
            if (base > 35200)  { cuota += (base - 35200) * 0.37;  base = 35200; }
            if (base > 20200)  { cuota += (base - 20200) * 0.30;  base = 20200; }
            if (base > 12450)  { cuota += (base - 12450) * 0.24;  base = 12450; }
            if (base > 0)      { cuota += base * 0.19; }
            return cuota;
        };

        // Algoritmo Hacienda: (Cuota sobre Base) - (Cuota sobre Mínimo Personal)
        const cuotaBase = calcularCuota(baseImponible);
        const cuotaMinimo = calcularCuota(minimoPersonal);
        let retencionIRPF = cuotaBase - cuotaMinimo;

        if (retencionIRPF < 0) retencionIRPF = 0;

        // Calcular el % real resultante (Tipo Medio)
        let tipoMedio = (retencionIRPF / salario) * 100;
        
        // Ajuste mínimo del 2% para contratos temporales si fuera el caso, 
        // o 0% si sale negativo.
        if (tipoMedio < 0) tipoMedio = 0;

        // ---------------------------------------------------------
        // 3. RESULTADOS FINALES
        // ---------------------------------------------------------
        const netoAnual = salario - seguridadSocial - retencionIRPF;
        const netoMensual = netoAnual / pagas;

        return {
            bruto_anual: salario.toFixed(2),
            neto_anual: netoAnual.toFixed(2),
            neto_mensual: netoMensual.toFixed(2),
            retencion_anual: retencionIRPF.toFixed(2),
            tipo_retencion: tipoMedio.toFixed(2) + "%",
            seguridad_social: seguridadSocial.toFixed(2),
            num_pagas: pagas
        };
    }
}

module.exports = NominaService;