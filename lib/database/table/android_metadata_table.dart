import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class AndroidMetadataTable {
  static const String TABLE_NAME = "android_metadata";

  static const String locale = "locale";

  // SQL to create the table
  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $locale TEXT
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

  // Get by locale
  Future<List<Map<String, dynamic>>> getByLocale(String localeValue) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$locale = ?',
      whereArgs: [localeValue],
    );
  }

  // Update a record by locale
  Future<void> updateRecord(String localeValue, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$locale = ?',
      whereArgs: [localeValue],
    );
  }

  // Delete a record by locale
  Future<int> deleteRecord(String localeValue) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$locale = ?',
      whereArgs: [localeValue],
    );
  }
}
