import 'dart:developer' as developer;

import 'package:buyerease/utils/fsl_log.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/database_helper.dart';
import '../../model/inspection_model.dart';
import '../../utils/gen_utils.dart';
import '../get_data_handler.dart';
import '../po_item_dtl_handler.dart';
import 'ItemInspectionDetailHandler.dart';

class InspectionListHandler {
    static const String _logger = "InspectionListHandler";

    static Future<bool> updatePOItemHdr(
        Database db, InspectionModal inspectionModel) async
    {
        try {
            final contentValues = <String, dynamic>{
                "VendorContact": inspectionModel.vendorContact,
                "ArrivalTime": inspectionModel.arrivalTime,
                "InspStartTime": inspectionModel.inspStartTime,
                "CompleteTime": inspectionModel.completeTime,
                "InspectionLevel": inspectionModel.inspectionLevel,
                "QLMajor": inspectionModel.qlMajor,
                "QLMinor": inspectionModel.qlMinor,
                "QLMajorDescr": inspectionModel.qlMajorDescr,
                "QLMinorDescr": inspectionModel.qlMinorDescr,
                "Status": inspectionModel.status,
                "recDt": AppConfig.getCurrentDate(),
                "AcceptedDt": AppConfig.getCurrentDate(),
                "Comments": inspectionModel.comments,
                "InspectionDt": inspectionModel.inspectionDt,
                "ProductionStatusRemark": inspectionModel.productionStatusRemark,
            };

            int rows = await db.update(
                "QRFeedbackhdr",
                contentValues,
                where: "pRowID = ?",
                whereArgs: [inspectionModel.pRowID],
            );

            if (rows == 0) {
                FslLog.e(_logger, "QRFeedbackhdr table NOT UPDATE...");
            } else {
                FslLog.i(_logger, "QRFeedbackhdr type update result: $rows");
            }
        } catch (e) {
            FslLog.e(_logger, "Exception to inserting QRFeedbackhdr: $e");
        }
        return true;
    }

    static Future<List<InspectionModal>> getInspectionList(String? searchStr) async {
        final inspectionArrayList = <InspectionModal>[];
        try {
            final database = await DatabaseHelper().database;

            String query = """
        SELECT * FROM QRFeedbackhdr
        WHERE pRowID NOT IN (
          SELECT pRowID FROM QRFeedbackhdr 
          WHERE status IN (20,40,45,50,60,65)
          AND Datetime(recDt) <= DateTime(IFNULL(Last_Sync_Dt,'1900-01-01 00:00:00'))
        ) AND IsSynced = 0
      """;

            if (searchStr != null && searchStr.isNotEmpty) {
                query += """
          AND (pRowID LIKE '%$searchStr%'
          OR pRowID IN (SELECT QRHdrID FROM QRPOItemDtl WHERE PONO LIKE '%$searchStr%')
          OR pRowID IN (SELECT QRHdrID FROM QRPOItemDtl WHERE CustomerItemRef LIKE '%$searchStr%'))
        """;
            }
            query += " ORDER BY InspectionDt DESC";

            FslLog.i(_logger, "Get inspection list query: $query");
developer.log("this is the data of the query $query");
            final cursor = await database.rawQuery(query);

            for (var row in cursor) {
                final inspectionModel = InspectionModal()
                    ..pRowID = row["pRowID"] as String?
                    ..customer = row["Customer"] as String?
                    ..vendor = row["Vendor"] as String?
                    ..vendorContact = row["VendorContact"] as String?
                    ..vendorAddress = row["FactoryAddress"] as String?
                    ..inspectionDt = row["InspectionDt"] as String?
                    ..activity = row["Activity"] as String?
                    ..activityID = row["ActivityID"] as String?
                    ..qr = row["QR"] as String?
                    ..inspector = row["Inspector"] as String?
                    ..arrivalTime = row["ArrivalTime"] as String?
                    ..inspStartTime = row["InspStartTime"] as String?
                    ..completeTime = row["CompleteTime"] as String?
                    ..inspectionLevel = row["InspectionLevel"] as String?
                    ..qlMajor = row["QLMajor"] as String?
                    ..qlMinor = row["QLMinor"] as String?
                    ..qlMajorDescr = row["QLMajorDescr"] as String?
                    ..qlMinorDescr = row["QLMinorDescr"] as String?
                    ..status = row["Status"] as String?
                    ..recDt = row["recDt"] as String?
                    ..acceptedDt = row["AcceptedDt"] as String?
                    ..comments = row["Comments"] as String?
                    ..factory = row["Factory"] as String?
                    ..productionStatusRemark = row["ProductionStatusRemark"] as String?
                    ..aqlFormula = row["AQLFormula"] as int?;

                final itemIdLists = await POItemDtlHandler.getItemIdList(inspectionModel.pRowID!);
                FslLog.i(_logger, "Item list: $itemIdLists");
                if (itemIdLists.isNotEmpty) {
                    inspectionModel.itemListId = itemIdLists.join(", ");
                }

                final poList = await POItemDtlHandler.getPOList(inspectionModel.pRowID!);
                if (poList.isNotEmpty) {
                    inspectionModel.poListed = poList.join(", ");
                }

                final importantList = await ItemInspectionDetailHandler.isImportant( qrHdrId: inspectionModel.pRowID!, qrPoItemHdrId: '');
                if (importantList.any((i) => i == 1)) {
                    inspectionModel.isImportant = 1;
                }

                inspectionArrayList.add(inspectionModel);
            }

            FslLog.i(_logger, "Count of found QRFeedbackhdr: ${inspectionArrayList.length}");
        } catch (e) {
            FslLog.e(_logger, "Error getting inspection list: $e");
        }
        return inspectionArrayList;
    }

