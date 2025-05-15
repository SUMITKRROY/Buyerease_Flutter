import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrEnclosureTable {
  static const String TABLE_NAME = "QREnclosure";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String isMandatory = "IsMandatory";
  static const String contextID = "ContextID";
  static const String contextType = "ContextType";
  static const String enclType = "EnclType";
  static const String imageName = "ImageName";
  static const String imageExtn = "ImageExtn";
  static const String title = "Title";
  static const String fileName = "FileName";
  static const String fileDate = "FileDate";
  static const String approve = "Approve";
  static const String approveDate = "ApproveDate";
  static const String approvedBy = "ApprovedBy";
  static const String recDirty = "recDirty";
  static const String recEnable = "recEnable";
  static const String recUser = "recUser";
  static const String recAddDt = "recAddDt";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";
  static const String numVal1 = "numVal1";
  static const String fileSent = "FileSent";
  static const String fileContent = "fileContent";

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT PRIMARY KEY,
    $locID TEXT DEFAULT '',
    $isMandatory INTEGER DEFAULT 0,
    $contextID TEXT DEFAULT '',
    $contextType TEXT DEFAULT '71',
    $enclType TEXT DEFAULT '',
    $imageName TEXT DEFAULT '',
    $imageExtn TEXT DEFAULT '',
    $title TEXT DEFAULT '',
    $fileName TEXT DEFAULT '',
    $fileDate TEXT DEFAULT '',
    $approve INTEGER,
    $approveDate TEXT DEFAULT '',
    $approvedBy TEXT DEFAULT '',
    $recDirty INTEGER DEFAULT 1,
    $recEnable INTEGER DEFAULT 1,
    $recUser TEXT DEFAULT '',
    $recAddDt TEXT DEFAULT (datetime('now','localtime')),
    $recDt TEXT DEFAULT (datetime('now','localtime')),
    $ediDt TEXT DEFAULT '',
    $numVal1 INTEGER DEFAULT 0,
    $fileSent INTEGER DEFAULT 0,
    $fileContent BLOB
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

  // Get record by pRowID
  Future<Map<String, dynamic>?> getById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      TABLE_NAME,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
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
