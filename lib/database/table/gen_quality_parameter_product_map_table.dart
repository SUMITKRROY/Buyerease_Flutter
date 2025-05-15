import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class GenQualityParameterProductMapTable {
  static const String TABLE_NAME = "GenQualityParameterProductMap";

  static const String genRowID = "GenRowID";
  static const String productID = "ProductID";

  // SQL to create the table
  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $genRowID TEXT NOT NULL,
    $productID TEXT NOT NULL
  )
  ''';

  // Insert a record
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }

  // Get by GenRowID
  Future<List<Map<String, dynamic>>> getByGenRowID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$genRowID = ?',
      whereArgs: [id],
    );
  }

  // Update a record by GenRowID
  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$genRowID = ?',
      whereArgs: [rowID],
    );
  }

  // Delete a record by GenRowID
  Future<int> deleteRecord(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$genRowID = ?',
      whereArgs: [rowID],
    );
  }
}