    static Future<List<String>> getItemList(String pRowID) async {
        return POItemDtlHandler.getItemIdList(pRowID);
    }

    static Future<List<InspectionModal>> getSyncedInspectionList(String? searchStr) async {
        final inspectionArrayList = <InspectionModal>[];
        try {
            if (!await GenUtils.columnExistsInTable(table: "QRFeedbackhdr", columnToCheck: "IsSynced")) {
                FslLog.e(_logger, "Column 'IsSynced' not found, altering table...");
                await GetDataHandler.handleToAlterAsIn("QRFeedbackhdr", "IsSynced");
            }

            final database = await DatabaseHelper().database;

            String query = """
        SELECT * FROM QRFeedbackhdr
        WHERE IsSynced = 1
      """;

            if (searchStr != null && searchStr.isNotEmpty) {
                query += """
          AND (pRowID LIKE '%$searchStr%'
          OR pRowID IN (SELECT QRHdrID FROM QRPOItemDtl WHERE PONO LIKE '%$searchStr%')
          OR pRowID IN (SELECT QRHdrID FROM QRPOItemDtl WHERE CustomerItemRef LIKE '%$searchStr%'))
        """;
            }
            query += " ORDER BY InspectionDt DESC";

            FslLog.i(_logger, "Get synced inspection list query: $query");

            final cursor = await database.rawQuery(query);

            for (var row in cursor) {
                final inspectionModel = InspectionModal()
                    ..pRowID = row["pRowID"] as String?
                    ..customer = row["Customer"] as String?
                    ..vendor = row["Vendor"] as String?
                    ..vendorContact = row["VendorContact"] as String?
                    ..vendorAddress = row["FactoryAddress"] as String?
                    ..inspectionDt = row["InspectionDt"] as String?
                    ..activity = row["Activity"] as String?
                    ..activityID = row["ActivityID"] as String?
                    ..qr = row["QR"] as String?
                    ..inspector = row["Inspector"] as String?
                    ..arrivalTime = row["ArrivalTime"] as String?
                    ..inspStartTime = row["InspStartTime"] as String?
                    ..completeTime = row["CompleteTime"] as String?
                    ..inspectionLevel = row["InspectionLevel"] as String?
                    ..qlMajor = row["QLMajor"] as String?
                    ..qlMinor = row["QLMinor"] as String?
                    ..qlMajorDescr = row["QLMajorDescr"] as String?
                    ..qlMinorDescr = row["QLMinorDescr"] as String?
                    ..status = row["Status"] as String?
                    ..recDt = row["recDt"] as String?
                    ..acceptedDt = row["AcceptedDt"] as String?
                    ..comments = row["Comments"] as String?
                    ..factory = row["Factory"] as String?
                    ..productionStatusRemark = row["ProductionStatusRemark"] as String?
                    ..aqlFormula = row["AQLFormula"] as int?;

                final itemIdList = await POItemDtlHandler.getItemIdList(inspectionModel.pRowID!);
                FslLog.i(_logger, "Item list id closed: $itemIdList");
                if (itemIdList.isNotEmpty) {
                    inspectionModel.itemListId = itemIdList.join(", ");
                }

                final itemIdClosedLists = await POItemDtlHandler.getPOList(inspectionModel.pRowID!);
                FslLog.i(_logger, "ItemIdClosedLists: $itemIdClosedLists");
                if (itemIdClosedLists.isNotEmpty) {
                    inspectionModel.poListed = itemIdClosedLists.join(", ");
                }

                inspectionArrayList.add(inspectionModel);
            }

            await database.close();
            FslLog.i(_logger, "Count of synced found QRFeedbackhdr: ${inspectionArrayList.length}");
        } catch (e) {
            FslLog.e(_logger, "Error getting synced inspection list: $e");
        }
        return inspectionArrayList;
    }

