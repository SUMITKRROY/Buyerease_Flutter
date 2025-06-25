import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/table/qr_enclosure_table.dart';
import '../model/po_item_dtl_model.dart';
import '../database/table/qr_po_item_dtl_image_table.dart';

class DbHandler {
  Future<void> updateQREnClosureToSync(String pRowID) async {
    try {
      // Create content values for update
      final contentValues = {
        QrEnclosureTable.fileSent: 1,
      };

      // Update the record
      await QrEnclosureTable().updateRecord(pRowID, contentValues);

      print('Updated QREnclosure for pRowID: $pRowID');
    } catch (e) {
      print('Error updating QREnclosure: $e');
      rethrow;
    }
  }

  Future<List<POItemDtl>> getPackagingMeasurementList(
      String qrHdrID, String qrPoItemHdrID) async {
    List<POItemDtl> itemArrayList = [];
    try {
      final Database database = await DatabaseHelper().database;

      final String query = '''
        SELECT 
          dtl.pRowID, 
          dtl.QRPOItemHdrID,
          hdr.PKG_Me_Pallet_Digitals, 
          hdr.PKG_Me_Master_Digitals,    
          hdr.PKG_Me_Inner_Digitals,   
          hdr.PKG_Me_Unit_Digitals,  
          IFNULL(OPDescr,'') AS OPDescr, 
          IFNULL(OPWt,0) AS OPWt,
          IFNULL(OPCBM,0) AS OPCBM, 
          IFNULL(OPQty,0) AS OPQty,  
          IFNULL(IPDimn,'') AS IPDimn, 
          IFNULL(IPWt,0) AS IPWt,
          IFNULL(IPCBM,0) AS IPCBM,           
          IFNULL(IPQty,0) AS IPQty,   
          IFNULL(PalletDimn,'') AS PalletDimn, 
          IFNULL(PalletWt,0) AS PalletWt, 
          IFNULL(PalletCBM,0) AS PalletCBM,   
          IFNULL(PalletQty,0) AS PalletQty,
          IFNULL(IDimn,'') AS IDimn,  
          IFNULL(Weight,0) AS Weight,  
          IFNULL(CBM,0) AS CBM  
        FROM QRPOItemDtl dtl
        INNER JOIN QRPOItemHdr hdr ON hdr.pRowID = dtl.QRPOItemHdrID 
        WHERE dtl.QRHDrID=? AND dtl.QRPOItemHdrID=? AND dtl.recEnable = 1
      ''';

      final List<Map<String, dynamic>> results =
          await database.rawQuery(query, [qrHdrID, qrPoItemHdrID]);

      for (var row in results) {
        POItemDtl poItemDtl = POItemDtl(
          pRowID: row['pRowID'],
          qrpoItemHdrID: row['QRPOItemHdrID'],
          pkgMePalletDigitals: row['PKG_Me_Pallet_Digitals'],
          pkgMeMasterDigitals: row['PKG_Me_Master_Digitals'],
          pkgMeInnerDigitals: row['PKG_Me_Inner_Digitals'],
          pkgMeUnitDigitals: row['PKG_Me_Unit_Digitals'],
          opDescr: row['OPDescr'],
          opWt: row['OPWt'],
          opCBM: row['OPCBM'],
          opQty: row['OPQty'],
          ipDimn: row['IPDimn'],
          ipWt: row['IPWt'],
          ipCBM: row['IPCBM'],
          ipQty: row['IPQty'],
          palletDimn: row['PalletDimn'],
          palletWt: row['PalletWt'],
          palletCBM: row['PalletCBM'],
          palletQty: row['PalletQty'],
          iDimn: row['IDimn'],
          weight: row['Weight'],
          cbm: row['CBM'],
        );

        // Parse dimension strings
        if (poItemDtl.opDescr != null &&
            poItemDtl.opDescr!.isNotEmpty &&
            poItemDtl.opDescr != 'null') {
          List<String> spStr = poItemDtl.opDescr!.split('x');
          if (spStr.isNotEmpty) {
            poItemDtl.mapCountMaster = int.tryParse(spStr[0]);
            if (spStr.length > 3) {
              poItemDtl.opL = double.tryParse(spStr[1]);
              poItemDtl.opW = double.tryParse(spStr[2]);
              poItemDtl.opH = double.tryParse(spStr[3]);
            }
          }
        }

        if (poItemDtl.ipDimn != null &&
            poItemDtl.ipDimn!.isNotEmpty &&
            poItemDtl.ipDimn != 'null') {
          List<String> spStr = poItemDtl.ipDimn!.split('x');
          if (spStr.isNotEmpty) {
            poItemDtl.mapCountInner = int.tryParse(spStr[0]);
            if (spStr.length > 3) {
              poItemDtl.ipL = double.tryParse(spStr[1]);
              poItemDtl.ipW = double.tryParse(spStr[2]);
              poItemDtl.ipH = double.tryParse(spStr[3]);
            }
          }
        }

        if (poItemDtl.palletDimn != null &&
            poItemDtl.palletDimn!.isNotEmpty &&
            poItemDtl.palletDimn != 'null') {
          List<String> spStr = poItemDtl.palletDimn!.split('x');
          if (spStr.isNotEmpty) {
            poItemDtl.mapCountPallet = int.tryParse(spStr[0]);
            if (spStr.length > 3) {
              poItemDtl.palletL = double.tryParse(spStr[1]);
              poItemDtl.palletW = double.tryParse(spStr[2]);
              poItemDtl.palletH = double.tryParse(spStr[3]);
            }
          }
        }

        if (poItemDtl.iDimn != null &&
            poItemDtl.iDimn!.isNotEmpty &&
            poItemDtl.iDimn != 'null') {
          List<String> spStr = poItemDtl.iDimn!.split('x');
          if (spStr.isNotEmpty) {
            poItemDtl.mapCountUnit = int.tryParse(spStr[0]);
            if (spStr.length > 3) {
              poItemDtl.unitL = double.tryParse(spStr[1]);
              poItemDtl.unitW = double.tryParse(spStr[2]);
              poItemDtl.unitH = double.tryParse(spStr[3]);
            }
          }
        }

        itemArrayList.add(poItemDtl);
      }

      print(
          'Count of found packaging measurement list: ${itemArrayList.length}');
      return itemArrayList;
    } catch (e) {
      print('Error getting packaging measurement list: $e');
      rethrow;
    }
  }

