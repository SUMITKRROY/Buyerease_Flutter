import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class DefectApplicableMatrix {
  static const String TABLE_NAME = "DefectApplicableMatrix";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String defectID = "DefectID";
  static const String productID = "ProductID";
  static const String categoryID = "CategoryID";
  static const String subCategoryID = "SubCategoryID";
  static const String recEnable = "recEnable";
  static const String recAdddt = "recAdddt";
  static const String recDt = "recDt";
  static const String recAddUser = "recAddUser";
  static const String recUser = "recUser";

// SQL Create Table
  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pRowID TEXT PRIMARY KEY,
  $locID TEXT NOT NULL,
  $defectID TEXT DEFAULT '',
  $productID TEXT DEFAULT '',
  $categoryID TEXT DEFAULT '',
  $subCategoryID TEXT DEFAULT '',
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

  Future<List<Map<String, dynamic>>> getEnabledRecords() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$recEnable = ?',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> getRecordsByLocID(String locationID) async {
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
