import 'package:flutter/material.dart';
import 'package:aula_ia/models/models.dart';

class PrediccionCard extends StatelessWidget {
  final Prediccion prediccion;

  const PrediccionCard({Key? key, required this.prediccion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (prediccion.categoria) {
        case 'ALTO':
          return Colors.green;
        case 'MEDIO':
          return Colors.orange;
        case 'BAJO':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Rendimiento: ${prediccion.categoria}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: getColor(),
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: prediccion.valor / 100,
              backgroundColor: Colors.grey[200],
              color: getColor(),
            ),
            const SizedBox(height: 10),
            Text('Puntaje: ${prediccion.valor.toStringAsFixed(1)}'),
            //Text('Modelo: ${prediccion.modelo}'),
          ],
        ),
      ),
    );
  }
}
