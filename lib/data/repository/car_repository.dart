import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String apiUrl;

  CarRepository({required this.apiUrl});

  Future<void> createCar(CarModel car) async {
    final response = await http.post(
      Uri.parse('https://atgh8nbpvf.execute-api.us-east-1.amazonaws.com/Prod/insert_data_vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(car.toJson()..remove('id')),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create car');
    }
  }

  Future<CarModel> getCar(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/car/$id'),
      headers: <String, String>{
        //'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return CarModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load car');
    }
  }

  Future<void> updateCar(CarModel car) async {
    final response = await http.put(
      Uri.parse('https://atgh8nbpvf.execute-api.us-east-1.amazonaws.com/Prod/update_data_vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(String id) async {
    final response = await http.delete(
      Uri.parse('https://atgh8nbpvf.execute-api.us-east-1.amazonaws.com/Prod/delete_data_vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }
  }

  Future<List<CarModel>> getAllCar() async {
    final response = await http.get(
      Uri.parse('https://atgh8nbpvf.execute-api.us-east-1.amazonaws.com/Prod/get_all_data_vehicle'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<CarModel>.from(l.map((model) => CarModel.fromJson(model)));
    } else {
      throw Exception('Failed to load car');
    }
  }
}
