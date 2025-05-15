import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QualityLevelTable {
  static const String TABLE_NAME = "QualityLevel";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qualityLevel = "QualityLevel";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID TEXT PRIMARY KEY,
      $locID TEXT DEFAULT '',
      $qualityLevel TEXT DEFAULT '',
      $recDirty INTEGER DEFAULT 1,
      $recEnable INTEGER DEFAULT 1,
      $recUser TEXT DEFAULT '',
      $recAddDt TEXT DEFAULT 'DateTime(''now'',''localtime'')',
      $recDt TEXT DEFAULT 'DateTime(''now'',''localtime'')',
      $ediDt TEXT DEFAULT ''
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

  // Get record by pRowID
  Future<List<Map<String, dynamic>>> getById(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Update record by pRowID
  Future<void> update(String id, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete record by pRowID
  Future<int> delete(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
