import 'package:flutter/material.dart';

// --- CLASE MODELO (Datos de la moneda) ---
class Currency {
  final String code; // Ej: EUR
  final String name; // Ej: Euro
  final double rate; // Tasa de cambio respecto al Euro (Base 1.0)

  Currency({required this.code, required this.name, required this.rate});
}

// --- PANTALLA PRINCIPAL ---
class DivisasScreen extends StatefulWidget {
  const DivisasScreen({Key? key}) : super(key: key);

  @override
  _DivisasScreenState createState() => _DivisasScreenState();
}

class _DivisasScreenState extends State<DivisasScreen> {
  
  // -----------------------------------------------------------
  // LISTA DE DIVISAS "HARDCODEADA" (EN DURO)
  // Aquí están los datos fijos. No se necesita base de datos.
  // Base: 1 EURO. Fecha referencia: Octubre 2023 (aprox)
  // -----------------------------------------------------------
  final List<Currency> _staticCurrencies = [
    Currency(code: 'EUR', name: 'Euro', rate: 1.0000),
    Currency(code: 'USD', name: 'Dólar Estadounidense', rate: 1.0540),
    Currency(code: 'GBP', name: 'Libra Esterlina', rate: 0.8320),
    Currency(code: 'JPY', name: 'Yen Japonés', rate: 163.5000),
    Currency(code: 'CHF', name: 'Franco Suizo', rate: 0.9350),
    Currency(code: 'CAD', name: 'Dólar Canadiense', rate: 1.4800),
    Currency(code: 'AUD', name: 'Dólar Australiano', rate: 1.6200),
    Currency(code: 'CNY', name: 'Yuan Chino', rate: 7.6300),
    Currency(code: 'MXN', name: 'Peso Mexicano', rate: 21.5000),
    Currency(code: 'COP', name: 'Peso Colombiano', rate: 4650.0000),
    Currency(code: 'ARS', name: 'Peso Argentino', rate: 1050.0000),
    Currency(code: 'BRL', name: 'Real Brasileño', rate: 6.1000),
    Currency(code: 'KRW', name: 'Won Surcoreano', rate: 1475.0000),
    Currency(code: 'INR', name: 'Rupia India', rate: 89.2000),
    Currency(code: 'SEK', name: 'Corona Sueca', rate: 11.5500),
  ];

  // Controladores y variables de estado
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  // Variables para guardar la selección
  late Currency _fromCurrency;
  late Currency _toCurrency;

  @override
  void initState() {
    super.initState();
    // Inicializamos con valores por defecto al arrancar
    _fromCurrency = _staticCurrencies[0]; // EUR
    _toCurrency = _staticCurrencies[1];   // USD
  }

  // -----------------------------------------------------------
  // LÓGICA DE LA OPERACIÓN (Matemáticas)
  // -----------------------------------------------------------
  void _calculate() {
    if (_amountController.text.isEmpty) {
      _resultController.text = "";
      return;
    }

    // 1. Obtenemos el número escrito
    // Usamos tryParse para evitar errores si escriben letras
    double amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    
    // 2. Fórmula de conversión (Cruce de tasas)
    // Resultado = (Cantidad / TasaOrigen) * TasaDestino
    // Ejemplo: 10 USD a GBP -> (10 / 1.054) * 0.832
    double result = (amount / _fromCurrency.rate) * _toCurrency.rate;

    // 3. Mostramos el resultado con 2 decimales
    setState(() {
      _resultController.text = "${result.toStringAsFixed(2)} ${_toCurrency.code}";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Estilos y Colores
    // Color principal sacado de tu Main (Azul CalcNow)
    final Color primaryColor = const Color(0xFF46899F); 

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Divisas',),
        backgroundColor: primaryColor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- TARJETA PRINCIPAL (ENTRADAS) ---
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // INPUT DE IMPORTE
                    SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on_outlined, color: primaryColor),
                        hintText: "0.00",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                      onChanged: (val) => _calculate(), // Calcula automáticamente al escribir
                    ),
                    
                    SizedBox(height: 25),

                    // FILA DE SELECTORES (DESDE -> A)
                    Row(
                      children: [
                        // COLUMNA IZQUIERDA (DESDE)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              _buildStaticDropdown(
                                value: _fromCurrency, 
                                onChanged: (Currency? newVal) {
                                  setState(() {
                                    _fromCurrency = newVal!;
                                    _calculate();
                                  });
                                }
                              ),
                            ],
                          ),
                        ),

                        // ICONO CENTRAL DE INTERCAMBIO
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        ),

                        // COLUMNA DERECHA (A)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              _buildStaticDropdown(
                                value: _toCurrency, 
                                onChanged: (Currency? newVal) {
                                  setState(() {
                                    _toCurrency = newVal!;
                                    _calculate();
                                  });
                                }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // --- SECCIÓN DE RESULTADO ---
            SizedBox(height: 10),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFEEF3F8), // Tu color de fondo claro
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]
              ),
              child: Column(
                children: [
                  Text(
                    _resultController.text.isEmpty ? "0.00" : _resultController.text,
                    
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${_toCurrency.name}",
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // --- BOTÓN CALCULAR (Opcional, pero bueno para UX) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: Text("CALCULAR AHORA", 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET PERSONALIZADO PARA EL DROPDOWN (Más limpio)
  Widget _buildStaticDropdown({required Currency value, required Function(Currency?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Currency>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          // Mapeamos la lista estática _staticCurrencies
          items: _staticCurrencies.map((Currency c) {
            return DropdownMenuItem<Currency>(
              value: c,
              child: Text(
                c.code, // Mostramos solo el código (EUR, USD) para que quepa bien
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}