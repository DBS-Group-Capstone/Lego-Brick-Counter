import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('pieces.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE pieces ( 
        id $idType, 
        size $textType,
        color $intType
      )
    ''');
  }
  
  Future<int> insertPiece(Piece piece) async {
    Database db = await instance.database;
    return await db.insert('pieces', piece.toMap());
  }

  static Future<List<Map<String, dynamic>>> getAllPieces() async {
    Database db = await instance.database;
    return await db.query('pieces');
  } 

  Future<int> updatePiece(Piece piece) async {
    Database db = await instance.database;
    return await db.update(
      'pieces',
      piece.toMap(),
      where: 'id = ?',
      whereArgs: [piece.id],
    );
  }

  Future<int> deletePiece(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'pieces',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // predetermined pieces
  Future<void> insertPredeterminedPieces() async {
    List<Piece> pieces = [
      Piece(id: 3001, size: '2x4 Brick', color: 5), // Red
      Piece(id: 3001, size: '2x4 Brick', color: 6), // Green
      Piece(id: 3001, size: '2x4 Brick', color: 7), // Blue
    ];

    for (var piece in pieces) {
      await insertPiece(piece);
    }
  }
}

class Piece {
  final int id;
  final String size;
  final int color;


  Piece({required this.id, required this.size, required this.color});


  // Convert a Piece into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'size': size, 'color': color};
  }

  factory Piece.fromMap(Map<String, Object?> map) {
    return Piece(
      id: map['id'] as int,
      size: map['size'] as String,
      color: map['color'] as int,
    );
  }
}
