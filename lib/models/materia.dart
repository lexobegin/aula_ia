class Materia {
  final String nombre;
  final String nivel;
  final String descripcion;

  Materia(
      {required this.nombre, required this.nivel, required this.descripcion});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      nombre: json['nombre'],
      nivel: json['nivel'],
      descripcion: json['descripcion'],
    );
  }
}
