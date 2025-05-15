import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class TestReportTable {
  static const String TABLE_NAME = "TestReport";

  static const String pRowID = "pRowID";
  static const String ActivityID = "ActivityID";
  static const String ActivityDescr = "ActivityDescr";
  static const String TestDt = "TestDt";
  static const String ValidUpToDt = "ValidUpToDt";
  static const String ReportName = "ReportName";
  static const String Remarks = "Remarks";
  static const String IsExpired = "IsExpired";
  static const String FileExtn = "FileExtn";
  static const String FileIcon = "FileIcon";
  static const String QRPOItemHdrID = "QRPOItemHdrID";
  static const String QRHdrID = "QRHdrID";
  static const String ImagePathID = "ImagePathID";

  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pRowID TEXT PRIMARY KEY,
  $ActivityID TEXT DEFAULT '',
  $ActivityDescr TEXT DEFAULT '',
  DeliveryDt TEXT DEFAULT '',
  POTnARowID TEXT DEFAULT '',
  $TestDt TEXT DEFAULT '',
  $ValidUpToDt TEXT DEFAULT '',
  $ReportName TEXT DEFAULT '',
  $Remarks TEXT DEFAULT '',
  $IsExpired INTEGER DEFAULT 0,
  $FileExtn TEXT DEFAULT '',
  $FileIcon TEXT DEFAULT '',
  $QRPOItemHdrID TEXT DEFAULT '',
  $QRHdrID TEXT DEFAULT '',
  $ImagePathID TEXT DEFAULT ''
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

  Future<List<Map<String, dynamic>>> getActiveReports() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$IsExpired = ?',
      whereArgs: [0],
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
