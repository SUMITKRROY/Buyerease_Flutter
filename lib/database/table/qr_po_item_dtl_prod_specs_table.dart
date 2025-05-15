import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class QRPOItemDtlProdSpecsTable {
  static const String TABLE_NAME = "QRPOItemDtl_ProdSpecs";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String prodSpecsID = "ProdSpecsID";
  static const String sampleSizeID = "SampleSizeID";
  static const String sampleSizeValue = "SampleSizeValue";
  static const String inspectionResultID = "InspectionResultID";
  static const String descr = "Descr";
  static const String recAddUser = "recAddUser";
  static const String recAddDt = "recAddDt";
  static const String recEnable = "recEnable";
  static const String recDirty = "recDirty";
  static const String recUser = "recUser";
  static const String recDt = "recDt";
  static const String lastSyncDt = "Last_Sync_Dt";

  // SQL to create the table
  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT NOT NULL,
    $locID TEXT DEFAULT '',
    $qrHdrID TEXT DEFAULT '',
    $qrPOItemHdrID TEXT DEFAULT '',
    $prodSpecsID TEXT DEFAULT '',
    $sampleSizeID TEXT DEFAULT '',
    $sampleSizeValue INTEGER DEFAULT 0,
    $inspectionResultID TEXT DEFAULT '',
    $descr TEXT DEFAULT '',
    $recAddUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT 'Datetime(''now'',''localtime'')',
    $recEnable INTEGER DEFAULT 1,
    $recDirty INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recDt TEXT DEFAULT 'Datetime(''now'',''localtime'')',
    $lastSyncDt TEXT DEFAULT '1900-01-01 00:00:00',
    PRIMARY KEY($pRowID)
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

  // Get by pRowID
  Future<List<Map<String, dynamic>>> getByPRowID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Update a record by pRowID
  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [rowID],
    );
  }

  // Delete a record by pRowID
  Future<int> deleteRecord(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [rowID],
    );
  }
}
