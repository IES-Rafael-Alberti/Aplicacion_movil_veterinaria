import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Cambia esta URL base según la IP/host de tu backend vet-app
  static const String baseUrl = 'http://localhost:3000';

  // Ejemplo: obtener lista de mascotas
  Future<List<dynamic>> fetchPets() async {
    final response = await http.get(Uri.parse('$baseUrl/pets'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar mascotas');
    }
  }

  // Ejemplo: obtener lista de productos
  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  // Puedes agregar más métodos para adopciones, servicios, etc.
}
