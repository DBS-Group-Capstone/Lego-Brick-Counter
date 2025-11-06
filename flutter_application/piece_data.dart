import 'dart:async';


import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'piece_data.db'),
    // When the database is first created, create a table to store pieces.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE pieces(id INTEGER PRIMARY KEY, size TEXT, color INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );


  // Define a function that inserts pieces into the database
  Future<void> insertPiece(Piece piece) async {
    // Get a reference to the database.
    final db = await database;


    // Insert the Piece into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same piece is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'pieces',
      piece.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // A method that retrieves all the pieces from the pieces table.
  Future<List<Piece>> pieces() async {
    // Get a reference to the database.
    final db = await database;


    // Query the table for all the pieces.
    final List<Map<String, Object?>> pieceMaps = await db.query('pieces');


    // Convert the list of each piece's fields into a list of `Piece` objects.
    return [
      for (final {'id': id as int, 'size': size as String, 'color': color as int}
          in pieceMaps)
        Piece(id: id, size: size, color: color),
    ];
  }


  Future<void> updatePiece(Piece piece) async {
    // Get a reference to the database.
    final db = await database;


    // Update the given Piece.
    await db.update(
      'pieces',
      piece.toMap(),
      // Ensure that the Piece has a matching id.
      where: 'id = ?',
      // Pass the Piece's id as a whereArg to prevent SQL injection.
      whereArgs: [piece.id],
    );
  }


  Future<void> deletePiece(int id) async {
    // Get a reference to the database.
    final db = await database;


    // Remove the Piece from the database.
    await db.delete(
      'pieces',
      // Use a `where` clause to delete a specific piece.
      where: 'id = ?',
      // Pass the Piece's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  // Create a Piece and add it to the pieces table
  var brick = Piece(id: 3001, size: '2x4', color: 1);


  await insertPiece(brick);


  // Now, use the method above to retrieve all the bricks.
  print(await pieces()); // Prints a list that include brick.


  // Update brick's color and save it to the database.
  brick = Piece(id: brick.id, size: brick.size, color: brick.color + 22);
  await updatePiece(brick);


  // Print the updated results.
  print(await pieces()); // Prints brick with color 23.


  // Delete brick from the database.
  await deletePiece(brick.id);


  // Print the list of pieces (empty).
  print(await pieces());
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


  // Implement toString to make it easier to see information about
  // each piece when using the print statement.
  @override
  String toString() {
    return 'Piece{id: $id, size: $size, color: $color}';
  }
}
