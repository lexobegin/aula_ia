// models/academic_progress_model.dart
class ProgresoAcademico {
  final List<NotaMateria> notasPorMateria;
  final Map<String, double> promediosGenerales;

  ProgresoAcademico({
    required this.notasPorMateria,
    required this.promediosGenerales,
  });

  factory ProgresoAcademico.fromJson(Map<String, dynamic> json) {
    return ProgresoAcademico(
      notasPorMateria: (json['notas_por_materia'] as List)
          .map((item) => NotaMateria.fromJson(item))
          .toList(),
      promediosGenerales: (json['promedios_generales'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toDouble())),
    );
  }
}

class NotaMateria {
  final String materia;
  final String periodo;
  final double promedio;
  final int cantidadNotas;

  NotaMateria({
    required this.materia,
    required this.periodo,
    required this.promedio,
    required this.cantidadNotas,
  });

  factory NotaMateria.fromJson(Map<String, dynamic> json) {
    return NotaMateria(
      materia: json['materia__nombre'],
      periodo: json['gestionperiodo__periodo__nombre'],
      promedio: json['promedio'].toDouble(),
      cantidadNotas: json['cantidad'],
    );
  }
}
