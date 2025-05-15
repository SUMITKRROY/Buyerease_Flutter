class POItemDtl {
  // Header fields
  String? pOhdr;
  String? itemhdr;
  String? orderhdr;
  String? inspectedTillDatehdr;
  String? availablehdr;
  String? acceptedhdr;
  String? shorthdr;
  String? shortStockQtyhdr;
  String? inspectLaterHr;
  String? workmanshipToInspectionhdr;
  String? inspectedhdr;
  String? criticalhdr;
  String? majorhdr;
  String? minorhdr;
  String? cartonPackeddr;
  String? cartonAvailable;
  String? cartonToInspectedhdr;
  String? packagingMeasurementhdr;
  String? barCodehdr;
  String? digitalUploadedhdr;
  String? enclosuresUploadedhdr;
  String? taskReportshdr;
  String? measurementshdr;
  String? samplePurposehdr;
  String? overallInspectionResulthdr;
  String? hologramNohdr;

  // PO Item Header fields
  String? pRowID;
  int? allowedinspectionQty;
  String? sampleSizeInspection;
  int? inspectedQty;
  int? criticalDefectsAllowed;
  int? majorDefectsAllowed;
  int? minorDefectsAllowed;
  int? cartonsPacked2;
  int? allowedCartonInspection;
  int? cartonsPacked;
  int? cartonsInspected;

  // PO Item Detail fields
  String? qrItemID;
  String? qrHdrID;
  String? qrpoItemHdrID;
  String? poItemDtlRowID;
  String? sampleCodeID;
  String? latestDelDt;
  int? availableQty;
  int? acceptedQty;
  int? furtherInspectionReqd;
  int? short;
  int? shortStockQty;
  int? criticalDefect;
  int? majorDefect;
  int? minorDefect;
  int? recDirty;
  String? poNo;
  String? itemDescr;
  String? orderQty;
  int? earlierInspected;
  String? customerItemRef;
  String? hologramNo;
  int? poMasterPackQty;

  // Dimensions and measurements
  String? opDescr;
  double? opL;
  double? opH;
  double? opW;
  double? opWt;
  double? opCBM;
  int? opQty;
  String? ipDimn;
  double? ipL;
  double? ipH;
  double? ipW;
  double? ipWt;
  double? ipCBM;
  int? ipQty;
  String? palletDimn;
  double? palletL;
  double? palletH;
  double? palletW;
  double? palletWt;
  double? palletCBM;
  int? palletQty;
  String? iDimn;
  int? mapCountUnit;
  int? mapCountInner;
  int? mapCountMaster;
  int? mapCountPallet;
  double? unitL;
  double? unitH;
  double? unitW;
  int? weight;
  double? cbm;
  double? retailPrice;

  // Inspection results
  String? pkgMeInspectionResultID;
  String? pkgMeMasterInspectionResultID;
  String? pkgMePalletInspectionResultID;
  String? pkgMeUnitInspectionResultID;
  String? pkgMeInnerInspectionResultID;
  String? pkgMeRemark;
  String? onSiteTestRemark;
  String? qtyRemark;

  // Packaging appearance fields
  String? pkgAppInspectionLevelID;
  String? pkgAppInspectionResultID;
  String? pkgAppPalletInspectionResultID;
  String? pkgAppPalletSampleSizeID;
  int? pkgAppPalletSampleSizeValue;
  String? pkgAppMasterSampleSizeID;
  int? pkgAppMasterSampleSizeValue;
  String? pkgAppMasterInspectionResultID;
  String? pkgAppInnerSampleSizeID;
  int? pkgAppInnerSampleSizeValue;
  String? pkgAppUnitSampleSizeID;
  String? pkgAppUnitInspectionResultID;
  String? pkgAppShippingMarkSampleSizeId;
  String? pkgAppShippingMarkInspectionResultID;
  String? pkgAppRemark;

  // Workmanship and measurement fields
  String? workmanshipInspectionResultID;
  String? workmanshipRemark;
  String? itemMeasurementInspectionResultID;
  String? overallInspectionResultID;
  String? itemMeasurementRemark;

  // Attachment lists
  List<String> unitPackingAttachmentList = [];
  List<String> innerPackingAttachmentList = [];
  List<String> masterPackingAttachmentList = [];
  List<String> palletPackingAttachmentList = [];
  List<String> unitBarcodeAttachmentList = [];
  List<String> innerBarcodeAttachmentList = [];
  List<String> masterBarcodeAttachmentList = [];
  List<String> palletBarcodeAttachmentList = [];

  // Finding measurements
  double? pkgMeInnerFindingL;
  double? pkgMeInnerFindingB;
  double? pkgMeInnerFindingH;
  double? pkgMeInnerFindingWt;
  double? pkgMeInnerFindingQty;
  double? pkgMeUnitFindingL;
  double? pkgMeUnitFindingB;
  double? pkgMeUnitFindingH;
  double? pkgMeUnitFindingWt;
  double? pkgMeUnitFindingQty;
  double? pkgMePalletFindingL;
  double? pkgMePalletFindingB;
  double? pkgMePalletFindingH;
  double? pkgMePalletFindingWt;
  double? pkgMePalletFindingQty;
  double? pkgMeMasterFindingL;
  double? pkgMeMasterFindingB;
  double? pkgMeMasterFindingH;
  double? pkgMeMasterFindingWt;
  double? pkgMeMasterFindingQty;

  // Sample size IDs
  String? pkgMeMasterSampleSizeID;
  String? pkgMePalletSampleSizeID;
  String? pkgMeUnitSampleSizeID;
  String? pkgMeInnerSampleSizeID;

  // CBM measurements
  double? pkgMeMasterFindingCBM;
  double? pkgMePalletFindingCBM;
  double? pkgMeUnitFindingCBM;
  double? pkgMeInnerFindingCBM;

  // Visibility flags
  int? isQuantityContainerVisible;
  int? isWorkmanshipContainerVisible;
  int? iscartonDetailsContainerVisible;
  int? isMoreDetailsContainerVisible;

  // Additional fields
  String? sampleSizeDescr;
  String? itemID;
  String? qrItemBaseMaterialID;
  String? qrItemBaseMaterialAddOnInfo;
  String? barcodeInspectionResult;
  String? onSiteTestInspectionResult;
  String? itemMeasurementInspectionResult;
  String? workmanshipInspectionResult;
  String? overallInspectionResult;
  String? pkgMeInspectionResult;
  int? digitals;
  int? enclCount;
  int? isSelected;
  int? sizeBreakUP;
  String? shipToBreakUP;
  int? testReportStatus;
  int? duplicateFlag;
  int? isHologramExpired;
  int? isImportant;
  int? itemRepeat;

  // Digital fields
  String? pkgMePalletDigitals;
  String? pkgMeMasterDigitals;
  String? pkgMeInnerDigitals;
  String? pkgMeUnitDigitals;
  String? pkgMeShippingDigitals;
  String? pkgAppUnitDigitals;
  String? pkgAppInnerDigitals;
  String? pkgAppMasterDigitals;
  String? pkgAppPalletDigitals;
  String? pkgAppShippingDigitals;

  // Barcode fields
  String? barcodeInspectionLevelID;
  String? barcodeInspectionResultID;
  String? barcodeRemark;
  String? barcodePalletSampleSizeID;
  int? barcodePalletSampleSizeValue;
  String? barcodePalletScan;
  String? barcodePalletVisual;
  String? barcodePalletInspectionResultID;
  String? barcodeMasterSampleSizeID;
  int? barcodeMasterSampleSizeValue;
  String? barcodeMasterVisual;
  String? barcodeMasterScan;
  String? barcodeInnerSampleSizeID;
  String? barcodeMasterInspectionResultID;
  int? barcodeInnerSampleSizeValue;
  String? barcodeInnerVisual;
  String? barcodeInnerScan;
  String? barcodeInnerInspectionResultID;
  String? barcodeUnitSampleSizeID;
  int? barcodeUnitSampleSizeValue;
  String? barcodeUnitVisual;
  String? barcodeUnitScan;
  String? barcodeUnitInspectionResultID;

  POItemDtl({
    this.pOhdr,
    this.itemhdr,
    this.orderhdr,
    this.inspectedTillDatehdr,
    this.availablehdr,
    this.acceptedhdr,
    this.shorthdr,
    this.shortStockQtyhdr,
    this.inspectLaterHr,
    this.workmanshipToInspectionhdr,
    this.inspectedhdr,
    this.criticalhdr,
    this.majorhdr,
    this.minorhdr,
    this.cartonPackeddr,
    this.cartonAvailable,
    this.cartonToInspectedhdr,
    this.packagingMeasurementhdr,
    this.barCodehdr,
    this.digitalUploadedhdr,
    this.enclosuresUploadedhdr,
    this.taskReportshdr,
    this.measurementshdr,
    this.samplePurposehdr,
    this.overallInspectionResulthdr,
    this.hologramNohdr,
    this.pRowID,
    this.allowedinspectionQty,
    this.sampleSizeInspection,
    this.inspectedQty,
    this.criticalDefectsAllowed,
    this.majorDefectsAllowed,
    this.minorDefectsAllowed,
    this.cartonsPacked2,
    this.allowedCartonInspection,
    this.cartonsPacked,
    this.cartonsInspected,
    this.qrItemID,
    this.qrHdrID,
    this.qrpoItemHdrID,
    this.poItemDtlRowID,
    this.sampleCodeID,
    this.latestDelDt,
    this.availableQty,
    this.acceptedQty,
    this.furtherInspectionReqd,
    this.short,
    this.shortStockQty,
    this.criticalDefect,
    this.majorDefect,
    this.minorDefect,
    this.recDirty,
    this.poNo,
    this.itemDescr,
    this.orderQty,
    this.earlierInspected,
    this.customerItemRef,
    this.hologramNo,
    this.poMasterPackQty,
    this.opDescr,
    this.opL,
    this.opH,
    this.opW,
    this.opWt,
    this.opCBM,
    this.opQty,
    this.ipDimn,
    this.ipL,
    this.ipH,
    this.ipW,
    this.ipWt,
    this.ipCBM,
    this.ipQty,
    this.palletDimn,
    this.palletL,
    this.palletH,
    this.palletW,
    this.palletWt,
    this.palletCBM,
    this.palletQty,
    this.iDimn,
    this.mapCountUnit,
    this.mapCountInner,
    this.mapCountMaster,
    this.mapCountPallet,
    this.unitL,
    this.unitH,
    this.unitW,
    this.weight,
    this.cbm,
    this.retailPrice,
    this.pkgMeInspectionResultID,
    this.pkgMeMasterInspectionResultID,
    this.pkgMePalletInspectionResultID,
    this.pkgMeUnitInspectionResultID,
    this.pkgMeInnerInspectionResultID,
    this.pkgMeRemark,
    this.onSiteTestRemark,
    this.qtyRemark,
    this.pkgAppInspectionLevelID,
    this.pkgAppInspectionResultID,
    this.pkgAppPalletInspectionResultID,
    this.pkgAppPalletSampleSizeID,
    this.pkgAppPalletSampleSizeValue,
    this.pkgAppMasterSampleSizeID,
    this.pkgAppMasterSampleSizeValue,
    this.pkgAppMasterInspectionResultID,
    this.pkgAppInnerSampleSizeID,
    this.pkgAppInnerSampleSizeValue,
    this.pkgAppUnitSampleSizeID,
    this.pkgAppUnitInspectionResultID,
    this.pkgAppShippingMarkSampleSizeId,
    this.pkgAppShippingMarkInspectionResultID,
    this.pkgAppRemark,
    this.workmanshipInspectionResultID,
    this.workmanshipRemark,
    this.itemMeasurementInspectionResultID,
    this.overallInspectionResultID,
    this.itemMeasurementRemark,
    this.pkgMeInnerFindingL,
    this.pkgMeInnerFindingB,
    this.pkgMeInnerFindingH,
    this.pkgMeInnerFindingWt,
    this.pkgMeInnerFindingQty,
    this.pkgMeUnitFindingL,
    this.pkgMeUnitFindingB,
    this.pkgMeUnitFindingH,
    this.pkgMeUnitFindingWt,
    this.pkgMeUnitFindingQty,
    this.pkgMePalletFindingL,
    this.pkgMePalletFindingB,
    this.pkgMePalletFindingH,
    this.pkgMePalletFindingWt,
    this.pkgMePalletFindingQty,
    this.pkgMeMasterFindingL,
    this.pkgMeMasterFindingB,
    this.pkgMeMasterFindingH,
    this.pkgMeMasterFindingWt,
    this.pkgMeMasterFindingQty,
    this.pkgMeMasterSampleSizeID,
    this.pkgMePalletSampleSizeID,
    this.pkgMeUnitSampleSizeID,
    this.pkgMeInnerSampleSizeID,
    this.pkgMeMasterFindingCBM,
    this.pkgMePalletFindingCBM,
    this.pkgMeUnitFindingCBM,
    this.pkgMeInnerFindingCBM,
    this.isQuantityContainerVisible,
    this.isWorkmanshipContainerVisible,
    this.iscartonDetailsContainerVisible,
    this.isMoreDetailsContainerVisible,
    this.sampleSizeDescr,
    this.itemID,
    this.qrItemBaseMaterialID,
    this.qrItemBaseMaterialAddOnInfo,
    this.barcodeInspectionResult,
    this.onSiteTestInspectionResult,
    this.itemMeasurementInspectionResult,
    this.workmanshipInspectionResult,
    this.overallInspectionResult,
    this.pkgMeInspectionResult,
    this.digitals,
    this.enclCount,
    this.isSelected,
    this.sizeBreakUP,
    this.shipToBreakUP,
    this.testReportStatus,
    this.duplicateFlag,
    this.isHologramExpired,
    this.isImportant,
    this.itemRepeat,
    this.pkgMePalletDigitals,
    this.pkgMeMasterDigitals,
    this.pkgMeInnerDigitals,
    this.pkgMeUnitDigitals,
    this.pkgMeShippingDigitals,
    this.pkgAppUnitDigitals,
    this.pkgAppInnerDigitals,
    this.pkgAppMasterDigitals,
    this.pkgAppPalletDigitals,
    this.pkgAppShippingDigitals,
    this.barcodeInspectionLevelID,
    this.barcodeInspectionResultID,
    this.barcodeRemark,
    this.barcodePalletSampleSizeID,
    this.barcodePalletSampleSizeValue,
    this.barcodePalletScan,
    this.barcodePalletVisual,
    this.barcodePalletInspectionResultID,
    this.barcodeMasterSampleSizeID,
    this.barcodeMasterSampleSizeValue,
    this.barcodeMasterVisual,
    this.barcodeMasterScan,
    this.barcodeInnerSampleSizeID,
    this.barcodeMasterInspectionResultID,
    this.barcodeInnerSampleSizeValue,
    this.barcodeInnerVisual,
    this.barcodeInnerScan,
    this.barcodeInnerInspectionResultID,
    this.barcodeUnitSampleSizeID,
    this.barcodeUnitSampleSizeValue,
    this.barcodeUnitVisual,
    this.barcodeUnitScan,
    this.barcodeUnitInspectionResultID,
  });

  factory POItemDtl.fromJson(Map<String, dynamic> json) {
    return POItemDtl(
      pOhdr: json['POhdr'],
      itemhdr: json['Itemhdr'],
      orderhdr: json['Orderhdr'],
      inspectedTillDatehdr: json['InspectedTillDatehdr'],
      availablehdr: json['Availablehdr'],
      acceptedhdr: json['Acceptedhdr'],
      shorthdr: json['Shorthdr'],
      shortStockQtyhdr: json['ShortStockQtyhdr'],
      inspectLaterHr: json['InspectLaterHr'],
      workmanshipToInspectionhdr: json['workmanshipToInspectionhdr'],
      inspectedhdr: json['Inspectedhdr'],
      criticalhdr: json['Criticalhdr'],
      majorhdr: json['Majorhdr'],
      minorhdr: json['Minorhdr'],
      cartonPackeddr: json['cartonPackeddr'],
      cartonAvailable: json['cartonAvailable'],
      cartonToInspectedhdr: json['cartonToInspectedhdr'],
      packagingMeasurementhdr: json['packagingMeasurementhdr'],
      barCodehdr: json['barCodehdr'],
      digitalUploadedhdr: json['digitalUploadedhdr'],
      enclosuresUploadedhdr: json['enclosuresUploadedhdr'],
      taskReportshdr: json['taskReportshdr'],
      measurementshdr: json['measurementshdr'],
      samplePurposehdr: json['SamplePurposehdr'],
      overallInspectionResulthdr: json['OverallInspectionResulthdr'],
      hologramNohdr: json['HologramNohdr'],
      pRowID: json['pRowID'],
      allowedinspectionQty: json['AllowedinspectionQty'],
      sampleSizeInspection: json['SampleSizeInspection'],
      inspectedQty: json['InspectedQty'],
      criticalDefectsAllowed: json['CriticalDefectsAllowed'],
      majorDefectsAllowed: json['MajorDefectsAllowed'],
      minorDefectsAllowed: json['MinorDefectsAllowed'],
      cartonsPacked2: json['CartonsPacked2'],
      allowedCartonInspection: json['AllowedCartonInspection'],
      cartonsPacked: json['CartonsPacked'],
      cartonsInspected: json['CartonsInspected'],
      qrItemID: json['QrItemID'],
      qrHdrID: json['QRHdrID'],
      qrpoItemHdrID: json['QRPOItemHdrID'],
      poItemDtlRowID: json['POItemDtlRowID'],
      sampleCodeID: json['SampleCodeID'],
      latestDelDt: json['LatestDelDt'],
      availableQty: json['AvailableQty'],
      acceptedQty: json['AcceptedQty'],
      furtherInspectionReqd: json['FurtherInspectionReqd'],
      short: json['Short'],
      shortStockQty: json['ShortStockQty'],
      criticalDefect: json['CriticalDefect'],
      majorDefect: json['MajorDefect'],
      minorDefect: json['MinorDefect'],
      recDirty: json['recDirty'],
      poNo: json['PONO'],
      itemDescr: json['ItemDescr'],
      orderQty: json['OrderQty'],
      earlierInspected: json['EarlierInspected'],
      customerItemRef: json['CustomerItemRef'],
      hologramNo: json['HologramNo'],
      poMasterPackQty: json['POMasterPackQty'],
      opDescr: json['OPDescr'],
      opL: json['OPL'],
      opH: json['OPh'],
      opW: json['OPW'],
      opWt: json['OPWt'],
      opCBM: json['OPCBM'],
      opQty: json['OPQty'],
      ipDimn: json['IPDimn'],
      ipL: json['IPL'],
      ipH: json['IPh'],
      ipW: json['IPW'],
      ipWt: json['IPWt'],
      ipCBM: json['IPCBM'],
      ipQty: json['IPQty'],
      palletDimn: json['PalletDimn'],
      palletL: json['PalletL'],
      palletH: json['Palleth'],
      palletW: json['PalletW'],
      palletWt: json['PalletWt'],
      palletCBM: json['PalletCBM'],
      palletQty: json['PalletQty'],
      iDimn: json['IDimn'],
      mapCountUnit: json['mapCountUnit'],
      mapCountInner: json['mapCountInner'],
      mapCountMaster: json['mapCountMaster'],
      mapCountPallet: json['mapCountPallet'],
      unitL: json['UnitL'],
      unitH: json['Unith'],
      unitW: json['UnitW'],
      weight: json['Weight'],
      cbm: json['CBM'],
      retailPrice: json['RetailPrice'],
      pkgMeInspectionResultID: json['PKG_Me_InspectionResultID'],
      pkgMeMasterInspectionResultID: json['PKG_Me_Master_InspectionResultID'],
      pkgMePalletInspectionResultID: json['PKG_Me_Pallet_InspectionResultID'],
      pkgMeUnitInspectionResultID: json['PKG_Me_Unit_InspectionResultID'],
      pkgMeInnerInspectionResultID: json['PKG_Me_Inner_InspectionResultID'],
      pkgMeRemark: json['PKG_Me_Remark'],
      onSiteTestRemark: json['OnSiteTest_Remark'],
      qtyRemark: json['Qty_Remark'],
      pkgAppInspectionLevelID: json['PKG_App_InspectionLevelID'],
      pkgAppInspectionResultID: json['PKG_App_InspectionResultID'],
      pkgAppPalletInspectionResultID: json['PKG_App_Pallet_InspectionResultID'],
      pkgAppPalletSampleSizeID: json['PKG_App_Pallet_SampleSizeID'],
      pkgAppPalletSampleSizeValue: json['PKG_App_Pallet_SampleSizeValue'],
      pkgAppMasterSampleSizeID: json['PKG_App_Master_SampleSizeID'],
      pkgAppMasterSampleSizeValue: json['PKG_App_Master_SampleSizeValue'],
      pkgAppMasterInspectionResultID: json['PKG_App_Master_InspectionResultID'],
      pkgAppInnerSampleSizeID: json['PKG_App_Inner_SampleSizeID'],
      pkgAppInnerSampleSizeValue: json['PKG_App_Inner_SampleSizeValue'],
      pkgAppUnitSampleSizeID: json['PKG_App_Unit_SampleSizeID'],
      pkgAppUnitInspectionResultID: json['PKG_App_Unit_InspectionResultID'],
      pkgAppShippingMarkSampleSizeId: json['PKG_App_shippingMark_SampleSizeId'],
      pkgAppShippingMarkInspectionResultID: json['PKG_App_ShippingMark_InspectionResultID'],
      pkgAppRemark: json['PKG_App_Remark'],
      workmanshipInspectionResultID: json['WorkmanShip_InspectionResultID'],
      workmanshipRemark: json['WorkmanShip_Remark'],
      itemMeasurementInspectionResultID: json['ItemMeasurement_InspectionResultID'],
      overallInspectionResultID: json['Overall_InspectionResultID'],
      itemMeasurementRemark: json['ItemMeasurement_Remark'],
      pkgMeInnerFindingL: json['PKG_Me_Inner_FindingL'],
      pkgMeInnerFindingB: json['PKG_Me_Inner_FindingB'],
      pkgMeInnerFindingH: json['PKG_Me_Inner_FindingH'],
      pkgMeInnerFindingWt: json['PKG_Me_Inner_FindingWt'],
      pkgMeInnerFindingQty: json['PKG_Me_Inner_FindingQty'],
      pkgMeUnitFindingL: json['PKG_Me_Unit_FindingL'],
      pkgMeUnitFindingB: json['PKG_Me_Unit_FindingB'],
      pkgMeUnitFindingH: json['PKG_Me_Unit_FindingH'],
      pkgMeUnitFindingWt: json['PKG_Me_Unit_FindingWt'],
      pkgMeUnitFindingQty: json['PKG_Me_Unit_FindingQty'],
      pkgMePalletFindingL: json['PKG_Me_Pallet_FindingL'],
      pkgMePalletFindingB: json['PKG_Me_Pallet_FindingB'],
      pkgMePalletFindingH: json['PKG_Me_Pallet_FindingH'],
      pkgMePalletFindingWt: json['PKG_Me_Pallet_FindingWt'],
      pkgMePalletFindingQty: json['PKG_Me_Pallet_FindingQty'],
      pkgMeMasterFindingL: json['PKG_Me_Master_FindingL'],
      pkgMeMasterFindingB: json['PKG_Me_Master_FindingB'],
      pkgMeMasterFindingH: json['PKG_Me_Master_FindingH'],
      pkgMeMasterFindingWt: json['PKG_Me_Master_FindingWt'],
      pkgMeMasterFindingQty: json['PKG_Me_Master_FindingQty'],
      pkgMeMasterSampleSizeID: json['PKG_Me_Master_SampleSizeID'],
      pkgMePalletSampleSizeID: json['PKG_Me_Pallet_SampleSizeID'],
      pkgMeUnitSampleSizeID: json['PKG_Me_Unit_SampleSizeID'],
      pkgMeInnerSampleSizeID: json['PKG_Me_Inner_SampleSizeID'],
      pkgMeMasterFindingCBM: json['PKG_Me_Master_FindingCBM'],
      pkgMePalletFindingCBM: json['PKG_Me_Pallet_FindingCBM'],
      pkgMeUnitFindingCBM: json['PKG_Me_Unit_FindingCBM'],
      pkgMeInnerFindingCBM: json['PKG_Me_Inner_FindingCBM'],
      isQuantityContainerVisible: json['IsQuantityContainerVisible'],
      isWorkmanshipContainerVisible: json['IsWorkmanshipContainerVisible'],
      iscartonDetailsContainerVisible: json['IscartonDetailsContainerVisible'],
      isMoreDetailsContainerVisible: json['IsMoreDetailsContainerVisible'],
      sampleSizeDescr: json['SampleSizeDescr'],
      itemID: json['ItemID'],
      qrItemBaseMaterialID: json['QRItemBaseMaterialID'],
      qrItemBaseMaterialAddOnInfo: json['QRItemBaseMaterial_AddOnInfo'],
      barcodeInspectionResult: json['Barcode_InspectionResult'],
      onSiteTestInspectionResult: json['OnSiteTest_InspectionResult'],
      itemMeasurementInspectionResult: json['ItemMeasurement_InspectionResult'],
      workmanshipInspectionResult: json['WorkmanShip_InspectionResult'],
      overallInspectionResult: json['Overall_InspectionResult'],
      pkgMeInspectionResult: json['PKG_Me_InspectionResult'],
      digitals: json['Digitals'],
      enclCount: json['EnclCount'],
      isSelected: json['IsSelected'],
      sizeBreakUP: json['SizeBreakUP'],
      shipToBreakUP: json['ShipToBreakUP'],
      testReportStatus: json['testReportStatus'],
      duplicateFlag: json['DuplicateFlag'],
      isHologramExpired: json['IsHologramExpired'],
      isImportant: json['IsImportant'],
      itemRepeat: json['ItemRepeat'],
      pkgMePalletDigitals: json['PKG_Me_Pallet_Digitals'],
      pkgMeMasterDigitals: json['PKG_Me_Master_Digitals'],
      pkgMeInnerDigitals: json['PKG_Me_Inner_Digitals'],
      pkgMeUnitDigitals: json['PKG_Me_Unit_Digitals'],
      pkgMeShippingDigitals: json['PKG_Me_Shipping_Digitals'],
      pkgAppUnitDigitals: json['PKG_App_Unit_Digitals'],
      pkgAppInnerDigitals: json['PKG_App_Inner_Digitals'],
      pkgAppMasterDigitals: json['PKG_App_Master_Digitals'],
      pkgAppPalletDigitals: json['PKG_App_Pallet_Digitals'],
      pkgAppShippingDigitals: json['PKG_App_Shipping_Digitals'],
      barcodeInspectionLevelID: json['Barcode_InspectionLevelID'],
      barcodeInspectionResultID: json['Barcode_InspectionResultID'],
      barcodeRemark: json['Barcode_Remark'],
      barcodePalletSampleSizeID: json['Barcode_Pallet_SampleSizeID'],
      barcodePalletSampleSizeValue: json['Barcode_Pallet_SampleSizeValue'],
      barcodePalletScan: json['Barcode_Pallet_Scan'],
      barcodePalletVisual: json['Barcode_Pallet_Visual'],
      barcodePalletInspectionResultID: json['Barcode_Pallet_InspectionResultID'],
      barcodeMasterSampleSizeID: json['Barcode_Master_SampleSizeID'],
      barcodeMasterSampleSizeValue: json['Barcode_Master_SampleSizeValue'],
      barcodeMasterVisual: json['Barcode_Master_Visual'],
      barcodeMasterScan: json['Barcode_Master_Scan'],
      barcodeInnerSampleSizeID: json['Barcode_Inner_SampleSizeID'],
      barcodeMasterInspectionResultID: json['Barcode_Master_InspectionResultID'],
      barcodeInnerSampleSizeValue: json['Barcode_Inner_SampleSizeValue'],
      barcodeInnerVisual: json['Barcode_Inner_Visual'],
      barcodeInnerScan: json['Barcode_Inner_Scan'],
      barcodeInnerInspectionResultID: json['Barcode_Inner_InspectionResultID'],
      barcodeUnitSampleSizeID: json['Barcode_Unit_SampleSizeID'],
      barcodeUnitSampleSizeValue: json['Barcode_Unit_SampleSizeValue'],
      barcodeUnitVisual: json['Barcode_Unit_Visual'],
      barcodeUnitScan: json['Barcode_Unit_Scan'],
      barcodeUnitInspectionResultID: json['Barcode_Unit_InspectionResultID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'POhdr': pOhdr,
      'Itemhdr': itemhdr,
      'Orderhdr': orderhdr,
      'InspectedTillDatehdr': inspectedTillDatehdr,
      'Availablehdr': availablehdr,
      'Acceptedhdr': acceptedhdr,
      'Shorthdr': shorthdr,
      'ShortStockQtyhdr': shortStockQtyhdr,
      'InspectLaterHr': inspectLaterHr,
      'workmanshipToInspectionhdr': workmanshipToInspectionhdr,
      'Inspectedhdr': inspectedhdr,
      'Criticalhdr': criticalhdr,
      'Majorhdr': majorhdr,
      'Minorhdr': minorhdr,
      'cartonPackeddr': cartonPackeddr,
      'cartonAvailable': cartonAvailable,
      'cartonToInspectedhdr': cartonToInspectedhdr,
      'packagingMeasurementhdr': packagingMeasurementhdr,
      'barCodehdr': barCodehdr,
      'digitalUploadedhdr': digitalUploadedhdr,
      'enclosuresUploadedhdr': enclosuresUploadedhdr,
      'taskReportshdr': taskReportshdr,
      'measurementshdr': measurementshdr,
      'SamplePurposehdr': samplePurposehdr,
      'OverallInspectionResulthdr': overallInspectionResulthdr,
      'HologramNohdr': hologramNohdr,
      'pRowID': pRowID,
      'AllowedinspectionQty': allowedinspectionQty,
      'SampleSizeInspection': sampleSizeInspection,
      'InspectedQty': inspectedQty,
      'CriticalDefectsAllowed': criticalDefectsAllowed,
      'MajorDefectsAllowed': majorDefectsAllowed,
      'MinorDefectsAllowed': minorDefectsAllowed,
      'CartonsPacked2': cartonsPacked2,
      'AllowedCartonInspection': allowedCartonInspection,
      'CartonsPacked': cartonsPacked,
      'CartonsInspected': cartonsInspected,
      'QrItemID': qrItemID,
      'QRHdrID': qrHdrID,
      'QRPOItemHdrID': qrpoItemHdrID,
      'POItemDtlRowID': poItemDtlRowID,
      'SampleCodeID': sampleCodeID,
      'LatestDelDt': latestDelDt,
      'AvailableQty': availableQty,
      'AcceptedQty': acceptedQty,
      'FurtherInspectionReqd': furtherInspectionReqd,
      'Short': short,
      'ShortStockQty': shortStockQty,
      'CriticalDefect': criticalDefect,
      'MajorDefect': majorDefect,
      'MinorDefect': minorDefect,
      'recDirty': recDirty,
      'PONO': poNo,
      'ItemDescr': itemDescr,
      'OrderQty': orderQty,
      'EarlierInspected': earlierInspected,
      'CustomerItemRef': customerItemRef,
      'HologramNo': hologramNo,
      'POMasterPackQty': poMasterPackQty,
      'OPDescr': opDescr,
      'OPL': opL,
      'OPh': opH,
      'OPW': opW,
      'OPWt': opWt,
      'OPCBM': opCBM,
      'OPQty': opQty,
      'IPDimn': ipDimn,
      'IPL': ipL,
      'IPh': ipH,
      'IPW': ipW,
      'IPWt': ipWt,
      'IPCBM': ipCBM,
      'IPQty': ipQty,
      'PalletDimn': palletDimn,
      'PalletL': palletL,
      'Palleth': palletH,
      'PalletW': palletW,
      'PalletWt': palletWt,
      'PalletCBM': palletCBM,
      'PalletQty': palletQty,
      'IDimn': iDimn,
      'mapCountUnit': mapCountUnit,
      'mapCountInner': mapCountInner,
      'mapCountMaster': mapCountMaster,
      'mapCountPallet': mapCountPallet,
      'UnitL': unitL,
      'Unith': unitH,
      'UnitW': unitW,
      'Weight': weight,
      'CBM': cbm,
      'RetailPrice': retailPrice,
      'PKG_Me_InspectionResultID': pkgMeInspectionResultID,
      'PKG_Me_Master_InspectionResultID': pkgMeMasterInspectionResultID,
      'PKG_Me_Pallet_InspectionResultID': pkgMePalletInspectionResultID,
      'PKG_Me_Unit_InspectionResultID': pkgMeUnitInspectionResultID,
      'PKG_Me_Inner_InspectionResultID': pkgMeInnerInspectionResultID,
      'PKG_Me_Remark': pkgMeRemark,
      'OnSiteTest_Remark': onSiteTestRemark,
      'Qty_Remark': qtyRemark,
      'PKG_App_InspectionLevelID': pkgAppInspectionLevelID,
      'PKG_App_InspectionResultID': pkgAppInspectionResultID,
      'PKG_App_Pallet_InspectionResultID': pkgAppPalletInspectionResultID,
      'PKG_App_Pallet_SampleSizeID': pkgAppPalletSampleSizeID,
      'PKG_App_Pallet_SampleSizeValue': pkgAppPalletSampleSizeValue,
      'PKG_App_Master_SampleSizeID': pkgAppMasterSampleSizeID,
      'PKG_App_Master_SampleSizeValue': pkgAppMasterSampleSizeValue,
      'PKG_App_Master_InspectionResultID': pkgAppMasterInspectionResultID,
      'PKG_App_Inner_SampleSizeID': pkgAppInnerSampleSizeID,
      'PKG_App_Inner_SampleSizeValue': pkgAppInnerSampleSizeValue,
      'PKG_App_Unit_SampleSizeID': pkgAppUnitSampleSizeID,
      'PKG_App_Unit_InspectionResultID': pkgAppUnitInspectionResultID,
      'PKG_App_shippingMark_SampleSizeId': pkgAppShippingMarkSampleSizeId,
      'PKG_App_ShippingMark_InspectionResultID': pkgAppShippingMarkInspectionResultID,
      'PKG_App_Remark': pkgAppRemark,
      'WorkmanShip_InspectionResultID': workmanshipInspectionResultID,
      'WorkmanShip_Remark': workmanshipRemark,
      'ItemMeasurement_InspectionResultID': itemMeasurementInspectionResultID,
      'Overall_InspectionResultID': overallInspectionResultID,
      'ItemMeasurement_Remark': itemMeasurementRemark,
      'PKG_Me_Inner_FindingL': pkgMeInnerFindingL,
      'PKG_Me_Inner_FindingB': pkgMeInnerFindingB,
      'PKG_Me_Inner_FindingH': pkgMeInnerFindingH,
      'PKG_Me_Inner_FindingWt': pkgMeInnerFindingWt,
      'PKG_Me_Inner_FindingQty': pkgMeInnerFindingQty,
      'PKG_Me_Unit_FindingL': pkgMeUnitFindingL,
      'PKG_Me_Unit_FindingB': pkgMeUnitFindingB,
      'PKG_Me_Unit_FindingH': pkgMeUnitFindingH,
      'PKG_Me_Unit_FindingWt': pkgMeUnitFindingWt,
      'PKG_Me_Unit_FindingQty': pkgMeUnitFindingQty,
      'PKG_Me_Pallet_FindingL': pkgMePalletFindingL,
      'PKG_Me_Pallet_FindingB': pkgMePalletFindingB,
      'PKG_Me_Pallet_FindingH': pkgMePalletFindingH,
      'PKG_Me_Pallet_FindingWt': pkgMePalletFindingWt,
      'PKG_Me_Pallet_FindingQty': pkgMePalletFindingQty,
      'PKG_Me_Master_FindingL': pkgMeMasterFindingL,
      'PKG_Me_Master_FindingB': pkgMeMasterFindingB,
      'PKG_Me_Master_FindingH': pkgMeMasterFindingH,
      'PKG_Me_Master_FindingWt': pkgMeMasterFindingWt,
      'PKG_Me_Master_FindingQty': pkgMeMasterFindingQty,
      'PKG_Me_Master_SampleSizeID': pkgMeMasterSampleSizeID,
      'PKG_Me_Pallet_SampleSizeID': pkgMePalletSampleSizeID,
      'PKG_Me_Unit_SampleSizeID': pkgMeUnitSampleSizeID,
      'PKG_Me_Inner_SampleSizeID': pkgMeInnerSampleSizeID,
      'PKG_Me_Master_FindingCBM': pkgMeMasterFindingCBM,
      'PKG_Me_Pallet_FindingCBM': pkgMePalletFindingCBM,
      'PKG_Me_Unit_FindingCBM': pkgMeUnitFindingCBM,
      'PKG_Me_Inner_FindingCBM': pkgMeInnerFindingCBM,
      'IsQuantityContainerVisible': isQuantityContainerVisible,
      'IsWorkmanshipContainerVisible': isWorkmanshipContainerVisible,
      'IscartonDetailsContainerVisible': iscartonDetailsContainerVisible,
      'IsMoreDetailsContainerVisible': isMoreDetailsContainerVisible,
      'SampleSizeDescr': sampleSizeDescr,
      'ItemID': itemID,
      'QRItemBaseMaterialID': qrItemBaseMaterialID,
      'QRItemBaseMaterial_AddOnInfo': qrItemBaseMaterialAddOnInfo,
      'Barcode_InspectionResult': barcodeInspectionResult,
      'OnSiteTest_InspectionResult': onSiteTestInspectionResult,
      'ItemMeasurement_InspectionResult': itemMeasurementInspectionResult,
      'WorkmanShip_InspectionResult': workmanshipInspectionResult,
      'Overall_InspectionResult': overallInspectionResult,
      'PKG_Me_InspectionResult': pkgMeInspectionResult,
      'Digitals': digitals,
      'EnclCount': enclCount,
      'IsSelected': isSelected,
      'SizeBreakUP': sizeBreakUP,
      'ShipToBreakUP': shipToBreakUP,
      'testReportStatus': testReportStatus,
      'DuplicateFlag': duplicateFlag,
      'IsHologramExpired': isHologramExpired,
      'IsImportant': isImportant,
      'ItemRepeat': itemRepeat,
      'PKG_Me_Pallet_Digitals': pkgMePalletDigitals,
      'PKG_Me_Master_Digitals': pkgMeMasterDigitals,
      'PKG_Me_Inner_Digitals': pkgMeInnerDigitals,
      'PKG_Me_Unit_Digitals': pkgMeUnitDigitals,
      'PKG_Me_Shipping_Digitals': pkgMeShippingDigitals,
      'PKG_App_Unit_Digitals': pkgAppUnitDigitals,
      'PKG_App_Inner_Digitals': pkgAppInnerDigitals,
      'PKG_App_Master_Digitals': pkgAppMasterDigitals,
      'PKG_App_Pallet_Digitals': pkgAppPalletDigitals,
      'PKG_App_Shipping_Digitals': pkgAppShippingDigitals,
      'Barcode_InspectionLevelID': barcodeInspectionLevelID,
      'Barcode_InspectionResultID': barcodeInspectionResultID,
      'Barcode_Remark': barcodeRemark,
      'Barcode_Pallet_SampleSizeID': barcodePalletSampleSizeID,
      'Barcode_Pallet_SampleSizeValue': barcodePalletSampleSizeValue,
      'Barcode_Pallet_Scan': barcodePalletScan,
      'Barcode_Pallet_Visual': barcodePalletVisual,
      'Barcode_Pallet_InspectionResultID': barcodePalletInspectionResultID,
      'Barcode_Master_SampleSizeID': barcodeMasterSampleSizeID,
      'Barcode_Master_SampleSizeValue': barcodeMasterSampleSizeValue,
      'Barcode_Master_Visual': barcodeMasterVisual,
      'Barcode_Master_Scan': barcodeMasterScan,
      'Barcode_Inner_SampleSizeID': barcodeInnerSampleSizeID,
      'Barcode_Master_InspectionResultID': barcodeMasterInspectionResultID,
      'Barcode_Inner_SampleSizeValue': barcodeInnerSampleSizeValue,
      'Barcode_Inner_Visual': barcodeInnerVisual,
      'Barcode_Inner_Scan': barcodeInnerScan,
      'Barcode_Inner_InspectionResultID': barcodeInnerInspectionResultID,
      'Barcode_Unit_SampleSizeID': barcodeUnitSampleSizeID,
      'Barcode_Unit_SampleSizeValue': barcodeUnitSampleSizeValue,
      'Barcode_Unit_Visual': barcodeUnitVisual,
      'Barcode_Unit_Scan': barcodeUnitScan,
      'Barcode_Unit_InspectionResultID': barcodeUnitInspectionResultID,
    };
  }
} 