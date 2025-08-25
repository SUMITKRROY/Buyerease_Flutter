import 'package:buyerease/config/api_route.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/database/table/qr_feedback_hdr_table.dart';
import 'package:buyerease/database/table/qr_po_item_dtl_table.dart';
import 'package:buyerease/services/poitemlist/po_item_dtl_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

import '../../model/inspection_model.dart';
import '../../utils/gen_utils.dart';

import 'get_data_handler.dart';
import 'ItemInspectionDetail/ItemInspectionDetailHandler.dart';

class InspectionListHandler {
  static const String TAG = "InspectionListHandler";

  static Future<bool> updatePOItemhdr(
      context, InspectionModal inspectionModal) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> contentValues = {
        "VendorContact": inspectionModal.vendorContact,
        "ArrivalTime": inspectionModal.arrivalTime,
        "InspStartTime": inspectionModal.inspStartTime,
        "CompleteTime": inspectionModal.completeTime,
        "InspectionLevel": inspectionModal.inspectionLevel,
        "QLMajor": inspectionModal.qlMajor,
        "QLMinor": inspectionModal.qlMinor,
        "QLMajorDescr": inspectionModal.qlMajorDescr,
        "QLMinorDescr": inspectionModal.qlMinorDescr,
        "Status": inspectionModal.status,
        "recDt": ApiRoute.getCurrentDate(),
        "AcceptedDt": ApiRoute.getCurrentDate(),
        "Comments": inspectionModal.comments,
        "InspectionDt": inspectionModal.inspectionDt,
        "ProductionStatusRemark": inspectionModal.productionStatusRemark,
      };

      int rows = await db.update(
        "QRFeedbackhdr",
        contentValues,
        where: "pRowID = ?",
        whereArgs: [inspectionModal.pRowID],
      );

