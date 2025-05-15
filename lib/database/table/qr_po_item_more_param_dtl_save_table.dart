import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QRPOItemMoreParamDtlSaveTable {
  static const String TABLE_NAME = "QRPOItemMoreParamDtl_Save";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String qrPOItemMoreParamHdrID = "QRPOItemMoreParamHdrID";
  static const String qrPOItemMoreParamDtlID = "QRPOItemMoreParamDtlID";
  static const String objectDescr = "ObjectDescr";
  static const String chrVal1 = "chrVal1";
  static const String chrVal2 = "chrVal2";
  static const String numVal = "numVal";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddUser = "recAddUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String lastSyncDt = "Last_Sync_Dt";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID CHAR PRIMARY KEY,
      $locID CHAR,
      $qrHdrID CHAR,
      $qrPOItemHdrID CHAR,
      $qrPOItemMoreParamHdrID CHAR,
      $qrPOItemMoreParamDtlID CHAR,
      $objectDescr NVARCHAR,
      $chrVal1 VARCHAR,
      $chrVal2 VARCHAR,
      $numVal SMALLINT,
      $recDirty TINYINT,
      $recEnable TINYINT,
      $recUser CHAR,
      $recAddUser CHAR,
      $recAddDt TEXT,
      $recDt TEXT,
      $lastSyncDt TEXT DEFAULT '1900-01-01 00:00:00'
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
  Future<List<Map<String, dynamic>>> getById(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
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
