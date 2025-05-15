import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class QRPOItemDtlSamplePurposeTable {
  static const String TABLE_NAME = "QRPOItemDtl_Sample_Purpose";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPOItemHdrID = "QRPOItemHdrID";
  static const String qrPOItemDtlID = "QRPOItemDtlID";
  static const String itemID = "ItemID";
  static const String colorID = "ColorID";
  static const String samplePurposeID = "SamplePurposeID";
  static const String sampleNumber = "SampleNumber";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String lastSyncDt = "Last_Sync_Dt";

  // SQL to create the table
  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT NOT NULL,
    $locID TEXT DEFAULT '',
    $qrHdrID TEXT DEFAULT '',
    $qrPOItemHdrID TEXT DEFAULT '',
    $qrPOItemDtlID TEXT DEFAULT '',
    $itemID TEXT DEFAULT '',
    $colorID TEXT DEFAULT '',
    $samplePurposeID TEXT DEFAULT '',
    $sampleNumber INTEGER DEFAULT 0,
    $recEnable INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT 'Datetime(''now'',''localtime'')',
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
