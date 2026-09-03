import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/animal.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  // Ajuste este endereço conforme o ambiente de execução:
  // - Emulador Android: 10.0.2.2 aponta para o localhost da máquina host.
  // - iOS simulator, Web ou Desktop: localhost funciona normalmente.
  // - Dispositivo físico: use o IP da máquina onde o back-end está rodando.
  static String get _host {
    if (kIsWeb) return 'localhost';
    try {
      if (Platform.isAndroid) return '10.0.2.2';
    } catch (_) {
      // Platform indisponível (ex.: testes); usa localhost como padrão.
    }
    return 'localhost';
  }

  static String get baseUrl => 'http://$_host:3000/api';

  Future<List<Animal>> fetchAnimals() async {
    final response = await http.get(Uri.parse('$baseUrl/animals'));
    if (response.statusCode != 200) {
      throw ApiException('Falha ao carregar os animais.');
    }
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => Animal.fromJson(json)).toList();
  }

  Future<Animal> createAnimal(Animal animal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(animal.toJson()),
    );
    if (response.statusCode != 201) {
      throw ApiException(_extractError(response.body, 'Falha ao incluir o animal.'));
    }
    return Animal.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<Animal> updateAnimal(String id, Animal animal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/animals/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(animal.toJson()),
    );
    if (response.statusCode != 200) {
      throw ApiException(_extractError(response.body, 'Falha ao editar o animal.'));
    }
    return Animal.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<void> deleteAnimal(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/animals/$id'));
    if (response.statusCode != 200) {
      throw ApiException('Falha ao excluir o animal.');
    }
  }

  String _extractError(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['errors'] is List) {
        return (decoded['errors'] as List).join('\n');
      }
      if (decoded is Map && decoded['error'] != null) {
        return decoded['error'].toString();
      }
    } catch (_) {
      // Corpo não é um JSON válido; usa a mensagem padrão.
    }
    return fallback;
  }
}
