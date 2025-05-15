import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QRProductionStatusTable {
  static const String TABLE_NAME = "QRProductionStatus";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrProdStatusID = "QRProdStatusID";
  static const String recEnable = "recEnable";
  static const String recDt = "recDt";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String percentage = "Percentage";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID TEXT NOT NULL DEFAULT '',
      $locID TEXT NOT NULL DEFAULT '',
      $qrHdrID TEXT NOT NULL DEFAULT '',
      $qrProdStatusID TEXT NOT NULL DEFAULT '',
      $recEnable INTEGER NOT NULL DEFAULT 1,
      $recDt TEXT NOT NULL DEFAULT '',
      $recUser TEXT NOT NULL DEFAULT '',
      $recAddDt TEXT NOT NULL DEFAULT '',
      $percentage INTEGER,
      PRIMARY KEY($pRowID)
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
