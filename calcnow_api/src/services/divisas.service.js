class DivisaService {
    static convertirMoneda(cantidad, origen, destino) {
        const valor = parseFloat(cantidad);

        // Aquí podrías conectar una API externa en el futuro sin tocar el controlador
        const tasas = {
            "EUR": { "USD": 1.08, "GBP": 0.85, "EUR": 1 },
            "USD": { "EUR": 0.93, "GBP": 0.79, "USD": 1 },
            "GBP": { "EUR": 1.17, "USD": 1.26, "GBP": 1 }
        };

        if (tasas[origen] && tasas[origen][destino]) {
            const tasa = tasas[origen][destino];
            return {
                success: true,
                resultado: (valor * tasa).toFixed(2),
                tasa_aplicada: tasa
            };
        } else {
            return { success: false };
        }
    }
}

module.exports = DivisaService;