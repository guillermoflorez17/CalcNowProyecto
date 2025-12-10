class NominaModel {
    constructor(brutoAnual, pagas, discapacidad, hijos, edad, grupo) {
        this.salario = parseFloat(brutoAnual);
        this.pagas = parseInt(pagas) || 12;
        this.discapacidad = discapacidad;
        this.hijos = hijos; 
        this.edad = edad;
        this.grupo = grupo;
    }

    _calcularSeguridadSocial() {
        // Tope máximo 2025 (~56.640€) y tasa 6.49%
        const baseCotizacion = Math.min(this.salario, 56640);
        return baseCotizacion * 0.0649;
    }

    _calcularRetencionIRPF(baseImponible) {
        let minimoPersonal = 5550;
        if (this.hijos === "Si" || this.hijos === true) minimoPersonal += 2400;
        if (this.discapacidad === "33%") minimoPersonal += 3000;
        else if (this.discapacidad === "65%" || this.discapacidad === "+65%") minimoPersonal += 9000;

        const getCuota = (base) => {
            if (base <= 0) return 0;
            let cuota = 0;
            if (base > 300000) { cuota += (base - 300000) * 0.47; base = 300000; }
            if (base > 60000)  { cuota += (base - 60000) * 0.45;  base = 60000; }
            if (base > 35200)  { cuota += (base - 35200) * 0.37;  base = 35200; }
            if (base > 20200)  { cuota += (base - 20200) * 0.30;  base = 20200; }
            if (base > 12450)  { cuota += (base - 12450) * 0.24;  base = 12450; }
            if (base > 0)      { cuota += base * 0.19; }
            return cuota;
        };

        const cuotaBase = getCuota(baseImponible);
        const cuotaMinimo = getCuota(minimoPersonal);
        return Math.max(0, cuotaBase - cuotaMinimo);
    }

    obtenerResultados() {
        const seguridadSocial = this._calcularSeguridadSocial();
        const baseImponible = this.salario - seguridadSocial - 2000; 
        const retencion = this._calcularRetencionIRPF(baseImponible);
        const netoAnual = this.salario - seguridadSocial - retencion;

        return {
            bruto_anual: this.salario.toFixed(2),
            neto_anual: netoAnual.toFixed(2),
            neto_mensual: (netoAnual / this.pagas).toFixed(2),
            retencion_anual: retencion.toFixed(2),
            tipo_retencion: (this.salario > 0 ? (retencion / this.salario) * 100 : 0).toFixed(2) + "%",
            seguridad_social: seguridadSocial.toFixed(2),
            num_pagas: this.pagas
        };
    }
}
module.exports = NominaModel;