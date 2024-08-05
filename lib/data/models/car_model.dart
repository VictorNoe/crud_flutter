class CarModel {
  final String? id;
  final String marca;
  final String modelo;
  final String VelocidadMaxima;
  final String autonomia;

  CarModel({
    this.id,
    required this.marca,
    required this.modelo,
    required this.VelocidadMaxima,
    required this.autonomia
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      VelocidadMaxima: json['velocidadMaxima'],
      autonomia: json['autonomia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'velocidadMaxima': VelocidadMaxima,
      'autonomia': autonomia,
    };
  }
}