    static Future<void> deleteInspectionRecordFromAllTable(String pRowID) async {
        try {
            final database = await DatabaseHelper().database;

            final queries = [
                "UPDATE QRPOItemHdr SET DefaultImageRowID = NULL WHERE QRHdrID = ?",
                "DELETE FROM QRFindings WHERE QRHdrID = ?",
                "DELETE FROM QRQualiltyParameterFields WHERE QRHdrID = ?",
                "DELETE FROM QRPOItemFitnessCheck WHERE QRHdrID = ?",
                "DELETE FROM QRProductionStatus WHERE QRHdrID = ?",
                "DELETE FROM QREnclosure WHERE ContextID = ?",
                "DELETE FROM QRPOIntimationDetails WHERE QRHdrID = ?",
                "DELETE FROM QRPOItemDtl_ItemMeasurement WHERE QR_hdrID = ?",
                "DELETE FROM QRInspectionHistory WHERE RefQRHdrID = ?",
                "DELETE FROM QRAuditBatchDetails WHERE QRHdrID = ?",
                "DELETE FROM Enclosures WHERE QRHdrID = ?",
                "DELETE FROM QRPOItemDtl_Image WHERE QRHdrID = ?",
                "DELETE FROM QRPOItemdtl WHERE QRHdrID = ?",
                "DELETE FROM QRPOItemHdr WHERE QRHdrID = ?",
                "DELETE FROM QRFeedbackhdr WHERE pRowID = ?",
            ];

            for (var i = 0; i < queries.length; i++) {
                FslLog.i(_logger, "Executing query ${i + 1}: ${queries[i]}");
                await database.execute(queries[i], [pRowID]);
            }

            await database.close();
        } catch (e) {
            FslLog.e(_logger, "Error deleting inspection records: $e");
        }
    }

    static Future<int> getPackagingAppearanceImageCount(String pRowID) async {
        int count = 0;
        try {
            final database = await DatabaseHelper().database;


            const query = """
        SELECT COUNT(*) FROM QREnclosure 
        WHERE ContextID = ? AND ContextType = 'PackagingAppearance'
      """;

            FslLog.i(_logger, "Image count query: $query with pRowID: $pRowID");

            final cursor = await database.rawQuery(query, [pRowID]);

            if (cursor.isNotEmpty) {
                count = cursor.first[0] as int;
                FslLog.i(_logger, "Retrieved image count: $count");
            } else {
                FslLog.i(_logger, "No results found for image count query");
            }

            await database.close();
        } catch (e) {
            FslLog.e(_logger, "Error getting packaging appearance image count: $e");
        }
        return count;
    }

    static Future<List<String>> getPackagingAppearanceImages(String pRowID) async {
        final imagePaths = <String>[];
        try {
            final database = await DatabaseHelper().database;

            const query = """
        SELECT FilePath FROM QREnclosure 
        WHERE ContextID = ? AND ContextType = 'PackagingAppearance'
      """;

            final cursor = await database.rawQuery(query, [pRowID]);

            for (var row in cursor) {
                final path = row["FilePath"] as String?;
                if (path != null && path.isNotEmpty) {
                    imagePaths.add(path);
                }
            }

            await database.close();
        } catch (e) {
            FslLog.e(_logger, "Error getting packaging appearance images: $e");
        }
        return imagePaths;
    }
}


class AppConfig {
    static String getCurrentDate() {
        return DateTime.now().toIso8601String();
    }
}