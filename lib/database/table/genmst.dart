import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class GenMst {
  static const String TABLE_NAME = "GenMst";

  static const String pGenRowID = "pGenRowID";
  static const String locID = "LocID";
  static const String genID = "GenID";
  static const String mainID = "MainID";
  static const String subID = "SubID";
  static const String abbrv = "Abbrv";
  static const String mainDescr = "MainDescr";
  static const String subDescr = "SubDescr";
  static const String numVal1 = "numVal1";
  static const String numVal2 = "numVal2";
  static const String numVal3 = "numVal3";
  static const String numVal4 = "numVal4";
  static const String numVal5 = "numVal5";
  static const String numVal6 = "numVal6";
  static const String numVal7 = "numval7";
  static const String chrVal1 = "chrVal1";
  static const String chrVal2 = "chrVal2";
  static const String chrVal3 = "chrVal3";
  static const String dtVal1 = "dtVal1";
  static const String imageName = "ImageName";
  static const String imageExtn = "ImageExtn";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String ediDt = "EDIDt";
  static const String isPrivilege = "IsPrivilege";
  static const String lastSyncDt = "Last_Sync_Dt";


// SQL Create Table
  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pGenRowID TEXT PRIMARY KEY,
  $locID TEXT DEFAULT '',
  $genID TEXT DEFAULT '',
  $mainID TEXT DEFAULT '',
  $subID TEXT DEFAULT '',
  $abbrv TEXT DEFAULT '',
  $mainDescr TEXT DEFAULT '',
  $subDescr TEXT DEFAULT '',
  $numVal1 REAL DEFAULT 0,
  $numVal2 REAL DEFAULT 0,
  $numVal3 REAL DEFAULT 0,
  $numVal4 REAL DEFAULT 0,
  $numVal5 REAL DEFAULT 0,
  $numVal6 REAL DEFAULT 0,
  $numVal7 REAL DEFAULT 0,
  $chrVal1 TEXT DEFAULT '',
  $chrVal2 TEXT DEFAULT '',
  $chrVal3 TEXT DEFAULT '',
  $dtVal1 TEXT DEFAULT '',
  $imageName TEXT DEFAULT '',
  $imageExtn TEXT DEFAULT '',
  $recDirty INTEGER DEFAULT 0,
  $recEnable INTEGER DEFAULT 1,
  $recUser TEXT DEFAULT '',
  $recAddDt TEXT DEFAULT '',
  $recDt TEXT DEFAULT '',
  $ediDt TEXT DEFAULT '',
  $isPrivilege INTEGER DEFAULT 0,
  $lastSyncDt TEXT DEFAULT '1900-01-01 00:00:00'
)
''';

  Future<void> insert(Map<String, dynamic> map) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.insert(
      TABLE_NAME,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query(TABLE_NAME);
  }

  Future<int> deleteAll() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.delete(TABLE_NAME);
  }

  Future<List<Map<String, dynamic>>> getByGenID(String genIdValue) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$genID = ?',
      whereArgs: [genIdValue],
    );
  }

  Future<void> updateRecord(String rowID, Map<String, dynamic> values) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pGenRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<int> deleteRecord(String rowID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.delete(
      TABLE_NAME,
      where: '$pGenRowID = ?',
      whereArgs: [rowID],
    );
  }

  Future<List<Map<String, dynamic>>> getEnabled() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$recEnable = ?',
      whereArgs: [1],
    );
  }
}
