import 'package:flutter/material.dart';

class RefNominaScreen extends StatelessWidget {
  final String netoMensual;
  final String pagasExtra;
  final String netoAnual;
  final String retencionAnual;
  final String tipoRetencion;
  final String seguridadSocial;

  const RefNominaScreen({
    super.key,
    required this.netoMensual,
    required this.pagasExtra,
    required this.netoAnual,
    required this.retencionAnual,
    required this.tipoRetencion,
    required this.seguridadSocial,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------- ICONO HOME ----------------
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: const Icon(
                  Icons.home_outlined,
                  size: 40,
                  color: Colors.black87,
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      "Resultado de la nómina",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------- IZQUIERDA -------------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title("Tu sueldo mensual neto sería de"),
                            _resultBox(netoMensual),
                            const SizedBox(height: 40),

                            _title("Tendrías 2 pagas extra de"),
                            _resultBox(pagasExtra),
                            const SizedBox(height: 40),

                            _title("Equivalente a un sueldo anual neto de"),
                            _resultBox(netoAnual),
                          ],
                        ),

                        const SizedBox(width: 80),

                        // ------------------- DERECHA -------------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title("Retención de IRPF anual"),
                            _resultBox(retencionAnual),
                            const SizedBox(height: 40),

                            _title("Tipo de retención"),
                            _resultBox(tipoRetencion),
                            const SizedBox(height: 40),

                            _title("Cuotas de la Seguridad\nSocial al año"),
                            _resultBox(seguridadSocial),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // ---------------- BOTÓN REPETIR ----------------
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, "/nomina"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF187BCD),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Repetir cálculo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "CALCNOW",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _resultBox(String value) {
    return Container(
      width: 300,
      height: 55,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}
