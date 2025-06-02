import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/widgets/widgets.dart';

class PrediccionScreen extends StatefulWidget {
  const PrediccionScreen({Key? key}) : super(key: key);

  @override
  State<PrediccionScreen> createState() => _PrediccionScreenState();
}

class _PrediccionScreenState extends State<PrediccionScreen> {
  Prediccion? prediccion;
  bool isLoading = false;
  String error = '';

  Future<void> generarPrediccion() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final nuevaPrediccion = await authService.generarPrediccion();
      setState(() {
        prediccion = nuevaPrediccion;
      });
    } catch (e) {
      setState(() {
        error = 'Error al generar la predicción: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de Rendimiento')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red))
            else if (prediccion != null)
              PrediccionCard(prediccion: prediccion!)
            else
              const Text('Presiona el botón para generar una predicción'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generarPrediccion,
              child: const Text('Generar Predicción'),
            ),
          ],
        ),
      ),
    );
  }
}
