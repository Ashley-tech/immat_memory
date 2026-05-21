import '../models/voiture.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE voiture (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        immatriculation VARCHAR(15) NOT NULL UNIQUE,
        marque_modele VARCHAR(60),
        occupants_noms VARCHAR(70),
        details TEXT
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int> createVoiture(Voiture voiture) async {
    final db = await instance.database;

    return await db.insert(
      'voiture',
      voiture.toJson(),
    );
  }

  Future<List<Voiture>> readAllVoitures() async {
    final db = await instance.database;

    final result = await db.query('voiture');

    return result.map((json) => Voiture.fromJson(json)).toList();
  }

  Future<int> updateVoiture(Voiture voiture) async {
    final db = await instance.database;

    return db.update(
      'voiture',
      voiture.toJson(),
      where: 'id = ?',
      whereArgs: [voiture.id],
    );
  }

  Future<int> deleteVoiture(int id) async {
    final db = await instance.database;

    return await db.delete(
      'voiture',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}