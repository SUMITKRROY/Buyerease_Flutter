
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class DefectMaster {
  static const String TABLE_NAME = "DefectMaster";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String defectName = "DefectName";
  static const String code = "Code";
  static const String dclTypeID = "DCLTypeID";
  static const String inspectionStage = "InspectionStage";
  static const String chkCritical = "chkCritical";
  static const String chkMajor = "chkMajor";
  static const String chkMinor = "chkMinor";
  static const String recEnable = "recEnable";
  static const String recAdddt = "recAdddt";
  static const String recDt = "recDt";
  static const String recAddUser = "recAddUser";
  static const String recUser = "recUser";

// SQL create statement
  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pRowID TEXT PRIMARY KEY,
  $locID TEXT DEFAULT '',
  $defectName TEXT DEFAULT '',
  $code TEXT DEFAULT '',
  $dclTypeID TEXT DEFAULT '',
  $inspectionStage TEXT DEFAULT '',
  $chkCritical INTEGER DEFAULT 0,
  $chkMajor INTEGER DEFAULT 0,
  $chkMinor INTEGER DEFAULT 0,
  $recEnable INTEGER DEFAULT 1,
  $recAdddt TEXT DEFAULT '',
  $recDt TEXT DEFAULT '',
  $recAddUser TEXT DEFAULT '',
  $recUser TEXT DEFAULT ''
)
''';

  Future<void> insert(Map<String, dynamic> map) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(TABLE_NAME);
  }

  Future<int> deleteAllRecords() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.delete(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getEnabledDefects() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$recEnable = ?',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> getDefectsByLocation(String locationID) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$locID = ?',
      whereArgs: [locationID],
    );
  }

  Future<void> updateRecord({
    required String pRowIDVal,
    required Map<String, dynamic> newValues,
  }) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    await db.update(
      TABLE_NAME,
      newValues,
      where: '$pRowID = ?',
      whereArgs: [pRowIDVal],
    );
  }

  Future<int> deleteRecord(String pRowIDVal) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.delete(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [pRowIDVal],
    );
  }
}
