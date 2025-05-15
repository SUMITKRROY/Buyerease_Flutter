import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class QrPoItemDtlMaterialInspectionDtlTable {
  static const String TABLE_NAME = "QRPOItemDtl_MaterialInspectionDtl";

  // Column names
  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPoItemHdrID = "QRPOItemHdrID";
  static const String defectType = "DefectType";
  static const String pointObserved = "PointObserved";
  static const String pointPerRoll = "PointPerRoll";
  static const String chrVal01 = "chrVal01";
  static const String chrVal02 = "chrVal02";
  static const String chrVal03 = "chrVal03";
  static const String chrVal04 = "chrVal04";
  static const String chrVal05 = "chrVal05";
  static const String chrVal06 = "chrVal06";
  static const String chrVal07 = "chrVal07";
  static const String chrVal08 = "chrVal08";
  static const String chrVal09 = "chrVal09";
  static const String chrVal10 = "chrVal10";
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
    $qrPoItemHdrID TEXT DEFAULT '',
    $defectType TEXT DEFAULT '',
    $pointObserved TEXT DEFAULT '',
    $pointPerRoll INTEGER DEFAULT 0,
    $chrVal01 TEXT DEFAULT '',
    $chrVal02 TEXT DEFAULT '',
    $chrVal03 TEXT DEFAULT '',
    $chrVal04 TEXT DEFAULT '',
    $chrVal05 TEXT DEFAULT '',
    $chrVal06 TEXT DEFAULT '',
    $chrVal07 TEXT DEFAULT '',
    $chrVal08 TEXT DEFAULT '',
    $chrVal09 TEXT DEFAULT '',
    $chrVal10 TEXT DEFAULT '',
    $recAddUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT '',
    $recEnable INTEGER DEFAULT 1,
    $recDirty INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recDt TEXT DEFAULT '',
    $lastSyncDt TEXT DEFAULT '1900-01-01 00:00:00',
    PRIMARY KEY($pRowID)
  );
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
  Future<List<Map<String, dynamic>>> getByRowID(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [rowID],
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

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
