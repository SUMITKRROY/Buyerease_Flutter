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
import 'package:meta/meta.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../../database/table/quality_level_table.dart';
import '../../database/table/sysdata22_table.dart';
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
            FEnumerations.tableQrpoItemDtlImage: (data) => QrPoItemDtlImageTable().insert(data),
            FEnumerations.tableQrpoIntimationDetails: (data) => QrPoIntimationDetailsTable().insert(data),
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
            print("Processing tablename ${tableName}");
            print("Processing tableData  ${tableData}");

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
