import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/character_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  Future<List<CharacterModel>> fetchCharactersPage(int page) async {
    final uri = Uri.parse('${ApiConstants.characters}?page=$page');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final results = decoded['results'] as List<dynamic>;
      return results
          .map((item) => CharacterModel.fromApiJson(item as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 404) {
      return [];
    }

    throw ApiException('No se pudo conectar con la API. Codigo ${response.statusCode}');
  }

  Future<List<CharacterModel>> fetchSeedCharacters() async {
    final List<CharacterModel> collected = [];
    for (var page = 1; page <= ApiConstants.seedPages; page++) {
      final pageResults = await fetchCharactersPage(page);
      if (pageResults.isEmpty) break;
      collected.addAll(pageResults);
    }
    return collected;
  }
}
