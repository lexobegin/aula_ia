import 'package:flutter/material.dart';
import 'package:aula_ia/models/models.dart';

class HorarioCard extends StatelessWidget {
  final Horario horario;

  const HorarioCard({Key? key, required this.horario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  horario.materia,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${horario.horaInicio} - ${horario.horaFin}',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Día: ${horario.dia}'),
            Text('Aula: ${horario.aula}'),
            Text('Profesor: ${horario.profesor}'),
          ],
        ),
      ),
    );
  }
}
