import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'brick.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lego.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE bricks( id INTEGER PRIMARY KEY AUTOINCREMENT, color TEXT NOT NULL, size TEXT NOT NULL, type TEXT NOT NULL, quantity INTEGER NOT NULL )');
  }

  Future<int> insertBrick(Brick brick) async {
    final db = await instance.database;
    return await db.insert('bricks', brick.toMap());
  }

  // Inserts a brick if one with the same fields (other than ID and count) are not there,
  //   but adds to the count if one with those fields are there
  Future<int> insertBrickAccumulate(Brick brick) async {
    final db = await instance.database;
    var q = await db.query(
      "bricks",
      columns: ["id"],
      where: "color = ? AND size = ? AND type = ?",
      whereArgs: [brick.color, brick.size, brick.type]
    );
    // This sql implementation starts auto index at 1
    int id = 0;
    int count = brick.quantity;
    if(q.isNotEmpty) {
      brick.id = (q.first["id"] as num).round();
    }
    if(id > 0) {
      count += (q.first["quantity"] as num).round();
      brick.quantity = count;
      return await updateBrick(brick);
    }
    else if(brick.quantity < 1) {
      return 0;
    }
    else {
      return insertBrick(brick);
    }
  }

  // Same as insertBrickAccumulate but for lists.
  Future<int> insertBrickAccumulateMultiple(List<Brick> bricks) async {
    int count = 0;
    for (var brick in bricks) {
      count += await insertBrickAccumulate(brick);
    }
    return count;
  }

  Future<List<Brick>> getBricks() async {
    final db = await instance.database;
    final result = await db.query('bricks');
    return result.map((map) => Brick.fromMap(map)).toList();
  }

  Future<int> updateBrick(Brick brick) async {
    final db = await instance.database;
    return await db.update('bricks', brick.toMap(), where: 'id = ?', whereArgs: [brick.id]);
  }

  Future<int> deleteBrick(int id) async {
    final db = await instance.database;
    return await db.delete('bricks', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}
