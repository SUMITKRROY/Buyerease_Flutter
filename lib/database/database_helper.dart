import 'package:buyerease/database/table/defect_applicable_matrix.dart';
import 'package:buyerease/database/table/defect_master.dart';
import 'package:buyerease/database/table/enclosures.dart';
import 'package:buyerease/database/table/genmst.dart';
import 'package:buyerease/database/table/insp_level_detail_table.dart';
import 'package:buyerease/database/table/insp_level_header_table.dart';
import 'package:buyerease/database/table/qr_audit_batch_details_table.dart';
import 'package:buyerease/database/table/qr_enclosure_table.dart';
import 'package:buyerease/database/table/qr_findings_table.dart';
import 'package:buyerease/database/table/qr_inspection_history_table.dart';
import 'package:buyerease/database/table/qr_po_intimation_details_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_image_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_item_measurement_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_material_inspection_dtl_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_on_site_test_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_pkg_app_details_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_prod_specs_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_sample_purpose_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/database/table/qr_po_item_fitness_check_table.dart';
import 'package:buyerease/database/table/qr_po_item_hdr_table.dart';
import 'package:buyerease/database/table/qr_po_item_more_param_dtl_save_table.dart';
import 'package:buyerease/database/table/qr_production_status_table.dart';
import 'package:buyerease/database/table/qr_quality_parameter_fields_table.dart';
import 'package:buyerease/database/table/quality_level_table.dart';
import 'package:buyerease/database/table/quality_level_dtl_table.dart';
import 'package:buyerease/database/table/size_quantity_table.dart';
import 'package:buyerease/database/table/sub_team_dtl_table.dart';
import 'package:buyerease/database/table/sub_team_hdr_table.dart';
import 'package:buyerease/database/table/sync_info_table.dart';
import 'package:buyerease/database/table/sysdata22_table.dart';
import 'package:buyerease/database/table/test_table.dart';
import 'package:buyerease/database/table/test_report_table.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/database/table/qr_feedback_hdr_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DatabaseHelper {
  // database name
  static const _databaseName = "OffLineInspectionDB.db";
  // database version
  static const _databaseVersion = 1;
// Singleton pattern
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseHelper;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, _databaseName);

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: _databaseVersion,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DefectApplicableMatrix.CREATE);
    await db.execute(DefectMaster.CREATE);
    await db.execute(Enclosures.CREATE);
    await db.execute(GenMst.CREATE);
    await db.execute(InspLvlDtlTable.CREATE);
    await db.execute(InspLevelHeaderTable.CREATE);
    await db.execute(QrAuditBatchDetailsTable.CREATE);
    await db.execute(QrEnclosureTable.CREATE);
    await db.execute(QrFindingsTable.CREATE);
    await db.execute(QrInspectionHistoryTable.CREATE);
    await db.execute(QrPoIntimationDetailsTable.CREATE);
    await db.execute(QrPoItemDtlImageTable.CREATE);
    await db.execute(QrPoItemDtlItemMeasurementTable.CREATE);
    await db.execute(QrPoItemDtlMaterialInspectionDtlTable.CREATE);
    await db.execute(QRPOItemDtlOnSiteTestTable.CREATE);
    await db.execute(QrPoItemDtlPkgAppDetailsTable.CREATE);
    await db.execute(QRPOItemDtlProdSpecsTable.CREATE);
    await db.execute(QRPOItemDtlSamplePurposeTable.CREATE);
    await db.execute(QRPOItemDtlTable.CREATE);
    await db.execute(QRPOItemFitnessCheckTable.CREATE);
    await db.execute(QRPOItemHdrTable.CREATE);
    await db.execute(QRPOItemMoreParamDtlSaveTable.CREATE);
    await db.execute(QRProductionStatusTable.CREATE);
    await db.execute(QRQualityParameterFieldsTable.CREATE);
    await db.execute(QualityLevelTable.CREATE);
    await db.execute(QualityLevelDtlTable.CREATE);
    await db.execute(SizeQuantityTable.CREATE);
    await db.execute(SubTeamDtlTable.CREATE);
    await db.execute(SubTeamHdrTable.CREATE);
    await db.execute(SyncInfoTable.CREATE);
    await db.execute(Sysdata22Table.CREATE);
    await db.execute(TestTable.CREATE);
    await db.execute(TestReportTable.CREATE);
    await db.execute(UserMasterTable.CREATE);
    await db.execute(QRFeedbackHdrTable.CREATE);
  }

  // UPGRADE DATABASE TABLES
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      switch (oldVersion) {
        case 1:
          // you can execute drop table and create table
          //db.execute("ALTER TABLE tb_name ADD COLUMN newCol TEXT");
          break;
      }
    }
  }

  // Delete the database
  static Future<void> deleteDatabase() async {
    // Get the database path
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    // Delete the database
    await   sqflite.deleteDatabase(path);
    print("Database deleted successfully!");
  }

}
