import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:buyerease/database/table/enclosures.dart';
import 'package:buyerease/database/table/genmst.dart';
import 'package:buyerease/database/table/insp_level_detail_table.dart';
import 'package:buyerease/database/table/insp_level_header_table.dart';
import 'package:buyerease/database/table/qr_audit_batch_details_table.dart';
import 'package:buyerease/database/table/qr_feedback_hdr_table.dart';
import 'package:buyerease/database/table/qr_inspection_history_table.dart';
import 'package:buyerease/database/table/qr_po_intimation_details_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_item_measurement_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/database/table/qr_po_item_hdr_table.dart';
import 'package:buyerease/database/table/quality_level_dtl_table.dart';
import 'package:buyerease/database/table/size_quantity_table.dart';
import 'package:buyerease/database/table/test_report_table.dart';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../database/database_helper.dart';
import '../../database/table/gen_quality_parameter_product_map_table.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../../database/table/quality_level_table.dart';
import '../../database/table/sysdata22_table.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../master_repo.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  SyncCubit() : super(SyncInitial());

  Future<void> sync({
    required String user,
    required String deviceId,
    required String deviceIP,
    required String hddSerialNo,
    required String deviceType,
    required String location,
  }) async {
    emit(SyncLoading());

    try {
      final response = await MasterRepo().getSyncList(
        user: user,
        deviceId: deviceId,
        deviceIP: deviceIP,
        hddSerialNo: hddSerialNo,
        deviceType: deviceType,
        location: location,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['Message'].toString().toLowerCase() == 'success') {
          // Retrieve the data tables from the response
          Map<String, dynamic> dataTables = responseData["Data"][0];
          final tableProcessors = <String, Function(Map<String, dynamic>)>{
            FEnumerations.tableQrpoItemHdr: (data) => QRPOItemHdrTable().insert(data),
            FEnumerations.tableQrpoItemDtl: (data) => QRPOItemDtlTable().insert(data),
            FEnumerations.tableQrpoItemDtlImage: (data) => _processQrpoItemDtlImage([data]),
 /*         // FEnumerations.tableQrpoIntimationDetails: (data) => QrPoIntimationDetailsTable().insert(data),*/
            FEnumerations.tableGenMst: (data) => GenMst().insert(data),
            FEnumerations.tableSysData22: (data) => Sysdata22Table().insert(data),
            FEnumerations.tableQualityLevel: (data) => QualityLevelTable().insert(data),
            FEnumerations.tableQualityLevelDtl: (data) => QualityLevelDtlTable().insert(data),
            FEnumerations.tableInsplvlHdr: (data) => InspLevelHeaderTable().insert(data),
            FEnumerations.tableInspLvlDtl: (data) => InspLvlDtlTable().insert(data),
            FEnumerations.tableEnclosures: (data) => Enclosures().insert(data),
            FEnumerations.tableQRInspectionHistory: (data) => QrInspectionHistoryTable().insert(data),
            FEnumerations.tableTestReport: (data) => TestReportTable().insert(data),
            // FEnumerations.tableUserMasterUpdateCriticalAllowed: (data) => User().insert(data),
            FEnumerations.tableItemMeasurement: (data) => QrPoItemDtlItemMeasurementTable().insert(data),
            FEnumerations.tableAuditBatchDetails: (data) => QrAuditBatchDetailsTable().insert(data),
            FEnumerations.tableSizeQuantity: (data) => SizeQuantityTable().insert(data),
            FEnumerations.tableGenQualityParameterProductMap: (data) => GenQualityParameterProductMapTable().insert(data),
            FEnumerations.tableQrFeedback: (data) => QRFeedbackHdrTable().insert(data),
            // etc.
          };


          for (var table in dataTables.entries) {
            String tableName = table.key;
            dynamic tableData = table.value;

            if (tableData == null || tableData is! List || tableData.isEmpty) {
              developer.log("Skipping $tableName: No data");
              continue;
            }

            print("Processing $tableName: ${tableData.length} ");
            // print("Processing tablename ${tableName}");
            // print("Processing tableData  ${tableData}");

            // Custom handling for QrpoItemDtlImage
            if (tableName == FEnumerations.tableQrpoItemDtlImage) {
              // print("Processing tablename ${tableName}");
              // print("Processing tableData  ${tableData}");
              _processQrpoItemDtlImage(tableData); // <-- send the full list
              continue;
            }

            // Custom handling for QrpoItemDtlImage
            if (tableName == FEnumerations.tableQrpoIntimationDetails) {
              print("Processing tablename ${tableName}");
              print("Processing tableData  ${tableData}");
              handleQRPOIntimationDetails(tableData); // <-- send the full list
              continue;
            }

            if (tableProcessors.containsKey(tableName)) {
              for (var row in tableData) {
                if (row is Map<String, dynamic>) {
                  tableProcessors[tableName]!(row);
                }
              }
            } else {
              print("Unhandled table: $tableName");
            }
          }

          emit(SyncSuccess());  // Emit the success state with the processed data
        }
        else {
          emit(SyncFailure(responseData['Message'].toString()));  // Emit failure if the response message is not "success"
        }
      } else {
        emit(SyncFailure('Server Error: ${response.statusCode}'));  // Handle server error
      }
    } catch (e) {
      emit(SyncFailure(e.toString()));  // Emit failure if an exception is thrown
    }
  }
}

