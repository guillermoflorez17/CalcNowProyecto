import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'refnomina_screen.dart';

class NominaScreen extends StatefulWidget {
  @override
  State<NominaScreen> createState() => _NominaScreenState();
}

class _NominaScreenState extends State<NominaScreen> {
  // CONTROLLERS
  final sueldoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();

  // DROPDOWNS
  String pagasValue = "";
  String contratoValue = "";
  String grupoValue = "";
  String ubicacionValue = "";
  String discapacidadValue = "";
  String civilValue = "";

  // YES/NO
  bool traslado = false;
  bool conyuge = false;
  bool hijos = false;
  bool mayores = false;

  // LISTAS
  final List<String> listaPagas = ["12", "14", "16"];
  final List<String> listaContratos = ["General", "Temporal", "Prácticas"];
  final List<String> listaGrupos = [
    "Ingenieros y Licenciados",
    "Ingenieros Técnicos",
    "Jefes Administrativos",
    "Ayudantes no Titulados",
    "Oficiales Administrativos",
    "Subalternos",
    "Auxiliares Administrativos",
    "Oficiales de primera y segunda",
    "Peones"
  ];

  final List<String> listaComunidades = [
    "Andalucía",
    "Aragón",
    "Asturias",
    "Cantabria",
    "Castilla y León",
    "Castilla-La Mancha",
    "Cataluña",
    "Ceuta",
    "Comunidad Valenciana",
    "Extremadura",
    "Galicia",
    "Islas Baleares",
    "Islas Canarias",
    "La Rioja",
    "Madrid",
    "Melilla",
    "Murcia",
    "Navarra",
    "País Vasco"
  ];

  final List<String> listaDiscapacidad = [
    "Sin discapacidad",
    "33%",
    "65%",
    "+65%"
  ];

  final List<String> listaEstadoCivil = [
    "Soltero",
    "Casado",
    "Divorciado",
    "Viudo"
  ];

  // VALIDACIÓN
  bool _validarCampos() {
    return sueldoCtrl.text.isNotEmpty &&
        edadCtrl.text.isNotEmpty &&
        pagasValue.isNotEmpty &&
        contratoValue.isNotEmpty &&
        grupoValue.isNotEmpty &&
        ubicacionValue.isNotEmpty &&
        discapacidadValue.isNotEmpty &&
        civilValue.isNotEmpty;
  }

  // =================== FUNCIÓN: CALCULAR ===================
  Future<void> calcularNomina() async {
    try {
     final url = Uri.parse("http://127.0.0.1:3000/api/nomina/calcular");


      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "salario_bruto_anual": double.parse(sueldoCtrl.text),
          "pagas": int.parse(pagasValue),
          "edad": int.parse(edadCtrl.text),
          "discapacidad": discapacidadValue,
          "estado_civil": civilValue,
          "hijos": hijos ? "Si" : "No",
          "tipo_contrato": contratoValue,
          "grupo": grupoValue,
          "ubicacion": ubicacionValue,
        }),
      );

      final data = jsonDecode(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RefNominaScreen(
            netoMensual: data["salario_neto_mensual"],
            pagasExtra: (double.parse(data["salario_neto_anual"]) /
                    int.parse(pagasValue))
                .toStringAsFixed(2),
            netoAnual: data["salario_neto_anual"],
            retencionAnual: data["retencion_anual"],
            tipoRetencion: data["tipo_retencion"],
            seguridadSocial: data["seguridad_social"],
          ),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al conectar con el servidor"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Calculadora de nómina",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 50),

                // =================== FORMULARIO ===================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== COLUMNA IZQUIERDA =====
                    SizedBox(
                      width: 420,
                      child: Column(
                        children: [
                          _buildBlock(
                            "Sueldo Bruto Anual",
                            _buildInput(sueldoCtrl, "Ej: 25000"),
                          ),
                          _buildBlock(
                            "Número de Pagas",
                            _buildDropdown(
                              hint: "Seleccione pagas",
                              value: pagasValue,
                              items: listaPagas,
                              onChanged: (v) =>
                                  setState(() => pagasValue = v!),
                            ),
                          ),
                          _buildBlock(
                            "Edad",
                            _buildInput(edadCtrl, "Ej: 25"),
                          ),
                          _buildBlock(
                            "Tipo de contrato",
                            _buildDropdown(
                              hint: "Seleccione contrato",
                              value: contratoValue,
                              items: listaContratos,
                              onChanged: (v) =>
                                  setState(() => contratoValue = v!),
                            ),
                          ),
                          _buildBlock(
                            "Grupo profesional",
                            _buildDropdown(
                              hint: "Seleccione grupo",
                              value: grupoValue,
                              items: listaGrupos,
                              onChanged: (v) =>
                                  setState(() => grupoValue = v!),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 90),

                    // ===== COLUMNA DERECHA =====
                    SizedBox(
                      width: 420,
                      child: Column(
                        children: [
                          _buildBlock(
                            "Ubicación del domicilio fiscal",
                            _buildDropdown(
                              hint: "Seleccione comunidad",
                              value: ubicacionValue,
                              items: listaComunidades,
                              onChanged: (v) =>
                                  setState(() => ubicacionValue = v!),
                            ),
                          ),
                          _buildBlock(
                            "Grado de discapacidad",
                            _buildDropdown(
                              hint: "Seleccione grado",
                              value: discapacidadValue,
                              items: listaDiscapacidad,
                              onChanged: (v) =>
                                  setState(() => discapacidadValue = v!),
                            ),
                          ),
                          _buildBlock(
                            "Estado civil",
                            _buildDropdown(
                              hint: "Seleccione estado civil",
                              value: civilValue,
                              items: listaEstadoCivil,
                              onChanged: (v) =>
                                  setState(() => civilValue = v!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // =================== BOTÓN CALCULAR ===================
                ElevatedButton(
                  onPressed: () {
                    if (_validarCampos()) {
                      calcularNomina();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Debes completar todos los campos"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    "Calcular",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================== WIDGETS REUTILIZABLES ===================
  Widget _buildInput(TextEditingController controller, String placeholder) {
    return SizedBox(
      width: 370,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF46899F), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: 370,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF46899F), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint),
          value: value.isEmpty ? null : value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBlock(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
