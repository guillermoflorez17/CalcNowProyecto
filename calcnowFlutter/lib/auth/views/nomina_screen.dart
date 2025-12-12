import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'refnomina_screen.dart';

class NominaScreen extends StatefulWidget {
  const NominaScreen({super.key});

  @override
  State<NominaScreen> createState() => _NominaScreenState();
}

class _NominaScreenState extends State<NominaScreen> {
  // Controllers
  final sueldoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();

  // Estado
  String pagas = "12";
  String contrato = "General";
  String grupo = "Ingenieros y Licenciados";
  String comunidad = "Andalucía";
  String discapacidad = "Sin discapacidad";
  String estadoCivil = "Soltero";

  bool hijos = false;
  bool conyugeRentas = false;
  bool traslado = false;
  bool dependientes = false;

  bool cargando = false;

  Future<void> calcularNomina() async {
    setState(() => cargando = true);

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:3000/api/nomina/calcular"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "salario_bruto_anual": double.parse(sueldoCtrl.text),
          "pagas": int.parse(pagas),
          "edad": int.parse(edadCtrl.text),
          "grupo": grupo,
          "ubicacion": comunidad,
          "discapacidad": discapacidad,
          "estado_civil": estadoCivil,
          "hijos": hijos ? "Si" : "No",
          "conyuge_rentas_altas": conyugeRentas ? "Si" : "No",
          "traslado_trabajo": traslado ? "Si" : "No",
          "dependientes": dependientes ? "Si" : "No",
          "tipo_contrato": contrato,
        }),
      );

      final data = jsonDecode(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RefNominaScreen(
            netoMensual: data["salario_neto_mensual"],
            pagasExtra:
                (double.parse(data["salario_neto_anual"]) / int.parse(pagas))
                    .toStringAsFixed(2),
            netoAnual: data["salario_neto_anual"],
            retencionAnual: data["retencion_anual"],
            tipoRetencion: "15%",
            seguridadSocial: data["seguridad_social"],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al calcular la nómina"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Text(
                "Calculadora de nómina",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 40),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- IZQUIERDA ----------------
                  Expanded(
                    child: Column(
                      children: [
                        campo("Sueldo Bruto Anual", sueldoCtrl),
                        campo("Número de Pagas Anuales",
                            TextEditingController(text: pagas),
                            enabled: false),
                        campo("Edad", edadCtrl),
                        campo("Tipo de contrato",
                            TextEditingController(text: contrato),
                            enabled: false),
                        campo("Grupo Profesional",
                            TextEditingController(text: grupo),
                            enabled: false),
                        botonesSiNo("¿Estás trasladado por trabajo?",
                            traslado, (v) => setState(() => traslado = v)),
                      ],
                    ),
                  ),

                  const SizedBox(width: 80),

                  // ---------------- DERECHA ----------------
                  Expanded(
                    child: Column(
                      children: [
                        campo("Ubicación del Domicilio Fiscal",
                            TextEditingController(text: comunidad),
                            enabled: false),
                        campo("Grado de Discapacidad",
                            TextEditingController(text: discapacidad),
                            enabled: false),
                        campo("Estado Civil",
                            TextEditingController(text: estadoCivil),
                            enabled: false),
                        botonesSiNo(
                            "¿Tu cónyuge tiene rentas > 1500€?",
                            conyugeRentas,
                            (v) => setState(() => conyugeRentas = v)),
                        botonesSiNo("¿Tienes hijos?", hijos,
                            (v) => setState(() => hijos = v)),
                        botonesSiNo(
                            "¿Personas a tu cargo?",
                            dependientes,
                            (v) => setState(() => dependientes = v)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: cargando ? null : calcularNomina,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077CC),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Calcular",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 30),

              const Text(
                "CALCNOW",
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget campo(String label, TextEditingController ctrl,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget botonesSiNo(
      String texto, bool valor, Function(bool) onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              boton("Sí", valor, () => onChange(true)),
              const SizedBox(width: 12),
              boton("No", !valor, () => onChange(false)),
            ],
          )
        ],
      ),
    );
  }

  Widget boton(String texto, bool activo, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: activo ? const Color(0xFF0077CC) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          texto,
          style: TextStyle(
              color: activo ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
