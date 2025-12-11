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

  // Estado de botones
  String tipoInteres = "fijo"; 
  String estadoInmueble = "nuevo";

  //----------------------------------------------------
  // FUNCIÓN DE CÁLCULO
  //----------------------------------------------------
  void calcularHipoteca() {
    double precio = double.tryParse(precioController.text) ?? 0;
    double ahorro = double.tryParse(ahorroController.text) ?? 0;
    int plazo = int.tryParse(plazoController.text) ?? 0;
    double interes = double.tryParse(interesController.text) ?? 0;

    if (precio <= 0 || plazo <= 0) {
      resultadoController.text = "Datos incompletos";
      return;
    }

    double importeHipoteca = precio - ahorro;
    if (importeHipoteca <= 0) {
      resultadoController.text = "El ahorro supera el precio del inmueble";
      return;
    }

    // Interés mensual
    double interesMensual = interes / 100 / 12;

    int pagos = plazo * 12;

    double cuotaMensual =
        importeHipoteca *
            interesMensual /
            (1 - (1 / pow(1 + interesMensual, pagos)));

    resultadoController.text = "${cuotaMensual.toStringAsFixed(2)} € / mes";
  }

  //----------------------------------------------------
  // BORRAR DATOS
  //----------------------------------------------------
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

  //----------------------------------------------------
  // WIDGET PRINCIPAL
  //----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F0F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------------------------------------------------------
              // TÍTULO
              //------------------------------------------------------------------
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

              //------------------------------------------------------------------
              // PRECIO DEL INMUEBLE
              //------------------------------------------------------------------
              campoTitulo("Precio del inmueble"),
              campoTexto(precioController, hint: "Ej: 250000", sufijo: "€"),
              const SizedBox(height: 25),
              campoDescripcion("Calcular qué precio te puedes permitir"),

              //------------------------------------------------------------------
              // AHORRO
              //------------------------------------------------------------------
              const SizedBox(height: 30),
              campoTitulo("Ahorro aportado"),
              campoTexto(ahorroController, hint: "Ej: 60000", sufijo: "€"),
              const SizedBox(height: 10),
              campoDescripcion(
                  "El importe de la hipoteca debe ser inferior o igual al precio del inmueble."),
              const SizedBox(height: 30),

              //------------------------------------------------------------------
              // PLAZO
              //------------------------------------------------------------------
              campoTitulo("Plazo en años"),
              campoTexto(plazoController, hint: "Ej: 25"),
              const SizedBox(height: 35),

              //------------------------------------------------------------------
              // TIPO DE INTERÉS
              //------------------------------------------------------------------
              campoTitulo("Tipo de interés"),
              const SizedBox(height: 12),
              Row(
                children: [
                  botonSeleccion("Fijo", tipoInteres == "fijo", () {
                    setState(() => tipoInteres = "fijo");
                  }),
                  const SizedBox(width: 14),
                  botonSeleccion("Variable", tipoInteres == "variable", () {
                    setState(() => tipoInteres = "variable");
                  }),
                  const SizedBox(width: 14),

                  // CAMPO DEL PORCENTAJE CON % FIJO
                  Container(
                    width: 120,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1),
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          "%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              //------------------------------------------------------------------
              // LOCALIZACIÓN
              //------------------------------------------------------------------
              const SizedBox(height: 35),
              campoTitulo("Localización del inmueble"),
              campoTexto(localizacionController,
                  hinIcon: Icons.location_on_outlined, hint: "Ej: Sevilla"),
              const SizedBox(height: 35),

              //------------------------------------------------------------------
              // ESTADO INMUEBLE
              //------------------------------------------------------------------
              campoTitulo("Estado del inmueble"),
              const SizedBox(height: 12),
              Row(
                children: [
                  botonSeleccion("Nuevo", estadoInmueble == "nuevo", () {
                    setState(() => estadoInmueble = "nuevo");
                  }),
                  const SizedBox(width: 14),
                  botonSeleccion("Segunda mano", estadoInmueble == "segunda", () {
                    setState(() => estadoInmueble = "segunda");
                  }),
                ],
              ),

              //------------------------------------------------------------------
              // BOTÓN CALCULAR
              //------------------------------------------------------------------
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
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      "Calcular",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              //------------------------------------------------------------------
              // RESULTADO
              //------------------------------------------------------------------
              const SizedBox(height: 40),
              campoTitulo(
                  "El precio del inmueble (según la forma de pago) es de:"),
              campoTexto(resultadoController, enabled: false),
              const SizedBox(height: 30),

              //------------------------------------------------------------------
              // BOTÓN BORRAR
              //------------------------------------------------------------------
              Center(
                child: SizedBox(
                  width: 320,
                  height: 70,
                  child: OutlinedButton(
                    onPressed: borrarDatos,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      "Borrar todos los datos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),
              Center(
                child: Text(
                  "CALCNOW 🏠",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------
  // WIDGETS REUTILIZABLES
  //----------------------------------------------------

  Widget campoTitulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget campoDescripcion(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 13, color: Colors.black54),
    );
  }

  Widget campoTexto(TextEditingController controller,
      {String? hint, String? sufijo, IconData? hinIcon, bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: sufijo,
        prefixIcon: hinIcon != null ? Icon(hinIcon) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
