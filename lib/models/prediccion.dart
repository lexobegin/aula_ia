class Prediccion {
  final double valor;
  final String categoria;
  //final String modelo;

  Prediccion({
    required this.valor,
    required this.categoria,
    //required this.modelo,
  });

  factory Prediccion.fromJson(Map<String, dynamic> json) {
    return Prediccion(
      valor: json['valor_prediccion'].toDouble(),
      categoria: json['categoria'],
      //modelo: json['modelo_utilizado'],
    );
  }
}
