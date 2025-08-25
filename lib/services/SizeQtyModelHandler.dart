

import 'package:flutter/cupertino.dart';

import '../database/database_helper.dart';
import '../model/SizeQtyModel.dart';
import '../utils/fsl_log.dart';

class SizeQtyModelHandler {

    static String TAG = "SizeQtyModelHandler";


    Future<List<SizeQtyModel>> getSizeQtyList(String pRowID) async {
        List<SizeQtyModel> sizeQtyModelList = [];

        try {
            final db = await DatabaseHelper().database;

            String query = '''
      SELECT * FROM SizeQuantity
      WHERE QRPOItemDtlID = ?
      ORDER BY SizeID ASC
    ''';

            List<Map<String, dynamic>> result = await db.rawQuery(query, [pRowID]);

            for (var row in result) {
                sizeQtyModelList.add(SizeQtyModel.fromJson(row));
            }

            print("Count of found SizeQty list: ${sizeQtyModelList.length}");
        } catch (e) {
            print("Error fetching SizeQty list: $e");
        }

        return sizeQtyModelList;
    }


    SizeQtyModel getData(Map<String, dynamic> row) {
        SizeQtyModel sizeQtyModel = SizeQtyModel( );

        sizeQtyModel.acceptedQty = row['AcceptedQty'] ?? 0;
        sizeQtyModel.availableQty = row['AvailableQty'] ?? 0;
        sizeQtyModel.earlierInspected = row['EarlierInspected'] ?? 0;
        sizeQtyModel.orderQty = row['OrderQty'] ?? 0;
        sizeQtyModel.poid = row['POID'] ?? '';
        sizeQtyModel.qrpoItemDtlId = row['QRPOItemDtlID'] ?? '';
        sizeQtyModel.qrpoItemHdrId = row['QRPOItemHdrID'] ?? '';
        sizeQtyModel.sizeGroupDescr = row['SizeGroupDescr'] ?? '';
        sizeQtyModel.sizeId = row['SizeID'] ?? '';

        return sizeQtyModel;
    }


    static void updateSizeQty(List<SizeQtyModel> sizeQtyList, ) {
        if (  sizeQtyList.isNotEmpty) {
            for (final model in sizeQtyList) {
                insertSizeQty( model);
            }
        }
    }



    static Future<void> insertSizeQty( SizeQtyModel sizeQtyModel) async {
        try {
            final db = await DatabaseHelper().database;
            Map<String, dynamic> contentValues = {
                'AcceptedQty': sizeQtyModel.acceptedQty,
                'AvailableQty': sizeQtyModel.availableQty,
                'EarlierInspected': sizeQtyModel.earlierInspected,
                'OrderQty': sizeQtyModel.orderQty,
                'POID': sizeQtyModel.poid,
                'QRPOItemDtlID': sizeQtyModel.qrpoItemDtlId,
                'QRPOItemHdrID': sizeQtyModel.qrpoItemHdrId,
                'SizeGroupDescr': sizeQtyModel.sizeGroupDescr,
                'SizeID': sizeQtyModel.sizeId,
            };

            int rows = await db.update(
                'SizeQuantity',
                contentValues,
                where: 'QRPOItemHdrID = ? AND SizeID = ?',
                whereArgs: [sizeQtyModel.qrpoItemHdrId, sizeQtyModel.sizeId],
            );

            if (rows == 0) {
                debugPrint('SizeQuantity Not updated: $rows');
            } else if (rows == 1) {
                debugPrint('SizeQuantity updated: $rows');
            }
        } catch (e, stacktrace) {
            debugPrint('Exception inserting into SizeQuantity: $e');
            debugPrint('StackTrace: $stacktrace');
        }
    }

}