void _processQrpoItemDtlImage(List<dynamic> dataList) async {
  developer.log("Processing tableData >>>>> $dataList");

  // Generate a batch of unique IDs first
  List<String> pkList = await ItemInspectionDetailHandler().generatePKBatch(
    FEnumerations.tableNameItemMeasurement,
    dataList.length,
  );

  int index = 0;

  for (var row in dataList) {
    if (row is Map<String, dynamic>) {
      try {
        final newRow = Map<String, dynamic>.from(row);

        newRow['be_pRowID'] = row['pRowID'];
        newRow['pRowID'] = pkList[index++];

        print("Inserting: ${newRow['pRowID']}");
        await QrPoItemDtlImageTable().insert(newRow);
      } catch (e, stackTrace) {
        print("Insert failed for $row\nError: $e\n$stackTrace");
      }
    } else {
      print("Invalid row (not Map): $row");
    }
  }





}




Future<void> handleQRPOIntimationDetails(List<dynamic> jsonArrayQRPOIntimationDetails) async {
  if (jsonArrayQRPOIntimationDetails.isNotEmpty) {
    for (var item in jsonArrayQRPOIntimationDetails) {
      if (item is Map<String, dynamic>) {
        await updateOrInsertQRPOIntimationDetails(item);
      } else {
        debugPrint("QRPOIntimationDetails item is null or not a JSON object");
      }
    }
  }
}

Future<int> updateOrInsertQRPOIntimationDetails(Map<String, dynamic> json) async {
  final db = await DatabaseHelper().database;

  final Map<String, dynamic> contentValues = {};

  try {
    // Process all fields synchronously first
    for (String key in json.keys) {
      if (key == 'pRowID') {
        // Always generate a new pRowID for the current record
        String newPRowID = await ItemInspectionDetailHandler().generatePK("QRPOIntimationDetails");
        contentValues[key] = newPRowID;
        debugPrint("Generated new pRowID: $newPRowID");
      } else if (key == 'BE_pRowID') {
        // Store the original pRowID as BE_pRowID for reference
        contentValues[key] = json[key]?.toString();
      } else {
        contentValues[key] = json[key]?.toString();
      }
    }
    
    // Ensure pRowID is always set
    if (!contentValues.containsKey('pRowID') || contentValues['pRowID'] == null || contentValues['pRowID'].toString().isEmpty) {
      String newPRowID = await ItemInspectionDetailHandler().generatePK("QRPOIntimationDetails");
      contentValues['pRowID'] = newPRowID;
      debugPrint("Generated fallback pRowID: $newPRowID");
    }
    
    // Ensure BE_pRowID is set if original pRowID exists
    if (json['pRowID'] != null && json['pRowID'].toString().isNotEmpty) {
      contentValues['BE_pRowID'] = json['pRowID'].toString();
    }
    
    // Validate that pRowID is not null or empty
    if (contentValues['pRowID'] == null || contentValues['pRowID'].toString().isEmpty) {
      debugPrint("ERROR: pRowID is still null or empty after generation!");
      return 0;
    }
    
  } catch (e) {
    debugPrint("JSON parsing error: $e");
    return 0;
  }

  int mStatus = 0;
  developer.log("Processing QRPOIntimationDetails - Original: $json");
  developer.log("Processed contentValues: $contentValues");
  developer.log("Final pRowID: ${contentValues['pRowID']}");
  
  try {
    // First try to update using the original pRowID if it exists
    int rows = 0;
    
    if (json['pRowID'] != null && json['pRowID'].toString().isNotEmpty) {
      // Try to update existing record using original pRowID
      debugPrint("Attempting to update existing record with original pRowID: ${json['pRowID']}");
      rows = await db.update(
        'QRPOIntimationDetails',
        contentValues,
        where: "pRowID = ?",
        whereArgs: [json['pRowID']],
      );
      debugPrint("Update rows affected: $rows");
    } else if (contentValues["QRHdrID"] != null && contentValues["EmailID"] != null) {
      // Try to update using QRHdrID and EmailID combination
      debugPrint("Attempting to update using QRHdrID: ${contentValues['QRHdrID']} and EmailID: ${contentValues['EmailID']}");
      rows = await db.update(
        'QRPOIntimationDetails',
        contentValues,
        where: "QRHdrID = ? AND EmailID = ?",
        whereArgs: [
          contentValues["QRHdrID"],
          contentValues["EmailID"]
        ],
      );
      debugPrint("Update rows affected: $rows");
    }

    if (rows == 0) {
      // No existing record found, insert new one
      debugPrint("No existing record found, inserting new record with pRowID: ${contentValues['pRowID']}");
      int status = await db.insert('QRPOIntimationDetails', contentValues);
      if (status > 0) {
        mStatus = 2; // Inserted
        debugPrint("Insert QRPOIntimationDetails successful with pRowID: ${contentValues['pRowID']}");
      } else {
        debugPrint("Insert QRPOIntimationDetails failed - insert returned: $status");
      }
    } else {
      mStatus = 1; // Updated
      debugPrint("Update QRPOIntimationDetails successful with pRowID: ${contentValues['pRowID']}");
    }
  } catch (e, stackTrace) {
    debugPrint("Database operation failed: $e");
    debugPrint("Stack trace: $stackTrace");
    debugPrint("ContentValues that failed: $contentValues");
    // Uncomment if using FirebaseCrashlytics:
    // FirebaseCrashlytics.instance.recordError(e, stackTrace);
  }

  return mStatus;
}