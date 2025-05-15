import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class TestTable {
  static const String TABLE_NAME = "Test";

  static const String id = "ID";
  static const String name = "Name";
  static const String address = "Address";
  static const String company = "Company";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT,
      $address TEXT,
      $company TEXT
    )
  ''';

  // Insert a record
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(TABLE_NAME, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get record by ID
  Future<List<Map<String, dynamic>>> getByID(int id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$id = ?',
      whereArgs: [id],
    );
  }

  // Update a record by ID
  Future<void> update(int id, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$id = ?',
      whereArgs: [id],
    );
  }

  // Delete a record by ID
  Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$id = ?',
      whereArgs: [id],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
