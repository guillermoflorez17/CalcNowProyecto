import 'dart:math';
import 'package:flutter/material.dart';

class HipotecaScreen extends StatefulWidget {
  const HipotecaScreen({super.key});

  @override
  State<HipotecaScreen> createState() => _HipotecaScreenState();
}

class _HipotecaScreenState extends State<HipotecaScreen> {
  // Controllers
  final TextEditingController precioController = TextEditingController();
  final TextEditingController ahorroController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController interesController = TextEditingController();
  final TextEditingController localizacionController = TextEditingController();
  final TextEditingController resultadoController = TextEditingController();

  String tipoInteres = "fijo";
  String estadoInmueble = "nuevo";

  // --------------------------------------------------
  // CÁLCULO HIPOTECA
  // --------------------------------------------------
  void calcularHipoteca() {
    final precio = double.tryParse(precioController.text) ?? 0;
    final ahorro = double.tryParse(ahorroController.text) ?? 0;
    final plazo = int.tryParse(plazoController.text) ?? 0;
    final interes = double.tryParse(interesController.text) ?? 0;

    if (precio <= 0 || plazo <= 0 || interes <= 0) {
      resultadoController.text = "Datos incompletos";
      return;
    }

    final importe = precio - ahorro;
    if (importe <= 0) {
      resultadoController.text = "El ahorro supera el precio";
      return;
    }

    final interesMensual = interes / 100 / 12;
    final cuotas = plazo * 12;

    final cuota = importe *
        interesMensual /
        (1 - (1 / pow(1 + interesMensual, cuotas)));

    resultadoController.text = "${cuota.toStringAsFixed(2)} € / mes";
  }

  void borrarDatos() {
    precioController.clear();
    ahorroController.clear();
    plazoController.clear();
    interesController.clear();
    localizacionController.clear();
    resultadoController.clear();

    setState(() {
      tipoInteres = "fijo";
      estadoInmueble = "nuevo";
    });
  }

  // --------------------------------------------------
  // UI
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F0F8),
      body: SafeArea(
        child: Stack(
          children: [
            // -------- CONTENIDO --------
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "CALCULADORA DE HIPOTECAS",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  campoTitulo("Precio del inmueble"),
                  campoTexto(precioController, hint: "Ej: 250000", sufijo: "€"),
                  campoDescripcion("Calcular qué precio te puedes permitir"),
                  const SizedBox(height: 30),

                  campoTitulo("Ahorro aportado"),
                  campoTexto(ahorroController, hint: "Ej: 60000", sufijo: "€"),
                  campoDescripcion(
                      "El importe de la hipoteca debe ser inferior o igual al precio."),
                  const SizedBox(height: 30),

                  campoTitulo("Plazo en años"),
                  campoTexto(plazoController, hint: "Ej: 25"),
                  const SizedBox(height: 35),

                  campoTitulo("Tipo de interés"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      botonSeleccion("Fijo", tipoInteres == "fijo",
                          () => setState(() => tipoInteres = "fijo")),
                      const SizedBox(width: 14),
                      botonSeleccion("Variable", tipoInteres == "variable",
                          () => setState(() => tipoInteres = "variable")),
                      const SizedBox(width: 14),
                      Container(
                        width: 120,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: interesController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "0",
                                ),
                              ),
                            ),
                            const Text(
                              "%",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),
                  campoTitulo("Localización del inmueble"),
                  campoTexto(localizacionController,
                      hinIcon: Icons.location_on_outlined,
                      hint: "Ej: Sevilla"),
                  const SizedBox(height: 35),

                  campoTitulo("Estado del inmueble"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      botonSeleccion("Nuevo", estadoInmueble == "nuevo",
                          () => setState(() => estadoInmueble = "nuevo")),
                      const SizedBox(width: 14),
                      botonSeleccion(
                          "Segunda mano",
                          estadoInmueble == "segunda",
                          () => setState(() => estadoInmueble = "segunda")),
                    ],
                  ),

                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 320,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: calcularHipoteca,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077CC),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        child: const Text(
                          "Calcular",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  campoTitulo(
                      "El precio del inmueble (según la forma de pago) es de:"),
                  campoTexto(resultadoController, enabled: false),
                  const SizedBox(height: 30),

                  Center(
                    child: SizedBox(
                      width: 320,
                      height: 70,
                      child: OutlinedButton(
                        onPressed: borrarDatos,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        child: const Text(
                          "Borrar todos los datos",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                  const Center(
                    child: Text(
                      "CALCNOW 🏠",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // -------- CASITA (SIEMPRE CLICABLE) --------
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.home_outlined,
                      size: 40,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // WIDGETS REUTILIZABLES
  // --------------------------------------------------
  Widget campoTitulo(String texto) =>
      Text(texto, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  Widget campoDescripcion(String texto) =>
      Text(texto, style: const TextStyle(fontSize: 13, color: Colors.black54));

  Widget campoTexto(TextEditingController controller,
      {String? hint,
      String? sufijo,
      IconData? hinIcon,
      bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: sufijo,
        prefixIcon: hinIcon != null ? Icon(hinIcon) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget botonSeleccion(String texto, bool activo, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: activo ? const Color(0xFF0077CC) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          texto,
          style: TextStyle(
              color: activo ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
