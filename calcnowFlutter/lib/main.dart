import 'package:flutter/material.dart';

// -------------------- VISTAS --------------------
import 'auth/views/login_screen.dart';
import 'auth/views/register_screen.dart';
import 'auth/views/home_screen.dart';

// -------------------- CALCULADORAS --------------------
import 'auth/views/nomina_screen.dart';
import 'auth/views/hipoteca_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalcNowApp());
}

class CalcNowApp extends StatelessWidget {
  const CalcNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalcNow',

      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF46899F),
        scaffoldBackgroundColor: const Color(0xFFEEF3F8),
        fontFamily: 'Poppins',
      ),

      // Pantalla inicial
      home: const HomeScreen(),

      // ---------------- RUTAS ----------------
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),

        // --------- CALCULADORAS ---------
        '/nomina': (context) => NominaScreen(),
        '/hipoteca': (context) => const HipotecaScreen(),
      },
    );
  }
}
