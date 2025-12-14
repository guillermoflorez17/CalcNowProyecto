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
  const DivisasScreen({super.key});

  @override
  _DivisasScreenState createState() => _DivisasScreenState();
}

class _DivisasScreenState extends State<DivisasScreen> {
  // Lista estática de divisas (base EUR)
  final List<Currency> _staticCurrencies = [
    Currency(code: 'EUR', name: 'Euro', rate: 1.0000),
    Currency(code: 'USD', name: 'Dólar estadounidense', rate: 1.0540),
    Currency(code: 'GBP', name: 'Libra esterlina', rate: 0.8320),
    Currency(code: 'JPY', name: 'Yen japonés', rate: 163.5000),
    Currency(code: 'CHF', name: 'Franco suizo', rate: 0.9350),
    Currency(code: 'CAD', name: 'Dólar canadiense', rate: 1.4800),
    Currency(code: 'AUD', name: 'Dólar australiano', rate: 1.6200),
    Currency(code: 'CNY', name: 'Yuan chino', rate: 7.6300),
    Currency(code: 'MXN', name: 'Peso mexicano', rate: 21.5000),
    Currency(code: 'COP', name: 'Peso colombiano', rate: 4650.0000),
    Currency(code: 'ARS', name: 'Peso argentino', rate: 1050.0000),
    Currency(code: 'BRL', name: 'Real brasileño', rate: 6.1000),
    Currency(code: 'KRW', name: 'Won surcoreano', rate: 1475.0000),
    Currency(code: 'INR', name: 'Rupia india', rate: 89.2000),
    Currency(code: 'SEK', name: 'Corona sueca', rate: 11.5500),
  ];

  // Controladores
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  late Currency _fromCurrency;
  late Currency _toCurrency;

  @override
  void initState() {
    super.initState();
    _fromCurrency = _staticCurrencies.firstWhere((c) => c.code == 'USD',
        orElse: () => _staticCurrencies[0]);
    _toCurrency = _staticCurrencies.firstWhere((c) => c.code == 'EUR',
        orElse: () => _staticCurrencies[0]);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _resultController.text = "";
      });
      return;
    }

    final double amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    final double result =
        (amount / _fromCurrency.rate) * _toCurrency.rate; // cruce de tasas

    setState(() {
      _resultController.text = result.toStringAsFixed(2);
    });
  }

  // Emoji de bandera para algunas monedas (para acercarnos al mockup)
  String _currencyFlag(String code) {
    switch (code) {
      case 'USD':
        return '🇺🇸';
      case 'EUR':
        return '🇪🇺';
      case 'GBP':
        return '🇬🇧';
      case 'JPY':
        return '🇯🇵';
      case 'MXN':
        return '🇲🇽';
      case 'COP':
        return '🇨🇴';
      case 'ARS':
        return '🇦🇷';
      case 'BRL':
        return '🇧🇷';
      case 'CAD':
        return '🇨🇦';
      case 'AUD':
        return '🇦🇺';
      case 'CNY':
        return '🇨🇳';
      case 'CHF':
        return '🇨🇭';
      case 'KRW':
        return '🇰🇷';
      case 'INR':
        return '🇮🇳';
      case 'SEK':
        return '🇸🇪';
      default:
        return '🌍';
    }
  }

  // Campo tipo "pastilla" (se usa para Importe y Conversión)
  Widget _pillTextField({
    required TextEditingController controller,
    bool readOnly = false,
    String? hint,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: Colors.black, width: 1.8),
        ),
      ),
    );
  }

  // Tarjeta tipo dropdown para "Desde" y "A"
  Widget _currencyCard({
    required String title,
    required Currency selected,
    required void Function(Currency?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Currency>(
              value: selected,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _staticCurrencies.map((c) {
                return DropdownMenuItem<Currency>(
                  value: c,
                  child: Row(
                    children: [
                      Text(
                        _currencyFlag(c.code),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF46899F);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fila superior: título + icono home
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Para equilibrar con el icono de la derecha
                  const Text(
                    'Cambio divisas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.home_outlined, size: 26),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Importe
              const Text(
                'Importe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _pillTextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hint: '0.00',
                onChanged: (_) => _calculate(),
              ),

              const SizedBox(height: 40),

              // Fila de "Desde" - icono intercambio - "A"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _currencyCard(
                      title: 'Desde',
                      selected: _fromCurrency,
                      onChanged: (Currency? newVal) {
                        if (newVal == null) return;
                        setState(() {
                          _fromCurrency = newVal;
                        });
                        _calculate();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.swap_horiz, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _currencyCard(
                      title: 'A',
                      selected: _toCurrency,
                      onChanged: (Currency? newVal) {
                        if (newVal == null) return;
                        setState(() {
                          _toCurrency = newVal;
                        });
                        _calculate();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Conversión
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Conversión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _pillTextField(
                controller: _resultController,
                readOnly: true,
                hint: '0.00',
              ),

              const SizedBox(height: 32),

              

              // Logo CALCNOW + casita abajo
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'CALC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'NOW',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 1.6),
                      ),
                      child: Icon(
                        Icons.home_outlined,
                        size: 18,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
