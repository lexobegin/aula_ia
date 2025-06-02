import 'package:flutter/material.dart';
import 'package:aula_ia/models/models.dart';

class HistorialAsistenciaCard extends StatelessWidget {
  final Asistencia asistencia;

  const HistorialAsistenciaCard({Key? key, required this.asistencia})
      : super(key: key);

  Color _getStatusColor() {
    switch (asistencia.estado) {
      case 'PRESENTE':
        return Colors.green;
      case 'AUSENTE':
        return Colors.red;
      case 'TARDANZA':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asistencia.fecha,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    asistencia.estado,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(),
                ),
              ],
            ),
            if (asistencia.justificacion != null &&
                asistencia.justificacion!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Justificación: ${asistencia.justificacion}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
