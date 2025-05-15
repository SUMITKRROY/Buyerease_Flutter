import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class QRFeedbackHdrTable {
  static const String TABLE_NAME = "QRFeedbackhdr";

  // Column names
  static const String pRowID = "pRowID";
  static const String locID = "LocID";
  static const String activityID = "ActivityID";
  static const String customerID = "CustomerID";
  static const String vendorID = "VendorID";
  static const String companyID = "CompanyID";
  static const String qrID = "QRID";
  static const String poType = "POType";
  static const String inspectorID = "InspectorID";
  static const String inspectionDt = "InspectionDt";
  static const String vendorAddress = "VendorAddress";
  static const String vendorContact = "VendorContact";
  static const String inspectionLevel = "InspectionLevel";
  static const String qlMajor = "QLMajor";
  static const String qlMinor = "QLMinor";
  static const String sampleCodeID = "SampleCodeID";
  static const String availableQty = "AvailableQty";
  static const String allowedInspectionQty = "AllowedInspectionQty";
  static const String inspectedQty = "InspectedQty";
  static const String acceptedQty = "AcceptedQty";
  static const String shortStockQty = "ShortStockQty";
  static const String cartonsPacked = "CartonsPacked";
  static const String allowedCartonInspection = "AllowedCartonInspection";
  static const String cartonsInspected = "CartonsInspected";
  static const String critialDefectsAllowed = "CritialDefectsAllowed";
  static const String majorDefectsAllowed = "MajorDefectsAllowed";
  static const String minorDefectsAllowed = "MinorDefectsAllowed";
  static const String criticalDefect = "CriticalDefect";
  static const String majorDefect = "MajorDefect";
  static const String minorDefect = "MinorDefect";
  static const String status = "Status";
  static const String statusComments = "StatusComments";
  static const String reinspectionDt = "ReinspectionDt";
  static const String poqaStatusID = "POQAStatusID";
  static const String poqaStatusChangeID = "POQAStatusChangeID";
  static const String poqaStatusChangeDescr = "POQAStatusChangeDescr";
  static const String qrParamFormat = "QRParamFormat";
  static const String aqlFormula = "AQLFormula";
  static const String autoFillQty = "AutoFillQty";
  static const String autoFillAcceptedQty = "AutoFillAcceptedQty";
  static const String autoFillCarton = "AutoFillCarton";
  static const String defectListType = "DefectListType";
  static const String rptType = "RptType";
  static const String rptFormat = "RptFormat";
  static const String rptDefectFormat = "RptDefectFormat";
  static const String typeofInspection = "TypeofInspection";
  static const String inspectionPlan = "InspectionPlan";
  static const String samplingPlan = "SamplingPlan";
  static const String inspectionMode = "InspectionMode";
  static const String inspectionVersion = "InspectionVersion";
  static const String vendorAcceptanceOn = "VendorAcceptanceOn";
  static const String vendorAcceptanceComment = "VendorAcceptanceComment";
  static const String vendorAcceptanceIntimation = "VendorAcceptanceIntimation";
  static const String vendorAcceptancePrintFormate = "VendorAcceptancePrintFormate";
  static const String vendorAcceptanceHostAddress = "VendorAcceptanceHostAddress";
  static const String vendorAppectanceByID = "VendorAppectanceByID";
  static const String vendorAppectanceByName = "VendorAppectanceByName";
  static const String vendorAppectanceByEmail = "VendorAppectanceByEmail";
  static const String arrivalTime = "ArrivalTime";
  static const String inspStartTime = "InspStartTime";
  static const String completeTime = "CompleteTime";
  static const String invoiceNo = "InvoiceNo";
  static const String nextActivityID = "NextActivityID";
  static const String nextActivityPlanDate = "NextActivityPlanDate";
  static const String recApproveDt = "recApproveDt";
  static const String recApproveUser = "recApproveUser";
  static const String recAddDt = "recAddDt";
  static const String recEnable = "recEnable";
  static const String recDirty = "recDirty";
  static const String recAddUser = "recAddUser";
  static const String recUser = "recUser";
  static const String recDt = "recDt";
  static const String ediDt = "ediDt";
  static const String customer = "Customer";
  static const String vendor = "Vendor";
  static const String inspector = "Inspector";
  static const String typeofInspectionDescr = "TypeofInspectionDescr";
  static const String inspectionLevelDescr = "InspectionLevelDescr";
  static const String qlMajorDescr = "QLMajorDescr";
  static const String qlMinorDescr = "QLMinorDescr";
  static const String qr = "QR";
  static const String activity = "Activity";
  static const String sampleCodeDescr = "SampleCodeDescr";
  static const String factoryAddress = "FactoryAddress";
  static const String acceptedDt = "AcceptedDt";
  static const String factory = "Factory";
  static const String comments = "Comments";
  static const String lastSyncDt = "Last_Sync_Dt";
  static const String productionCompletionDt = "ProductionCompletionDt";
  static const String productionStatusRemark = "ProductionStatusRemark";
  static const String isSynced = "IsSynced";
  static const String syncStatus = "Sync_Status";
  static const String othIntimationQRHdrID = "OthIntimationQRHdrID";

  // SQL to create the table
  static const String CREATE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $pRowID TEXT PRIMARY KEY,
      $locID TEXT,
      $activityID TEXT,
      $customerID TEXT,
      $vendorID TEXT,
      $companyID TEXT,
      $qrID TEXT,
      $poType TEXT,
      $inspectorID TEXT,
      $inspectionDt TEXT,
      $vendorAddress TEXT,
      $vendorContact TEXT,
      $inspectionLevel TEXT,
      $qlMajor TEXT,
      $qlMinor TEXT,
      $sampleCodeID TEXT,
      $availableQty REAL DEFAULT 0,
      $allowedInspectionQty REAL DEFAULT 0,
      $inspectedQty REAL DEFAULT 0,
      $acceptedQty REAL DEFAULT 0,
      $shortStockQty REAL DEFAULT 0,
      $cartonsPacked INTEGER DEFAULT 0,
      $allowedCartonInspection INTEGER DEFAULT 0,
      $cartonsInspected INTEGER DEFAULT 0,
      $critialDefectsAllowed INTEGER DEFAULT 0,
      $majorDefectsAllowed INTEGER DEFAULT 0,
      $minorDefectsAllowed INTEGER DEFAULT 0,
      $criticalDefect INTEGER DEFAULT 0,
      $majorDefect INTEGER DEFAULT 0,
      $minorDefect INTEGER DEFAULT 0,
      $status TEXT,
      $statusComments TEXT,
      $reinspectionDt TEXT,
      $poqaStatusID TEXT,
      $poqaStatusChangeID TEXT,
      $poqaStatusChangeDescr TEXT,
      $qrParamFormat INTEGER DEFAULT 0,
      $aqlFormula INTEGER DEFAULT 0,
      $autoFillQty INTEGER DEFAULT 1,
      $autoFillAcceptedQty INTEGER DEFAULT 1,
      $autoFillCarton INTEGER DEFAULT 1,
      $defectListType INTEGER DEFAULT 0,
      $rptType INTEGER DEFAULT 0,
      $rptFormat INTEGER DEFAULT 0,
      $rptDefectFormat INTEGER DEFAULT 0,
      $typeofInspection TEXT,
      $inspectionPlan TEXT,
      $samplingPlan TEXT,
      $inspectionMode INTEGER DEFAULT 0,
      $inspectionVersion INTEGER DEFAULT 0,
      $vendorAcceptanceOn TEXT,
      $vendorAcceptanceComment TEXT,
      $vendorAcceptanceIntimation TEXT,
      $vendorAcceptancePrintFormate TEXT,
      $vendorAcceptanceHostAddress TEXT,
      $vendorAppectanceByID TEXT,
      $vendorAppectanceByName TEXT,
      $vendorAppectanceByEmail TEXT,
      $arrivalTime TEXT,
      $inspStartTime TEXT,
      $completeTime TEXT,
      $invoiceNo TEXT,
      $nextActivityID TEXT,
      $nextActivityPlanDate TEXT,
      $recApproveDt TEXT,
      $recApproveUser TEXT,
      $recAddDt TEXT,
      $recEnable INTEGER DEFAULT 1,
      $recDirty INTEGER DEFAULT 1,
      $recAddUser TEXT,
      $recUser TEXT,
      $recDt TEXT,
      $ediDt TEXT,
      $customer TEXT,
      $vendor TEXT,
      $inspector TEXT,
      $typeofInspectionDescr TEXT,
      $inspectionLevelDescr TEXT,
      $qlMajorDescr TEXT,
      $qlMinorDescr TEXT,
      $qr TEXT,
      $activity TEXT,
      $sampleCodeDescr TEXT,
      $factoryAddress TEXT,
      $acceptedDt TEXT,
      $factory TEXT,
      $comments TEXT,
      $lastSyncDt TEXT,
      $productionCompletionDt TEXT,
      $productionStatusRemark TEXT,
      $isSynced INTEGER DEFAULT 0,
      $syncStatus INTEGER DEFAULT 0,
      $othIntimationQRHdrID TEXT
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