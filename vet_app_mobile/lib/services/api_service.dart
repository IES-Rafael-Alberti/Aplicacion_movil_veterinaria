import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path) => ApiConfig.baseUri.resolve(path);

  // Ejemplo: obtener lista de mascotas
  Future<List<dynamic>> fetchPets() async {
    final response = await _client
        .get(_buildUri('/pets'), headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar mascotas (${response.statusCode})');
    }
  }

  // Ejemplo: obtener lista de productos
  Future<List<dynamic>> fetchProducts() async {
    final response = await _client
        .get(
          _buildUri('/products'),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar productos (${response.statusCode})');
    }
  }

  // Puedes agregar más métodos para adopciones, servicios, etc.
}
