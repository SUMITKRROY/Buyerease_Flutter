import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrPoIntimationDetailsTable {
  static const String TABLE_NAME = 'QRPOIntimationDetails';

  static const String colPRowID = 'pRowID';
  static const String colLocID = 'LocID';
  static const String colQrHdrID = 'QRHdrID';
  static const String colName = 'Name';
  static const String colEmailID = 'EmailID';
  static const String colID = 'ID';
  static const String colIsLink = 'IsLink';
  static const String colIsReport = 'IsReport';
  static const String colRecType = 'recType';
  static const String colRecEnable = 'recEnable';
  static const String colRecAddUser = 'recAddUser';
  static const String colRecAddDt = 'recAddDt';
  static const String colRecUser = 'recUser';
  static const String colRecDt = 'recDt';
  static const String colEdiDt = 'EDIDt';
  static const String colIsHtmlLink = 'IsHtmlLink';
  static const String colIsRcvApplicable = 'IsRcvApplicable';
  static const String colBePRowID = 'BE_pRowID';
  static const String colIsSelected = 'IsSelected';

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $colPRowID TEXT,
    $colLocID TEXT,
    $colQrHdrID TEXT,
    $colName TEXT,
    $colEmailID TEXT,
    $colID TEXT,
    $colIsLink INTEGER DEFAULT 0,
    $colIsReport INTEGER DEFAULT 0,
    $colRecType INTEGER DEFAULT 0,
    $colRecEnable INTEGER DEFAULT 1,
    $colRecAddUser TEXT,
    $colRecAddDt TEXT,
    $colRecUser TEXT DEFAULT '',
    $colRecDt TEXT,
    $colEdiDt TEXT,
    $colIsHtmlLink INTEGER DEFAULT 0,
    $colIsRcvApplicable INTEGER DEFAULT 0,
    $colBePRowID TEXT,
    $colIsSelected INTEGER DEFAULT 0,
    PRIMARY KEY($colPRowID)
  )
  ''';

  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getByQrHdrID(String qrHdrId) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$colQrHdrID = ?',
      whereArgs: [qrHdrId],
    );
  }

  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$colPRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<int> deleteRecord(String rowID) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$colPRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getEnabledRecords() async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$colRecEnable = ?',
      whereArgs: [1],
    );
  }
}
