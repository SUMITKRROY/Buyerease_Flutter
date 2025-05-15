import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class QrAuditBatchDetailsTable {
  static const String TABLE_NAME = "QRAuditBatchDetails";

  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String qrHdrID = "QRHdrID";
  static const String qrPoItemHdrID = "QRPOItemHdrID";
  static const String qrPoItemDtlRowID = "QRPOItemDtlRowID";
  static const String itemID = "ItemID";
  static const String colorID = "ColorID";
  static const String defectID = "DefectID";
  static const String defectCode = "DefectCode";
  static const String defectName = "DefectName";
  static const String dclTypeID = "DCLTypeID";
  static const String defectComments = "DefectComments";
  static const String defectDescription = "DefectDescription";
  static const String criticalDefect = "CriticalDefect";
  static const String majorDefect = "MajorDefect";
  static const String minorDefect = "MinorDefect";
  static const String criticalType = "CriticalType";
  static const String majorType = "MajorType";
  static const String minorType = "MinorType";
  static const String sampleRqstCriticalRowID = "SampleRqstCriticalRowID";
  static const String poItemHdrCriticalRowID = "POItemHdrCriticalRowID";
  static const String digitals = "Digitals";
  static const String recAdddt = "recAdddt";
  static const String recDt = "recDt";
  static const String recAddUser = "recAddUser";
  static const String recUser = "recUser";
  static const String bePRowID = "BE_pRowID";
  static const String digitalDsc = "DigitalDsc";
  static const String recEnable = "recEnable";

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pRowID TEXT PRIMARY KEY,
    $locID TEXT DEFAULT '',
    $qrHdrID TEXT DEFAULT '',
    $qrPoItemHdrID TEXT DEFAULT '',
    $qrPoItemDtlRowID TEXT DEFAULT '',
    $itemID TEXT DEFAULT '',
    $colorID TEXT DEFAULT '',
    $defectID TEXT DEFAULT '',
    $defectCode TEXT DEFAULT '',
    $defectName TEXT DEFAULT '',
    $dclTypeID TEXT DEFAULT '',
    $defectComments TEXT DEFAULT '',
    $defectDescription TEXT DEFAULT '',
    $criticalDefect INTEGER DEFAULT 0,
    $majorDefect INTEGER DEFAULT 0,
    $minorDefect INTEGER DEFAULT 0,
    $criticalType INTEGER DEFAULT 0,
    $majorType INTEGER DEFAULT 0,
    $minorType INTEGER DEFAULT 0,
    $sampleRqstCriticalRowID TEXT DEFAULT '',
    $poItemHdrCriticalRowID TEXT DEFAULT '',
    $digitals TEXT DEFAULT '',
    $recAdddt TEXT DEFAULT (datetime('now','localtime')),
    $recDt TEXT DEFAULT (datetime('now','localtime')),
    $recAddUser TEXT DEFAULT '',
    $recUser TEXT DEFAULT '',
    $bePRowID TEXT DEFAULT '',
    $digitalDsc TEXT DEFAULT '',
    $recEnable INTEGER DEFAULT 1
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

  // Update a record by pRowID
  Future<void> updateRecord(String id, Map<String, dynamic> values) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      values,
      where: '$pRowID = ?',
      whereArgs: [id],
    );
  }

  // Delete a record by pRowID
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

