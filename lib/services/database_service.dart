import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/character_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'rickmorty_crud.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE characters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            apiId INTEGER,
            name TEXT NOT NULL,
            status TEXT NOT NULL,
            species TEXT NOT NULL,
            gender TEXT NOT NULL,
            origin TEXT NOT NULL,
            imageUrl TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertCharacter(CharacterModel character) async {
    final db = await database;
    final map = character.toMap();
    map.remove('id');
    return db.insert('characters', map);
  }

  Future<List<CharacterModel>> getAllCharacters() async {
    final db = await database;
    final result = await db.query('characters', orderBy: 'id DESC');
    return result.map((row) => CharacterModel.fromMap(row)).toList();
  }

  Future<int> updateCharacter(CharacterModel character) async {
    final db = await database;
    return db.update(
      'characters',
      character.toMap(),
      where: 'id = ?',
      whereArgs: [character.id],
    );
  }

  Future<int> deleteCharacter(int id) async {
    final db = await database;
    return db.delete('characters', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countCharacters() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM characters');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
