class NominaModel {
    constructor(brutoAnual, pagas, discapacidad, hijos, edad, grupo) {
        this.salario = parseFloat(brutoAnual);
        this.pagas = parseInt(pagas) || 12;
        this.discapacidad = discapacidad;
        this.hijos = hijos === "Si";
        this.edad = parseInt(edad);
        this.grupo = grupo;
    }


    //SEGURIDAD SOCIAL REAL 2025

    _calcularSeguridadSocial() {

        // Bases mínimas/máximas 2025 (GENERALES)
        const baseMin = 1260; // €/mes
        const baseMax = 4720; // €/mes

        // % trabajador 2025
        const contingenciasComunes = 4.70 / 100;
        const desempleo = 1.55 / 100;
        const formacion = 0.10 / 100;
        const fogasa = 0.00;

        const tipoTotal = contingenciasComunes + desempleo + formacion + fogasa;

        // Salario mensual para calcular base
        const salarioMensual = this.salario / 12;

        // Base aplicable
        const baseCotMensual = Math.min(Math.max(salarioMensual, baseMin), baseMax);

        // Cálculo anual
        return baseCotMensual * tipoTotal * 12;
    }


    //MÍNIMOS PERSONALES Y FAMILIARES (IRPF)

    _calcularMinimosIRPF() {
        let minimo = 5550;

        // Edad
        if (this.edad >= 65) minimo += 1150;
        if (this.edad >= 75) minimo += 1400;

        // Hijos
        if (this.hijos) {

            minimo += 2400;
        }

        // Discapacidad del contribuyente
        if (this.discapacidad === "33%") minimo += 3000;
        if (this.discapacidad === "65%" || this.discapacidad === "+65%") minimo += 9000;

        return minimo;
    }


    //  TARIFA IRPF ESTATAL + AUTONÓMICA 2025

    _tarifaIRPF(base) {
        let cuota = 0;

        const tramos = [
            { hasta: 12450, tipo: 0.19 },
            { hasta: 20200, tipo: 0.24 },
            { hasta: 35200, tipo: 0.30 },
            { hasta: 60000, tipo: 0.37 },
            { hasta: 300000, tipo: 0.45 },
            { hasta: Infinity, tipo: 0.47 },
        ];

        let restante = base;

        for (let tramo of tramos) {
            if (restante <= 0) break;

            const cantidad = Math.min(restante, tramo.hasta - (tramo.prevHasta || 0));
            cuota += cantidad * tramo.tipo;

            tramo.prevHasta = tramo.hasta;
            restante -= cantidad;
        }

        return cuota;
    }


    //CÁLCULO IRPF REAL

    _calcularIRPF(baseImponible) {
        const minimo = this._calcularMinimosIRPF();

        const cuotaTotal = this._tarifaIRPF(baseImponible);
        const cuotaMinimo = this._tarifaIRPF(minimo);

        return Math.max(0, cuotaTotal - cuotaMinimo);
    }

    // RESULTADOS FINALES

    obtenerResultados() {
        // Seguridad Social REAL
        const seguridadSocial = this._calcularSeguridadSocial();

        // Base IRPF
        const baseImponible = this.salario - seguridadSocial - 2000; // reducción general

        // IRPF anual
        const irpf = this._calcularIRPF(baseImponible);

        // Neto anual
        const netoAnual = this.salario - seguridadSocial - irpf;

        // Neto mensual según nº pagas
        const netoMensual = netoAnual / this.pagas;

        return {
            salario_bruto_anual: this.salario.toFixed(2),
            salario_neto_anual: netoAnual.toFixed(2),
            salario_neto_mensual: netoMensual.toFixed(2),
            retencion_anual: irpf.toFixed(2),
            tipo_retencion: ((irpf / this.salario) * 100).toFixed(2) + "%",
            seguridad_social: seguridadSocial.toFixed(2),
            num_pagas: this.pagas
        };
    }
}

module.exports = NominaModel;