class DivisasModel {
    constructor(origen, destino, cantidad) {
        this.origen = origen;
        this.destino = destino;
        this.cantidad = parseFloat(cantidad);
        this.tasas = {
            "EUR": { "USD": 1.08, "GBP": 0.85, "EUR": 1 },
            "USD": { "EUR": 0.93, "GBP": 0.79, "USD": 1 },
            "GBP": { "EUR": 1.17, "USD": 1.26, "GBP": 1 }
        };
    }

    convertir() {
        if (this.tasas[this.origen] && this.tasas[this.origen][this.destino]) {
            const tasa = this.tasas[this.origen][this.destino];
            return {
                valido: true,
                resultado: (this.cantidad * tasa).toFixed(2),
                tasa_aplicada: tasa
            };
        }
        return { valido: false };
    }
}
module.exports = DivisasModel;