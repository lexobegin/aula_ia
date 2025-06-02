class Horario {
  final String id;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String materia;
  final String aula;
  final String profesor;

  Horario({
    required this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.materia,
    required this.aula,
    required this.profesor,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['id'].toString(),
      dia: json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      materia: json['gestiongradomateria']['materia']['nombre'],
      aula: json['aula']['codigo'],
      profesor: json['profesor']['usuario']['first_name'],
    );
  }
}
