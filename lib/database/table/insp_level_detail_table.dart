import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class InspLvlDtlTable {
  static const String TABLE_NAME = "InspLvlDtl";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String inspHdrID = "InspHdrID";
  static const String signDescr = "SignDescr";
  static const String batchSize = "BatchSize";
  static const String sampleCode = "SampleCode";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddUser = "recAddUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";

  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $pRowID TEXT PRIMARY KEY,
  $locID TEXT,
  $inspHdrID TEXT DEFAULT '',
  $signDescr TEXT DEFAULT '',
  $batchSize INTEGER DEFAULT 0,
  $sampleCode TEXT,
  $recDirty INTEGER DEFAULT 1,
  $recEnable INTEGER DEFAULT 1,
  $recUser TEXT DEFAULT '',
  $recAddUser TEXT DEFAULT '',
  $recAddDt TEXT DEFAULT '',
  $recDt TEXT DEFAULT '',
  $ediDt TEXT DEFAULT ''
)
''';


  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;

    // Optional: get column names from table (only if you want a generic solution)
    final tableInfo = await db.rawQuery('PRAGMA table_info($TABLE_NAME)');
    final validColumns = tableInfo.map((col) => col['name'] as String).toSet();

    // Remove keys not in the table
    final cleanMap = Map.fromEntries(map.entries.where((e) => validColumns.contains(e.key)));

    await db.insert(
      TABLE_NAME,
      cleanMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get record by primary key (pRowID)
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Get records by InspHdrID
  Future<List<Map<String, dynamic>>> getByInspHdrID(String inspHdrId) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$inspHdrID = ?',
      whereArgs: [inspHdrId],
    );
  }

  // Update record by pRowID
  Future<void> updateRecord(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete record by pRowID
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