      if (rows == 0) {
        developer.log("QRFeedbackhdr table NOT UPDATE................",
            name: TAG);
      } else {
        developer.log("QRFeedbackhdr type update result................$rows",
            name: TAG);
      }
      await db.close();
      return true;
    } catch (e) {
      developer.log("Exception to inserting QRFeedbackhdr: ${e.toString()}",
          name: TAG);
      return false;
    }
  }

  static Future<List<InspectionModal>> getInspectionList(
      context, String? searchStr) async {
    List<InspectionModal> inspectionArrayList = [];
    try {
      bool columnExists = await GenUtils.columnExistsInTable(
          table: "QRFeedbackhdr", columnToCheck: "IsSynced");
      if (!columnExists) {
        developer.log(" not column found IsSynced so alter execute as INTEGER",
            name: TAG);
        await GetDataHandler.handleToAlterAsIn("QRFeedbackhdr", "IsSynced");
      }
      final db = await DatabaseHelper().database;

      String query = '''SELECT * FROM  QRFeedbackhdr"
           Where pRowID not in (select pRowID from QRFeedbackhdr where status in (20,40,45,50,60,65)
           and Datetime(recDt) <= DateTime(IFNULL(Last_Sync_Dt,'1900-01-01 00:00:00'))) and IsSynced=0
           ''';

      if (searchStr != null && searchStr.isNotEmpty) {
        query += " and ( ${QRFeedbackHdrTable.pRowID} like '%$searchStr%' ";
        query +=
            " or ${QRFeedbackHdrTable.pRowID} in ( select ${QRPOItemDtlTable.colQRHdrID} from $QRPOItemDtlTable where ${QRPOItemDtlTable.colPONO} like '%$searchStr%') ";
        query +=
            " or pRowID in ( select QRHdrID from QRPOItemDtl where CustomerItemRef like '%$searchStr%')) ";
      }
      query += " order by InspectionDt desc";

      developer.log("get update query for get inspection list $query",
          name: TAG);
      List<Map<String, dynamic>> result = await db.rawQuery(query);

      for (var row in result) {
        InspectionModal inspectionModal = InspectionModal();
        inspectionModal.pRowID = row["pRowID"];
        inspectionModal.customer = row["Customer"];
        inspectionModal.vendor = row["Vendor"];
        inspectionModal.vendorContact = row["VendorContact"];
        inspectionModal.vendorAddress = row["FactoryAddress"];
        inspectionModal.inspectionDt = row["InspectionDt"];
        inspectionModal.activity = row["Activity"];
        inspectionModal.activityID = row["ActivityID"];
        inspectionModal.qr = row["QR"];
        inspectionModal.inspector = row["Inspector"];
        inspectionModal.arrivalTime = row["ArrivalTime"];
        inspectionModal.inspStartTime = row["InspStartTime"];
        inspectionModal.completeTime = row["CompleteTime"];
        inspectionModal.inspectionLevel = row["InspectionLevel"];
        inspectionModal.qlMajor = row["QLMajor"];
        inspectionModal.qlMinor = row["QLMinor"];
        inspectionModal.qlMajorDescr = row["QLMajorDescr"];
        inspectionModal.qlMinorDescr = row["QLMinorDescr"];
        inspectionModal.status = row["Status"];
        inspectionModal.recDt = row["recDt"];
        inspectionModal.acceptedDt = row["AcceptedDt"];
        inspectionModal.comments = row["Comments"];
        inspectionModal.inspectionDt = row["InspectionDt"];
        inspectionModal.factory = row["Factory"];
        inspectionModal.productionStatusRemark = row["ProductionStatusRemark"];
        inspectionModal.aqlFormula = row["AQLFormula"];

        List<String> itemIdlists =
            await POItemDtlHandler.getItemIdList(inspectionModal.pRowID!);
        developer.log("itemlist: $itemIdlists", name: TAG);
        if (itemIdlists.isNotEmpty) {
          String str = "";
          for (int j = 0; j < itemIdlists.length; j++) {
            if (itemIdlists.length == 1) {
              str = itemIdlists[j];
            } else {
              if (j == 0) {
                str = itemIdlists[j];
              } else {
                str = "$str, ${itemIdlists[j]}";
              }
            }
          }
          inspectionModal.itemListId = str;
        }

        List<String> list =
            await POItemDtlHandler.getPOList(inspectionModal.pRowID!);
        if (list.isNotEmpty) {
          String str = "";
          for (int j = 0; j < list.length; j++) {
            if (list.length == 1) {
              str = list[j];
            } else {
              if (j == 0) {
                str = list[j];
              } else {
                str = "$str, ${list[j]}";
              }
            }
          }
          inspectionModal.poListed = str;
        }

        List<int> listImportant = await ItemInspectionDetailHandler.isImportant(
            qrHdrId: inspectionModal.pRowID!, qrPoItemHdrId: '');
        if (listImportant.isNotEmpty) {
          bool isFounded = false;
          for (int p = 0; p < listImportant.length; p++) {
            if (listImportant[p] == 1) {
              isFounded = true;
              break;
            }
          }
          if (isFounded) {
            inspectionModal.isImportant = 1;
          }
        }

        inspectionArrayList.add(inspectionModal);
      }

      developer.log(
          " count of founded QRFeedbackhdr ${inspectionArrayList.length}",
          name: TAG);
    } catch (e) {
      developer.log("Error in getInspectionList: ${e.toString()}", name: TAG);
    }
    return inspectionArrayList;
  }

  static Future<List<String>> getItemList(String pRowID) async {
    return await POItemDtlHandler.getItemIdList(pRowID);
  }

  static Future<List<InspectionModal>> getSyncedInspectionList(
      context, String? searchStr) async {
    List<InspectionModal> inspectionArrayList = [];
    try {
      bool columnExists = await GenUtils.columnExistsInTable(
          table: "QRFeedbackhdr", columnToCheck: "IsSynced");
      if (!columnExists) {
        developer.log(" not column found IsSynced so alter execute as INTEGER",
            name: TAG);
        await GetDataHandler.handleToAlterAsIn("QRFeedbackhdr", "IsSynced");
      }

      Database database = await DatabaseHelper().database;

      String query = "SELECT * FROM QRFeedbackhdr"
          " Where IsSynced=1 ";

      if (searchStr != null && searchStr.isNotEmpty) {
        query += " and ( pRowID like '%$searchStr%' ";
        query +=
            " or pRowID in ( select QRHdrID from QRPOItemDtl where PONO like '%$searchStr%') ";
        query +=
            " or pRowID in ( select QRHdrID from QRPOItemDtl where CustomerItemRef like '%$searchStr%')) ";
      }
      query += " order by InspectionDt desc";

      developer.log("get update query for get synced inspection list $query",
          name: TAG);
      List<Map<String, dynamic>> result = await database.rawQuery(query);
developer.log("results is ${result}");
      for (var row in result) {
        InspectionModal inspectionModal = InspectionModal();
        inspectionModal.pRowID = row["pRowID"];
        inspectionModal.customer = row["Customer"];
        inspectionModal.vendor = row["Vendor"];
        inspectionModal.vendorContact = row["VendorContact"];
        inspectionModal.vendorAddress = row["FactoryAddress"];
        inspectionModal.inspectionDt = row["InspectionDt"];
        inspectionModal.activity = row["Activity"];
        inspectionModal.activityID = row["ActivityID"];
        inspectionModal.qr = row["QR"];
        inspectionModal.inspector = row["Inspector"];
        inspectionModal.arrivalTime = row["ArrivalTime"];
        inspectionModal.inspStartTime = row["InspStartTime"];
        inspectionModal.completeTime = row["CompleteTime"];
        inspectionModal.inspectionLevel = row["InspectionLevel"];
        inspectionModal.qlMajor = row["QLMajor"];
        inspectionModal.qlMinor = row["QLMinor"];
        inspectionModal.qlMajorDescr = row["QLMajorDescr"];
        inspectionModal.qlMinorDescr = row["QLMinorDescr"];
        inspectionModal.status = row["Status"];
        inspectionModal.recDt = row["recDt"];
        inspectionModal.acceptedDt = row["AcceptedDt"];
        inspectionModal.comments = row["Comments"];
        inspectionModal.inspectionDt = row["InspectionDt"];
        inspectionModal.factory = row["Factory"];
        inspectionModal.productionStatusRemark = row["ProductionStatusRemark"];
        inspectionModal.aqlFormula = row["AQLFormula"];

        List<String> itemIdlist =
            await POItemDtlHandler.getItemIdList(inspectionModal.pRowID!);
        developer.log("itemlistid close: $itemIdlist", name: TAG);

        List<String> itemIdClosedlists =
            await POItemDtlHandler.getPOList(inspectionModal.pRowID!);
        developer.log("ItemIdClosedlists: $itemIdClosedlists", name: TAG);

        if (itemIdlist.isNotEmpty) {
          String str = "";
          for (int j = 0; j < itemIdlist.length; j++) {
            if (itemIdlist.length == 1) {
              str = itemIdlist[j];
            } else {
              if (j == 0) {
                str = itemIdlist[j];
              } else {
                str = "$str, ${itemIdlist[j]}";
              }
            }
          }
          inspectionModal.itemListId = str;
        }

        if (itemIdClosedlists.isNotEmpty) {
          String str = "";
          for (int j = 0; j < itemIdClosedlists.length; j++) {
            if (itemIdClosedlists.length == 1) {
              str = itemIdClosedlists[j];
            } else {
              if (j == 0) {
                str = itemIdClosedlists[j];
              } else {
                str = "$str, ${itemIdClosedlists[j]}";
              }
            }
          }
          inspectionModal.poListed = str;
        }

        inspectionArrayList.add(inspectionModal);
      }
      await database.close();
      developer.log(
          " count of synced founded QRFeedbackhdr ${inspectionArrayList.length}",
          name: TAG);
    } catch (e) {
      developer.log("Error in getSyncedInspectionList: ${e.toString()}",
          name: TAG);
    }
    return inspectionArrayList;
  }

  static Future<void> deleteInspectionRecordFromAllTAble(
      context, String pRowID) async {
    try {
      Database database = await DatabaseHelper().database;

      List<String> queries = [
        "Update QRPOItemHdr Set DefaultImageRowID = NULL Where QRHdrID = '$pRowID';",
        "Delete From QRFindings Where QRHdrID = '$pRowID';",
        "Delete From QRQualiltyParameterFields Where QRHdrID = '$pRowID';",
        "Delete From QRPOItemFitnessCheck Where QRHdrID = '$pRowID';",
        "Delete From QRProductionStatus Where QR HDRID = '$pRowID';",
        "Delete From QREnclosure Where ContextID = '$pRowID';",
        "Delete From QRPOIntimationDetails Where QRHdrID = '$pRowID';",
        "Delete From QRPOItemDtl_ItemMeasurement Where QRHdrID = '$pRowID';",
        "Delete From QRInspectionHistory Where RefQRHdrID = '$pRowID';",
        "Delete From QRAuditBatchDetails Where QRHdrID = '$pRowID';",
        "Delete From Enclosures Where QRHdrID = '$pRowID';",
        "Delete From QRPOItemDtl_Image Where QRHdrID = '$pRowID';",
        "Delete From QRPOItemdtl Where QRHdrID = '$pRowID';",
        "Delete From QRPOItemHdr Where QRHdrID = '$pRowID';",
        "Delete From QRFeedbackhdr Where pRowID='$pRowID';"
      ];

      for (String query in queries) {
        developer.log("Executing: $query", name: TAG);
        await database.execute(query);
      }

      await database.close();
    } catch (e) {
      developer.log(
          "Error in deleteInspectionRecordFromAllTAble: ${e.toString()}",
          name: TAG);
    }
  }

  static Future<int> getPackagingAppearanceImageCount(
      context, String pRowID) async
  {
    int count = 0;
    try {
      Database database = await DatabaseHelper().database;

      String query = "SELECT COUNT(*) FROM QREn_closure WHERE ContextID = ? "
          "AND ContextType = 'PackagingAppearance'";

      developer.log("Image count query: $query with pRowID: $pRowID",
          name: TAG);

      List<Map<String, dynamic>> result =
          await database.rawQuery(query, [pRowID]);

      if (result.isNotEmpty) {
        count = result[0]["COUNT(*)"] as int;
        developer.log("Retrieved image count: $count", name: TAG);
      } else {
        developer.log("No results found for image count query", name: TAG);
      }

      await database.close();
    } catch (e) {
      developer.log(
          "Error getting packaging appearance image count: ${e.toString()}",
          name: TAG);
    }

    return count;
  }

  static Future<List<String>> getPackagingAppearanceImages(
      context, String pRowID) async {
    List<String> imagePaths = [];
    try {
      Database database = await DatabaseHelper().database;

      String query = "SELECT FilePath FROM QREnclosure WHERE ContextID = ? "
          "AND ContextType = 'PackagingAppearance'";

      List<Map<String, dynamic>> result =
          await database.rawQuery(query, [pRowID]);

      for (var row in result) {
        String? path = row["FilePath"];
        if (path != null && path.isNotEmpty) {
          imagePaths.add(path);
        }
      }

      await database.close();
    } catch (e) {
      developer.log(
          "Error getting packaging appearance images: ${e.toString()}",
          name: TAG);
    }

    return imagePaths;
  }
}
