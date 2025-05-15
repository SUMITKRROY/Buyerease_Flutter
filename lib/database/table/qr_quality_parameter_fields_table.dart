import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QRQualityParameterFieldsTable {
  static const String TABLE_NAME = "QRQualiltyParameterFields";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPOItemDtlID = "QRPOItemDtlID";
  static const String itemID = "ItemID";
  static const String colorID = "ColorID";
  static const String qualityParameterID = "QualityParameterID";
  static const String isApplicable = "IsApplicable";
  static const String remarks = "Remarks";
  static const String recAddUser = "recAddUser";
  static const String recAddDt = "recAddDt";
  static const String recEnable = "recEnable";
  static const String recDirty = "recDirty";
  static const String recUser = "recUser";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";
  static const String optionSelected = "OptionSelected";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String digitals = "Digitals";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID CHAR PRIMARY KEY,
      $locID CHAR DEFAULT '',
      $qrHdrID CHAR DEFAULT '',
      $qrPOItemDtlID CHAR DEFAULT '',
      $itemID CHAR DEFAULT '',
      $colorID CHAR DEFAULT '',
      $qualityParameterID CHAR DEFAULT '',
      $isApplicable SMALLINT DEFAULT 0,
      $remarks NVARCHAR DEFAULT '',
      $recAddUser CHAR DEFAULT '',
      $recAddDt TEXT DEFAULT '',
      $recEnable TINYINT DEFAULT 1,
      $recDirty TINYINT DEFAULT 1,
      $recUser CHAR DEFAULT '',
      $recDt TEXT DEFAULT '',
      $ediDt TEXT DEFAULT '',
      $optionSelected SMALLINT DEFAULT 0,
      $qrPOItemHdrID CHAR DEFAULT '',
      $digitals TEXT DEFAULT ''
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
