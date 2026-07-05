import 'package:flutter/foundation.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

enum StatusFilter { all, alive, dead, unknown }

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;

  List<CharacterModel> _characters = [];
  bool isLoading = false;
  bool isSyncing = false;
  String? errorMessage;
  String searchQuery = '';
  StatusFilter statusFilter = StatusFilter.all;

  List<CharacterModel> get characters {
    return _characters.where((character) {
      final matchesQuery = character.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = switch (statusFilter) {
        StatusFilter.all => true,
        StatusFilter.alive => character.status.toLowerCase() == 'alive',
        StatusFilter.dead => character.status.toLowerCase() == 'dead',
        StatusFilter.unknown => character.status.toLowerCase() == 'unknown',
      };
      return matchesQuery && matchesStatus;
    }).toList();
  }

  Future<void> init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final existingCount = await _databaseService.countCharacters();
      if (existingCount == 0) {
        final seedCharacters = await _apiService.fetchSeedCharacters();
        for (final character in seedCharacters) {
          await _databaseService.insertCharacter(character);
        }
      }
      await _loadFromDatabase();
    } catch (error) {
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromDatabase() async {
    _characters = await _databaseService.getAllCharacters();
  }

  Future<void> refreshFromApi() async {
    isSyncing = true;
    notifyListeners();

    try {
      final freshCharacters = await _apiService.fetchSeedCharacters();
      final existing = await _databaseService.getAllCharacters();
      final existingApiIds = existing.map((c) => c.apiId).whereType<int>().toSet();

      for (final character in freshCharacters) {
        if (character.apiId != null && !existingApiIds.contains(character.apiId)) {
          await _databaseService.insertCharacter(character);
        }
      }
      await _loadFromDatabase();
    } catch (error) {
      errorMessage = error.toString();
    }

    isSyncing = false;
    notifyListeners();
  }

  Future<void> addCharacter(CharacterModel character) async {
    await _databaseService.insertCharacter(character);
    await _loadFromDatabase();
    notifyListeners();
  }

  Future<void> updateCharacter(CharacterModel character) async {
    await _databaseService.updateCharacter(character);
    await _loadFromDatabase();
    notifyListeners();
  }

  Future<void> deleteCharacter(int id) async {
    await _databaseService.deleteCharacter(id);
    await _loadFromDatabase();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateStatusFilter(StatusFilter filter) {
    statusFilter = filter;
    notifyListeners();
  }
}
