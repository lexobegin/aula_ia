class NotaPeriodo {
  final String materia;
  final String periodo;
  final double promedio;
  final int cantidadNotas;

  NotaPeriodo({
    required this.materia,
    required this.periodo,
    required this.promedio,
    required this.cantidadNotas,
  });

  factory NotaPeriodo.fromJson(Map<String, dynamic> json) {
    // Redondear el promedio a 1 decimal
    final promedioRaw = (json['promedio'] ?? 0).toDouble();
    final promedioRedondeado = double.parse(promedioRaw.toStringAsFixed(1));

    return NotaPeriodo(
      materia: json['materia__nombre'] ?? 'Sin nombre', // Manejo de null
      periodo: json['gestionperiodo__periodo__nombre'] ?? 'Sin período',
      promedio: promedioRedondeado, // Usamos el valor redondeado
      cantidadNotas: (json['cantidad'] ?? 0), // Default 0 si es null
    );
  }
}
