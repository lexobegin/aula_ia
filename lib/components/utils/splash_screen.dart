import 'package:flutter/material.dart';
import 'package:aula_ia/screens/login/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var d = const Duration(seconds: 2);

    Future.delayed(d, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
        (route) => false,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo liso
          Container(
            color: const Color.fromARGB(
                255, 229, 231, 240), // Puedes cambiar el color si lo deseas
          ),
          // Imagen central
          Center(
            child: Image.asset(
              'assets/utils/splash2.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
