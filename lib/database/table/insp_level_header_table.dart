import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class InspLevelHeaderTable {
    static const String TABLE_NAME = "InsplvlHdr";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String inspDescr = "InspDescr";
  static const String inspAbbrv = "InspAbbrv";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";
  static const String isDefault = "IsDefault";

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT PRIMARY KEY,
    $locID TEXT,
    $inspDescr TEXT DEFAULT '',
    $inspAbbrv TEXT DEFAULT '',
    $recDirty INTEGER DEFAULT 1,
    $recEnable INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT '',
    $recDt TEXT DEFAULT '',
    $ediDt TEXT DEFAULT '',
    $isDefault INTEGER DEFAULT 0
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

  // Get by pRowID
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update record by pRowID
  Future<void> updateRecord(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete record by pRowID
  Future<int> deleteRecord(String id) async {
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
