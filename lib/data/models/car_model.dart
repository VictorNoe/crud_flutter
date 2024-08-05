class CarModel {
  final int? id;
  final String marca;
  final String modelo;
  final String velocidadMaxima;
  final String autonomia;

  CarModel({
    this.id,
    required this.marca,
    required this.modelo,
    required this.velocidadMaxima,
    required this.autonomia
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      velocidadMaxima: json['velocidadMaxima'],
      autonomia: json['autonomia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'velocidadMaxima': velocidadMaxima,
      'autonomia': autonomia,
    };
  }
}
