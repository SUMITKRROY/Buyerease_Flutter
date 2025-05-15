import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_helper.dart';

class UserMasterTable {
  static const String TABLE_NAME = "UserMaster";

  static const String pUserID = "pUserID";
  static const String parentID = "ParentID";
  static const String loginName = "LoginName";
  static const String password = "Password";
  static const String userName = "UserName";
  static const String email = "Email";
  static const String fCommunityID = "fCommunityID";
  static const String fContactID = "fContactID";
  static const String isAdmin = "IsAdmin";
  static const String locID = "LocId";
  static const String desg = "Desg";
  static const String address = "Address";
  static const String city = "City";
  static const String zip = "Zip";
  static const String state = "State";
  static const String countryID = "CountryID";
  static const String phoneNo1 = "PhoneNo1";
  static const String phoneNo2 = "PhoneNo2";
  static const String phoneNo3 = "PhoneNo3";
  static const String fax = "Fax";
  static const String webURL = "WebURL";
  static const String pageSize = "PageSize";
  static const String dateFormat = "DateFormat";
  static const String homePOGraph = "HomePOGraph";
  static const String homePOGraphXValue = "HomePOGraphXValue";
  static const String homePOGraphYValue = "HomePOGraphYValue";
  static const String srView = "SRView";
  static const String poView = "POView";
  static const String poView12 = "POView12";
  static const String qrView = "QRView";
  static const String invoiceView = "InvoiceView";
  static const String vesselView = "VesselView";
  static const String columnPickerView = "ColumnPickerView";
  static const String approvalPassword = "ApprovalPassword";
  static const String birthDt = "BirthDt";
  static const String anniversaryDt = "AnniversaryDt";
  static const String joiningDt = "JoiningDt";
  static const String recEnable = "recEnable";
  static const String isValidated = "IsValidated";
  static const String lastSyncDt = "Last_Sync_Dt";
  static const String criticalDefectsAllowed = "CriticalDefectsAllowed";
  static const String companyName = "CompanyName";
  static const String qualityReportConfig = "QualityReportConfig";
  static const String userType = "UserType";
  static const String isOffLineInspection = "IsOffLineInspection";
  static const String offLineInspectionStaticIP = "OffLineInspectionStaticIP";
  static const String offLineInspectionMACID = "OffLineInspectionMACID";

  static const String CREATE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    $pUserID TEXT NOT NULL,
    $parentID TEXT DEFAULT '',
    $loginName TEXT DEFAULT '',
    $password TEXT DEFAULT '',
    $userName TEXT DEFAULT '',
    $email TEXT DEFAULT '',
    $fCommunityID TEXT DEFAULT '',
    $fContactID TEXT DEFAULT '',
    $isAdmin INTEGER DEFAULT 0,
    $locID TEXT DEFAULT '',
    $desg TEXT DEFAULT '',
    $address TEXT DEFAULT '',
    $city TEXT DEFAULT '',
    $zip TEXT DEFAULT '',
    $state TEXT DEFAULT '',
    $countryID TEXT DEFAULT '',
    $phoneNo1 TEXT DEFAULT '',
    $phoneNo2 TEXT DEFAULT '',
    $phoneNo3 TEXT DEFAULT '',
    $fax TEXT DEFAULT '',
    $webURL TEXT DEFAULT '',
    $pageSize TEXT DEFAULT '',
    $dateFormat INTEGER DEFAULT 0,
    $homePOGraph INTEGER DEFAULT 0,
    $homePOGraphXValue TEXT DEFAULT '',
    $homePOGraphYValue TEXT DEFAULT '',
    $srView INTEGER DEFAULT 0,
    $poView INTEGER DEFAULT 0,
    $poView12 INTEGER DEFAULT 0,
    $qrView INTEGER DEFAULT 0,
    $invoiceView INTEGER DEFAULT 0,
    $vesselView INTEGER DEFAULT 0,
    $columnPickerView INTEGER DEFAULT 0,
    $approvalPassword TEXT DEFAULT '',
    $birthDt TEXT DEFAULT '',
    $anniversaryDt TEXT DEFAULT '',
    $joiningDt TEXT DEFAULT '',
    $recEnable INTEGER DEFAULT 1,
    $isValidated INTEGER DEFAULT 0,
    $lastSyncDt TEXT DEFAULT '1900-01-01 00:00:00',
    $criticalDefectsAllowed INTEGER DEFAULT 0,
    $companyName TEXT DEFAULT '',
    $qualityReportConfig TEXT DEFAULT '',
    $userType TEXT DEFAULT '',
    $isOffLineInspection INTEGER DEFAULT 0, 
    $offLineInspectionStaticIP TEXT DEFAULT '',
    $offLineInspectionMACID TEXT DEFAULT '',
    PRIMARY KEY($pUserID)
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

  // Get record by pUserID
  Future<List<Map<String, dynamic>>> getByPUserID(String id) async {
    final db = await DatabaseHelper().database;
    return await db.query(
      TABLE_NAME,
      where: '$pUserID = ?',
      whereArgs: [id],
    );
  }

  // Update record by pUserID
  Future<void> update(String id, Map<String, dynamic> map) async {
    final db = await DatabaseHelper().database;
    await db.update(
      TABLE_NAME,
      map,
      where: '$pUserID = ?',
      whereArgs: [id],
    );
  }

  // Delete record by pUserID
  Future<int> delete(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      TABLE_NAME,
      where: '$pUserID = ?',
      whereArgs: [id],
    );
  }

  // Delete all records
  Future<int> deleteAll() async {
    final db = await DatabaseHelper().database;
    return await db.delete(TABLE_NAME);
  }


  Future<String?> getFirstUserID() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      UserMasterTable.TABLE_NAME,
      columns: [UserMasterTable.pUserID],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first[UserMasterTable.pUserID] as String;
    }
    return null;
  }


}
