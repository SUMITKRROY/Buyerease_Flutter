import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrPoItemDtlItemMeasurementTable {
  static const String TABLE_NAME = "QRPOItemDtl_ItemMeasurement";

  // Column names
  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPoItemHdrID = "QRPOItemHdrID";
  static const String qrPoItemDtlID = "QRPOItemDtlID";
  static const String itemID = "ItemID";
  static const String colorID = "ColorID";
  static const String itemMeasurementDescr = "ItemMeasurementDescr";
  static const String sampleSizeID = "SampleSizeID";
  static const String sampleSizeValue = "SampleSizeValue";
  static const String finding = "Finding";
  static const String inspectionResultID = "InspectionResultID";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String dimHeight = "Dim_Height";
  static const String dimWidth = "Dim_Width";
  static const String dimLength = "Dim_Length";
  static const String toleranceRange = "Tolerance_Range";
  static const String bePRowID = "BE_pRowID";
  static const String digitals = "Digitals";

  // SQL to create the table
  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID TEXT PRIMARY KEY,
      $locID TEXT DEFAULT '',
      $qrHdrID TEXT DEFAULT '',
      $qrPoItemHdrID TEXT DEFAULT '',
      $qrPoItemDtlID TEXT DEFAULT '',
      $itemID TEXT DEFAULT '',
      $colorID TEXT DEFAULT '',
      $itemMeasurementDescr TEXT DEFAULT '',
      $sampleSizeID TEXT DEFAULT '',
      $sampleSizeValue INTEGER DEFAULT 0,
      $finding TEXT DEFAULT '',
      $inspectionResultID TEXT DEFAULT '',
      $recEnable INTEGER DEFAULT 1,
      $recUser TEXT DEFAULT '',
      $recAddDt TEXT DEFAULT '',
      $recDt TEXT DEFAULT '',
      $dimHeight REAL DEFAULT 0,
      $dimWidth REAL DEFAULT 0,
      $dimLength REAL DEFAULT 0,
      $toleranceRange TEXT DEFAULT '',
      $bePRowID TEXT DEFAULT '',
      $digitals TEXT DEFAULT ''
    )
  ''';

  // Insert
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(TABLE_NAME, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get by pRowID
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final res = await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // Update by pRowID
  Future<void> update(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete by pRowID
  Future<int> delete(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete all
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
