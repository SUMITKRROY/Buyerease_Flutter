import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class Enclosures {
  static const String TABLE_NAME = "Enclosures";

  static const String qrpoItemDtlID = "QRPOItemDtlID";
  static const String qrpoItemHdrID = "QRPOItemHdrID";
  static const String qrHdrID = "QRHdrID";
  static const String contextType = "ContextType";
  static const String seqNo = "SeqNo";
  static const String contextID = "ContextID";
  static const String contextDs = "ContextDs";
  static const String contextDs1 = "ContextDs1";
  static const String contextDs2 = "ContextDs2";
  static const String contextDs2a = "ContextDs2a";
  static const String contextDs3 = "ContextDs3";
  static const String enclType = "EnclType";
  static const String enclFileType = "EnclFileType";
  static const String enclRowID = "EnclRowID";
  static const String title = "Title";
  static const String imageName = "ImageName";
  static const String fileIcon = "FileIcon";
  static const String imagePathID = "ImagePathID";
  static const String isImportant = "IsImportant";
  static const String isRead = "IsRead";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  // SQL create statement
  static const String CREATE = '''
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
  $qrpoItemDtlID TEXT,
  $qrpoItemHdrID TEXT,
  $qrHdrID TEXT,
  $contextType TEXT DEFAULT '',
  $seqNo INTEGER DEFAULT 1,
  $contextID TEXT DEFAULT '',
  $contextDs TEXT DEFAULT '',
  $contextDs1 TEXT DEFAULT '',
  $contextDs2 TEXT DEFAULT '',
  $contextDs2a TEXT DEFAULT '',
  $contextDs3 TEXT DEFAULT '',
  $enclType TEXT DEFAULT '',
  $enclFileType TEXT DEFAULT '',
  $enclRowID TEXT PRIMARY KEY,
  $title TEXT DEFAULT '',
  $imageName TEXT DEFAULT '',
  $fileIcon TEXT DEFAULT '',
  $imagePathID TEXT DEFAULT '',
  $isImportant INTEGER DEFAULT 0,
  $isRead INTEGER DEFAULT 0,
  $createdAt TEXT DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for creation
  $updatedAt TEXT DEFAULT CURRENT_TIMESTAMP   -- Timestamp for last update
)
''';

  Future<void> insert(Map<String, dynamic> map) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Convert bools to integers
    final sanitizedMap = map.map((key, value) {
      if (value is bool) {
        return MapEntry(key, value ? 1 : 0);
      }
      return MapEntry(key, value);
    });

    await db.insert(
      TABLE_NAME,
      sanitizedMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all enclosures
  Future<List<Map<String, dynamic>>> getAll() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query(TABLE_NAME);
  }

  // Delete all enclosures
  Future<int> deleteAll() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.delete(TABLE_NAME);
  }

  // Get all important enclosures (IsImportant = 1)
  Future<List<Map<String, dynamic>>> getImportantEnclosures() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    return await db.query(
      TABLE_NAME,
      where: '$isImportant = ?',
      whereArgs: [1], // Get enclosures where IsImportant is 1
    );
  }

  Future<void> markAsRead(String rowID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.update(
      TABLE_NAME,
      {
        isRead: 1,
        updatedAt: DateTime.now().toIso8601String(),
      },
      where: '$enclRowID = ?',
      whereArgs: [rowID],
    );
  }


  Future<void> updateEnclosure(String rowID, Map<String, dynamic> newValues) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Convert bools to integers
    final sanitizedMap = newValues.map((key, value) {
      if (value is bool) {
        return MapEntry(key, value ? 1 : 0);
      }
      return MapEntry(key, value);
    });

    // Update the timestamp
    sanitizedMap[updatedAt] = DateTime.now().toIso8601String();

    await db.update(
      TABLE_NAME,
      sanitizedMap,
      where: '$enclRowID = ?',
      whereArgs: [rowID],
    );
  }

}
