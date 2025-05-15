import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrFindingsTable {
  static const String TABLE_NAME = "QRFindings";

  // Field constants
  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QrHdrID";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String itemID = "ItemID";
  static const String descr = "Descr";
  static const String recEnable = "recEnable";
  static const String recDt = "recDt";
  static const String recUser = "recUser";
  static const String sampleSizeID = "SampleSizeID";
  static const String changeCount = "ChangeCount";
  static const String oldHeight = "OLD_Height";
  static const String oldWidth = "OLD_Width";
  static const String oldLength = "OLD_Length";
  static const String newHeight = "New_Height";
  static const String newWidth = "New_Width";
  static const String newLength = "New_Length";
  static const String measurementID = "MeasurementID";

  // Create Table SQL
  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID TEXT PRIMARY KEY,
      $locID TEXT,
      $qrHdrID TEXT,
      $qrPOItemHdrID TEXT,
      $itemID TEXT,
      $descr TEXT,
      $recEnable INTEGER DEFAULT 1,
      $recDt TEXT,
      $recUser TEXT,
      $sampleSizeID TEXT,
      $changeCount INTEGER DEFAULT 0,
      $oldHeight REAL DEFAULT 0,
      $oldWidth REAL DEFAULT 0,
      $oldLength REAL DEFAULT 0,
      $newHeight REAL DEFAULT 0,
      $newWidth REAL DEFAULT 0,
      $newLength REAL DEFAULT 0,
      $measurementID TEXT
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
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update record by ID
  Future<void> updateRecord(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete record by ID
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
