import 'package:flutter/material.dart';
import 'package:aula_ia/models/models.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;

  const MateriaCard({Key? key, required this.materia}) : super(key: key);

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
            Text(
              materia.nombre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (materia.descripcion.isNotEmpty)
              Text(
                materia.descripcion,
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