  Future<List<POItemDtl>> getPackagingFindingMeasurementList(
      String qrHdrID, String qrPoItemHdrID) async {
    List<POItemDtl> itemArrayList = [];
    try {
      final Database database = await DatabaseHelper().database;

      final String query = '''
        SELECT * FROM QRPOItemHdr hdr 
        WHERE pRowID = ? AND ItemID = ?
      ''';

      final List<Map<String, dynamic>> results =
          await database.rawQuery(query, [qrPoItemHdrID, qrHdrID]);

      for (var row in results) {
        POItemDtl poItemDtl = POItemDtl(
          pRowID: row['pRowID'],
          pkgMeInspectionResultID: row['PKG_Me_InspectionResultID'],
          pkgMeMasterInspectionResultID:
              row['PKG_Me_Master_InspectionResultID'],
          pkgMePalletInspectionResultID:
              row['PKG_Me_Pallet_InspectionResultID'],
          pkgMeUnitInspectionResultID: row['PKG_Me_Unit_InspectionResultID'],
          pkgMeInnerInspectionResultID: row['PKG_Me_Inner_InspectionResultID'],
          pkgAppShippingMarkInspectionResultID:
              row['PKG_App_ShippingMark_InspectionResultID'],
          pkgAppRemark: row['PKG_App_Remark'],
          pkgAppInspectionResultID: row['PKG_App_InspectionResultID'],
          pkgAppInspectionLevelID: row['PKG_App_InspectionLevelID'],
          pkgAppPalletInspectionResultID:
              row['PKG_App_Pallet_InspectionResultID'],
          pkgAppPalletSampleSizeID: row['PKG_App_Pallet_SampleSizeID'],
          pkgAppPalletSampleSizeValue: row['PKG_App_Pallet_SampleSizeValue'],
          pkgAppMasterSampleSizeID: row['PKG_App_Master_SampleSizeID'],
          pkgAppMasterSampleSizeValue: row['PKG_App_Master_SampleSizeValue'],
          pkgAppMasterInspectionResultID:
              row['PKG_App_Master_InspectionResultID'],
          pkgAppInnerSampleSizeID: row['PKG_App_Inner_SampleSizeID'],
          pkgAppInnerSampleSizeValue: row['PKG_App_Inner_SampleSizeValue'],
          pkgAppUnitSampleSizeID: row['PKG_App_Unit_SampleSizeID'],
          pkgAppUnitInspectionResultID: row['PKG_App_Unit_InspectionResultID'],
          onSiteTestRemark: row['OnSiteTest_Remark'],
          qtyRemark: row['Qty_Remark'],
          barcodeInspectionLevelID: row['Barcode_InspectionLevelID'],
          barcodeInspectionResultID: row['Barcode_InspectionResultID'],
          barcodeRemark: row['Barcode_Remark'],
          barcodePalletSampleSizeID: row['Barcode_Pallet_SampleSizeID'],
          barcodePalletSampleSizeValue: row['Barcode_Pallet_SampleSizeValue'],
          barcodePalletVisual: row['Barcode_Pallet_Visual'],
          barcodePalletScan: row['Barcode_Pallet_Scan'],
          barcodePalletInspectionResultID:
              row['Barcode_Pallet_InspectionResultID'],
          barcodeMasterSampleSizeID: row['Barcode_Master_SampleSizeID'],
          barcodeMasterSampleSizeValue: row['Barcode_Master_SampleSizeValue'],
          barcodeMasterVisual: row['Barcode_Master_Visual'],
          barcodeMasterScan: row['Barcode_Master_Scan'],
          barcodeInnerSampleSizeID: row['Barcode_Inner_SampleSizeID'],
          barcodeMasterInspectionResultID:
              row['Barcode_Master_InspectionResultID'],
          barcodeInnerSampleSizeValue: row['Barcode_Inner_SampleSizeValue'],
          barcodeInnerVisual: row['Barcode_Inner_Visual'],
          barcodeInnerScan: row['Barcode_Inner_Scan'],
          barcodeInnerInspectionResultID:
              row['Barcode_Inner_InspectionResultID'],
          barcodeUnitSampleSizeID: row['Barcode_Unit_SampleSizeID'],
          barcodeUnitSampleSizeValue: row['Barcode_Unit_SampleSizeValue'],
          barcodeUnitVisual: row['Barcode_Unit_Visual'],
          barcodeUnitScan: row['Barcode_Unit_Scan'],
          barcodeUnitInspectionResultID: row['Barcode_Unit_InspectionResultID'],
          pkgMeRemark: row['PKG_Me_Remark'],
          overallInspectionResultID: row['Overall_InspectionResultID'],
          workmanshipInspectionResultID: row['WorkmanShip_InspectionResultID'],
          workmanshipRemark: row['WorkmanShip_Remark'],
          itemMeasurementInspectionResultID:
              row['ItemMeasurement_InspectionResultID'],
          itemMeasurementRemark: row['ItemMeasurement_Remark'],
          pkgMePalletFindingL: row['PKG_Me_Pallet_FindingL'],
          pkgMePalletFindingB: row['PKG_Me_Pallet_FindingB'],
          pkgMePalletFindingH: row['PKG_Me_Pallet_FindingH'],
          pkgMePalletFindingWt: row['PKG_Me_Pallet_FindingWt'],
          pkgMePalletFindingCBM: row['PKG_Me_Pallet_FindingCBM'],
          pkgMePalletFindingQty: row['PKG_Me_Pallet_FindingQty'],
          pkgMeMasterFindingL: row['PKG_Me_Master_FindingL'],
          pkgMeMasterFindingB: row['PKG_Me_Master_FindingB'],
          pkgMeMasterFindingH: row['PKG_Me_Master_FindingH'],
          pkgMeMasterFindingWt: row['PKG_Me_Master_FindingWt'],
          pkgMeMasterFindingCBM: row['PKG_Me_Master_FindingCBM'],
          pkgMeMasterFindingQty: row['PKG_Me_Master_FindingQty'],
          pkgMeInnerFindingL: row['PKG_Me_Inner_FindingL'],
          pkgMeInnerFindingB: row['PKG_Me_Inner_FindingB'],
          pkgMeInnerFindingH: row['PKG_Me_Inner_FindingH'],
          pkgMeInnerFindingWt: row['PKG_Me_Inner_FindingWt'],
          pkgMeInnerFindingCBM: row['PKG_Me_Inner_FindingCBM'],
          pkgMeInnerFindingQty: row['PKG_Me_Inner_FindingQty'],
          pkgMeUnitFindingL: row['PKG_Me_Unit_FindingL'],
          pkgMeUnitFindingB: row['PKG_Me_Unit_FindingB'],
          pkgMeUnitFindingH: row['PKG_Me_Unit_FindingH'],
          pkgMeUnitFindingWt: row['PKG_Me_Unit_FindingWt'],
          pkgMeUnitFindingCBM: row['PKG_Me_Unit_FindingCBM'],
          pkgMeInnerSampleSizeID: row['PKG_Me_Inner_SampleSizeID'],
          pkgMeUnitSampleSizeID: row['PKG_Me_Unit_SampleSizeID'],
          pkgMePalletSampleSizeID: row['PKG_Me_Pallet_SampleSizeID'],
          pkgMeMasterSampleSizeID: row['PKG_Me_Master_SampleSizeID'],
          pkgAppShippingMarkSampleSizeId:
              row['PKG_App_shippingMark_SampleSizeId'],
        );

        itemArrayList.add(poItemDtl);
      }

      print(
          'Count of found packaging finding measurement list: ${itemArrayList.length}');
      return itemArrayList;
    } catch (e) {
      print('Error getting packaging finding measurement list: $e');
      rethrow;
    }
  }

