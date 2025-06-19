import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class Sysdata22Table {
  static const String TABLE_NAME = "Sysdata22";

  static const String genID = "GenID";
  static const String masterName = "MasterName";
  static const String mainID = "MainID";
  static const String mainDescr = "MainDescr";
  static const String subID = "SubID";
  static const String subDescr = "SubDescr";
  static const String numVal1 = "numVal1";
  static const String numVal2 = "numVal2";
  static const String form = "Form";
  static const String addonInfo = "AddonInfo";
  static const String moreInfo = "MoreInfo";
  static const String priviledge = "Priviledge";
  static const String a = "a";
  static const String moduleAccess = "ModuleAccess";
  static const String moduleID = "ModuleID";

  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $genID TEXT,
      $masterName TEXT DEFAULT '',
      $mainID TEXT DEFAULT '',
      $mainDescr TEXT DEFAULT '',
      $subID TEXT DEFAULT '',
      $subDescr TEXT DEFAULT '',
      $numVal1 INTEGER DEFAULT 0,
      $numVal2 INTEGER DEFAULT 0,
      $form TEXT DEFAULT '',
      $addonInfo TEXT DEFAULT '',
      $moreInfo TEXT DEFAULT '',
      $priviledge INTEGER DEFAULT 0,
      $a INTEGER DEFAULT 0,
      $moduleAccess TEXT DEFAULT '',
      $moduleID TEXT DEFAULT ''
    )
  ''';

  // Insert a record
  Future<void> insert(Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.insert(TABLE_NAME, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper().database;
    return await db.query(TABLE_NAME);
  }

  // Get record by GenID
  Future<List<Map<String, dynamic>>> getByGenID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$genID = ?',
      whereArgs: [id],
    );
  }

  // Update record by GenID
  Future<void> update(String id, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$genID = ?',
      whereArgs: [id],
    );
  }
// Get and print MainDescr values where MasterName is "Status", grouped by MainID and ordered by MainID
  Future<List<String>> getAndPrintMainDescrWhereStatus() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query(
    TABLE_NAME ,
    where : "$masterName = ?" ,
    whereArgs: ['Status'],
    groupBy:  "$mainID ",
    orderBy:   "$mainID");

    // Extract and print MainDescr from each row
    List<String> status = result.map((row) => row[mainDescr] as String).toList();

    // Print each MainDescr
    for (var s in status) {
      print('Status: $s');
    }

    return status;
  }

  // Delete a record by GenID
  Future<int> delete(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$genID = ?',
      whereArgs: [id],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }
}
