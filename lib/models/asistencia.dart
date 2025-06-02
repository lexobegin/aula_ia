class Asistencia {
  final String id;
  final String fecha;
  final String estado; // 'PRESENTE', 'AUSENTE', 'TARDANZA'
  final String? justificacion;

  Asistencia({
    required this.id,
    required this.fecha,
    required this.estado,
    this.justificacion,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json['id'].toString(),
      fecha: json['fecha'],
      estado: json['estado'],
      justificacion: json['justificacion'],
    );
  }
}