  Future<List<POItemDtl>> getDigitalsPackagingMeasurement(
      String qrHdrID, String qrPoItemHdrID) async {
    List<POItemDtl> itemArrayList = [];
    try {
      final Database database = await DatabaseHelper().database;

      final String query = '''
        SELECT 
          pRowID, 
          PKG_Me_Pallet_Digitals, 
          PKG_Me_Master_Digitals,    
          PKG_Me_Inner_Digitals,   
          PKG_Me_Unit_Digitals   
        FROM QRPOItemHdr hdr   
        WHERE pRowID = ? AND QRHDrID = ?
      ''';

      final List<Map<String, dynamic>> results = await database.rawQuery(query, [qrPoItemHdrID, qrHdrID]);

      for (var row in results) {
        POItemDtl poItemDtl = POItemDtl(
          pRowID: row['pRowID'],
          pkgMePalletDigitals: row['PKG_Me_Pallet_Digitals'],
          pkgMeMasterDigitals: row['PKG_Me_Master_Digitals'],
          pkgMeInnerDigitals: row['PKG_Me_Inner_Digitals'],
          pkgMeUnitDigitals: row['PKG_Me_Unit_Digitals'],
        );

        itemArrayList.add(poItemDtl);
      }

      print(
          'Count of found digitals packaging measurement list: ${itemArrayList.length}');
      return itemArrayList;
    } catch (e) {
      print('Error getting digitals packaging measurement list: $e');
      rethrow;
    }
  }

  Future<void> updateImageToSync(String pRowID) async {
    try {
      final contentValues = {
        QrPoItemDtlImageTable.fileSent: 1,
      };
      await QrPoItemDtlImageTable().update(pRowID, contentValues);
      print('Updated QRPOItemDtl_Image FileSent=1 for pRowID: $pRowID');
    } catch (e) {
      print('Error updating QRPOItemDtl_Image to sync: $e');
      rethrow;
    }
  }


}
