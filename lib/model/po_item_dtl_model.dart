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
      pOhdr: json['POhdr']?.toString(),
      itemhdr: json['Itemhdr']?.toString(),
      orderhdr: json['Orderhdr']?.toString(),
      inspectedTillDatehdr: json['InspectedTillDatehdr']?.toString(),
      availablehdr: json['Availablehdr']?.toString(),
      acceptedhdr: json['Acceptedhdr']?.toString(),
      shorthdr: json['Shorthdr']?.toString(),
      shortStockQtyhdr: json['ShortStockQtyhdr']?.toString(),
      inspectLaterHr: json['InspectLaterHr']?.toString(),
      workmanshipToInspectionhdr: json['workmanshipToInspectionhdr']?.toString(),
      inspectedhdr: json['Inspectedhdr']?.toString(),
      criticalhdr: json['Criticalhdr']?.toString(),
      majorhdr: json['Majorhdr']?.toString(),
      minorhdr: json['Minorhdr']?.toString(),
      cartonPackeddr: json['cartonPackeddr']?.toString(),
      cartonAvailable: json['cartonAvailable']?.toString(),
      cartonToInspectedhdr: json['cartonToInspectedhdr']?.toString(),
      packagingMeasurementhdr: json['packagingMeasurementhdr']?.toString(),
      barCodehdr: json['barCodehdr']?.toString(),
      digitalUploadedhdr: json['digitalUploadedhdr']?.toString(),
      enclosuresUploadedhdr: json['enclosuresUploadedhdr']?.toString(),
      taskReportshdr: json['taskReportshdr']?.toString(),
      measurementshdr: json['measurementshdr']?.toString(),
      samplePurposehdr: json['SamplePurposehdr']?.toString(),
      overallInspectionResulthdr: json['OverallInspectionResulthdr']?.toString(),
      hologramNohdr: json['HologramNohdr']?.toString(),
      pRowID: json['pRowID']?.toString(),
      allowedinspectionQty: json['AllowedinspectionQty'] != null ? (json['AllowedinspectionQty'] is double ? json['AllowedinspectionQty'].toInt() : json['AllowedinspectionQty']) : null,
      sampleSizeInspection: json['SampleSizeInspection']?.toString(),
      inspectedQty: json['InspectedQty'] != null ? (json['InspectedQty'] is double ? json['InspectedQty'].toInt() : json['InspectedQty']) : null,
      criticalDefectsAllowed: json['CriticalDefectsAllowed'] != null ? (json['CriticalDefectsAllowed'] is double ? json['CriticalDefectsAllowed'].toInt() : json['CriticalDefectsAllowed']) : null,
      majorDefectsAllowed: json['MajorDefectsAllowed'] != null ? (json['MajorDefectsAllowed'] is double ? json['MajorDefectsAllowed'].toInt() : json['MajorDefectsAllowed']) : null,
      minorDefectsAllowed: json['MinorDefectsAllowed'] != null ? (json['MinorDefectsAllowed'] is double ? json['MinorDefectsAllowed'].toInt() : json['MinorDefectsAllowed']) : null,
      cartonsPacked2: json['CartonsPacked2'] != null ? (json['CartonsPacked2'] is double ? json['CartonsPacked2'].toInt() : json['CartonsPacked2']) : null,
      allowedCartonInspection: json['AllowedCartonInspection'] != null ? (json['AllowedCartonInspection'] is double ? json['AllowedCartonInspection'].toInt() : json['AllowedCartonInspection']) : null,
      cartonsPacked: json['CartonsPacked'] != null ? (json['CartonsPacked'] is double ? json['CartonsPacked'].toInt() : json['CartonsPacked']) : null,
      cartonsInspected: json['CartonsInspected'] != null ? (json['CartonsInspected'] is double ? json['CartonsInspected'].toInt() : json['CartonsInspected']) : null,
      qrItemID: json['QrItemID']?.toString(),
      qrHdrID: json['QRHdrID']?.toString(),
      qrpoItemHdrID: json['QRPOItemHdrID']?.toString(),
      poItemDtlRowID: json['POItemDtlRowID']?.toString(),
      sampleCodeID: json['SampleCodeID']?.toString(),
      latestDelDt: json['LatestDelDt']?.toString(),
      availableQty: json['AvailableQty'] != null ? (json['AvailableQty'] is double ? json['AvailableQty'].toInt() : json['AvailableQty']) : null,
      acceptedQty: json['AcceptedQty'] != null ? (json['AcceptedQty'] is double ? json['AcceptedQty'].toInt() : json['AcceptedQty']) : null,
      furtherInspectionReqd: json['FurtherInspectionReqd'] != null ? (json['FurtherInspectionReqd'] is double ? json['FurtherInspectionReqd'].toInt() : json['FurtherInspectionReqd']) : null,
      short: json['Short'] != null ? (json['Short'] is double ? json['Short'].toInt() : json['Short']) : null,
      shortStockQty: json['ShortStockQty'] != null ? (json['ShortStockQty'] is double ? json['ShortStockQty'].toInt() : json['ShortStockQty']) : null,
      criticalDefect: json['CriticalDefect'] != null ? (json['CriticalDefect'] is double ? json['CriticalDefect'].toInt() : json['CriticalDefect']) : null,
      majorDefect: json['MajorDefect'] != null ? (json['MajorDefect'] is double ? json['MajorDefect'].toInt() : json['MajorDefect']) : null,
      minorDefect: json['MinorDefect'] != null ? (json['MinorDefect'] is double ? json['MinorDefect'].toInt() : json['MinorDefect']) : null,
      recDirty: json['recDirty'] != null ? (json['recDirty'] is double ? json['recDirty'].toInt() : json['recDirty']) : null,
      poNo: json['PONO']?.toString(),
      itemDescr: json['ItemDescr']?.toString(),
      orderQty: json['OrderQty']?.toString(),
      earlierInspected: json['EarlierInspected'] != null ? (json['EarlierInspected'] is double ? json['EarlierInspected'].toInt() : json['EarlierInspected']) : null,
      customerItemRef: json['CustomerItemRef']?.toString(),
      hologramNo: json['HologramNo']?.toString(),
      poMasterPackQty: json['POMasterPackQty'] != null ? (json['POMasterPackQty'] is double ? json['POMasterPackQty'].toInt() : json['POMasterPackQty']) : null,
      opDescr: json['OPDescr']?.toString(),
      opL: json['OPL']?.toDouble(),
      opH: json['OPh']?.toDouble(),
      opW: json['OPW']?.toDouble(),
      opWt: json['OPWt']?.toDouble(),
      opCBM: json['OPCBM']?.toDouble(),
      opQty: json['OPQty'] != null ? (json['OPQty'] is double ? json['OPQty'].toInt() : json['OPQty']) : null,
      ipDimn: json['IPDimn']?.toString(),
      ipL: json['IPL']?.toDouble(),
      ipH: json['IPh']?.toDouble(),
      ipW: json['IPW']?.toDouble(),
      ipWt: json['IPWt']?.toDouble(),
      ipCBM: json['IPCBM']?.toDouble(),
      ipQty: json['IPQty'] != null ? (json['IPQty'] is double ? json['IPQty'].toInt() : json['IPQty']) : null,
      palletDimn: json['PalletDimn']?.toString(),
      palletL: json['PalletL']?.toDouble(),
      palletH: json['Palleth']?.toDouble(),
      palletW: json['PalletW']?.toDouble(),
      palletWt: json['PalletWt']?.toDouble(),
      palletCBM: json['PalletCBM']?.toDouble(),
      palletQty: json['PalletQty'] != null ? (json['PalletQty'] is double ? json['PalletQty'].toInt() : json['PalletQty']) : null,
      iDimn: json['IDimn']?.toString(),
      mapCountUnit: json['mapCountUnit'] != null ? (json['mapCountUnit'] is double ? json['mapCountUnit'].toInt() : json['mapCountUnit']) : null,
      mapCountInner: json['mapCountInner'] != null ? (json['mapCountInner'] is double ? json['mapCountInner'].toInt() : json['mapCountInner']) : null,
      mapCountMaster: json['mapCountMaster'] != null ? (json['mapCountMaster'] is double ? json['mapCountMaster'].toInt() : json['mapCountMaster']) : null,
      mapCountPallet: json['mapCountPallet'] != null ? (json['mapCountPallet'] is double ? json['mapCountPallet'].toInt() : json['mapCountPallet']) : null,
      unitL: json['UnitL']?.toDouble(),
      unitH: json['Unith']?.toDouble(),
      unitW: json['UnitW']?.toDouble(),
      weight: json['Weight'] != null ? (json['Weight'] is double ? json['Weight'].toInt() : json['Weight']) : null,
      cbm: json['CBM']?.toDouble(),
      retailPrice: json['RetailPrice']?.toDouble(),
      pkgMeInspectionResultID: json['PKG_Me_InspectionResultID']?.toString(),
      pkgMeMasterInspectionResultID: json['PKG_Me_Master_InspectionResultID']?.toString(),
      pkgMePalletInspectionResultID: json['PKG_Me_Pallet_InspectionResultID']?.toString(),
      pkgMeUnitInspectionResultID: json['PKG_Me_Unit_InspectionResultID']?.toString(),
      pkgMeInnerInspectionResultID: json['PKG_Me_Inner_InspectionResultID']?.toString(),
      pkgMeRemark: json['PKG_Me_Remark']?.toString(),
      onSiteTestRemark: json['OnSiteTest_Remark']?.toString(),
      qtyRemark: json['Qty_Remark']?.toString(),
      pkgAppInspectionLevelID: json['PKG_App_InspectionLevelID']?.toString(),
      pkgAppInspectionResultID: json['PKG_App_InspectionResultID']?.toString(),
      pkgAppPalletInspectionResultID: json['PKG_App_Pallet_InspectionResultID']?.toString(),
      pkgAppPalletSampleSizeID: json['PKG_App_Pallet_SampleSizeID']?.toString(),
      pkgAppPalletSampleSizeValue: json['PKG_App_Pallet_SampleSizeValue'] != null ? (json['PKG_App_Pallet_SampleSizeValue'] is double ? json['PKG_App_Pallet_SampleSizeValue'].toInt() : json['PKG_App_Pallet_SampleSizeValue']) : null,
      pkgAppMasterSampleSizeID: json['PKG_App_Master_SampleSizeID']?.toString(),
      pkgAppMasterSampleSizeValue: json['PKG_App_Master_SampleSizeValue'] != null ? (json['PKG_App_Master_SampleSizeValue'] is double ? json['PKG_App_Master_SampleSizeValue'].toInt() : json['PKG_App_Master_SampleSizeValue']) : null,
      pkgAppMasterInspectionResultID: json['PKG_App_Master_InspectionResultID']?.toString(),
      pkgAppInnerSampleSizeID: json['PKG_App_Inner_SampleSizeID']?.toString(),
      pkgAppInnerSampleSizeValue: json['PKG_App_Inner_SampleSizeValue'] != null ? (json['PKG_App_Inner_SampleSizeValue'] is double ? json['PKG_App_Inner_SampleSizeValue'].toInt() : json['PKG_App_Inner_SampleSizeValue']) : null,
      pkgAppUnitSampleSizeID: json['PKG_App_Unit_SampleSizeID']?.toString(),
      pkgAppUnitInspectionResultID: json['PKG_App_Unit_InspectionResultID']?.toString(),
      pkgAppShippingMarkSampleSizeId: json['PKG_App_shippingMark_SampleSizeId']?.toString(),
      pkgAppShippingMarkInspectionResultID: json['PKG_App_ShippingMark_InspectionResultID']?.toString(),
      pkgAppRemark: json['PKG_App_Remark']?.toString(),
      workmanshipInspectionResultID: json['WorkmanShip_InspectionResultID']?.toString(),
      workmanshipRemark: json['WorkmanShip_Remark']?.toString(),
      itemMeasurementInspectionResultID: json['ItemMeasurement_InspectionResultID']?.toString(),
      overallInspectionResultID: json['Overall_InspectionResultID']?.toString(),
      itemMeasurementRemark: json['ItemMeasurement_Remark']?.toString(),
      pkgMeInnerFindingL: json['PKG_Me_Inner_FindingL']?.toDouble(),
      pkgMeInnerFindingB: json['PKG_Me_Inner_FindingB']?.toDouble(),
      pkgMeInnerFindingH: json['PKG_Me_Inner_FindingH']?.toDouble(),
      pkgMeInnerFindingWt: json['PKG_Me_Inner_FindingWt']?.toDouble(),
      pkgMeInnerFindingQty: json['PKG_Me_Inner_FindingQty']?.toDouble(),
      pkgMeUnitFindingL: json['PKG_Me_Unit_FindingL']?.toDouble(),
      pkgMeUnitFindingB: json['PKG_Me_Unit_FindingB']?.toDouble(),
      pkgMeUnitFindingH: json['PKG_Me_Unit_FindingH']?.toDouble(),
      pkgMeUnitFindingWt: json['PKG_Me_Unit_FindingWt']?.toDouble(),
      pkgMeUnitFindingQty: json['PKG_Me_Unit_FindingQty']?.toDouble(),
      pkgMePalletFindingL: json['PKG_Me_Pallet_FindingL']?.toDouble(),
      pkgMePalletFindingB: json['PKG_Me_Pallet_FindingB']?.toDouble(),
      pkgMePalletFindingH: json['PKG_Me_Pallet_FindingH']?.toDouble(),
      pkgMePalletFindingWt: json['PKG_Me_Pallet_FindingWt']?.toDouble(),
      pkgMePalletFindingQty: json['PKG_Me_Pallet_FindingQty']?.toDouble(),
      pkgMeMasterFindingL: json['PKG_Me_Master_FindingL']?.toDouble(),
      pkgMeMasterFindingB: json['PKG_Me_Master_FindingB']?.toDouble(),
      pkgMeMasterFindingH: json['PKG_Me_Master_FindingH']?.toDouble(),
      pkgMeMasterFindingWt: json['PKG_Me_Master_FindingWt']?.toDouble(),
      pkgMeMasterFindingQty: json['PKG_Me_Master_FindingQty']?.toDouble(),
      pkgMeMasterSampleSizeID: json['PKG_Me_Master_SampleSizeID']?.toString(),
      pkgMePalletSampleSizeID: json['PKG_Me_Pallet_SampleSizeID']?.toString(),
      pkgMeUnitSampleSizeID: json['PKG_Me_Unit_SampleSizeID']?.toString(),
      pkgMeInnerSampleSizeID: json['PKG_Me_Inner_SampleSizeID']?.toString(),
      pkgMeMasterFindingCBM: json['PKG_Me_Master_FindingCBM']?.toDouble(),
      pkgMePalletFindingCBM: json['PKG_Me_Pallet_FindingCBM']?.toDouble(),
      pkgMeUnitFindingCBM: json['PKG_Me_Unit_FindingCBM']?.toDouble(),
      pkgMeInnerFindingCBM: json['PKG_Me_Inner_FindingCBM']?.toDouble(),
      isQuantityContainerVisible: json['IsQuantityContainerVisible'] != null ? (json['IsQuantityContainerVisible'] is double ? json['IsQuantityContainerVisible'].toInt() : json['IsQuantityContainerVisible']) : null,
      isWorkmanshipContainerVisible: json['IsWorkmanshipContainerVisible'] != null ? (json['IsWorkmanshipContainerVisible'] is double ? json['IsWorkmanshipContainerVisible'].toInt() : json['IsWorkmanshipContainerVisible']) : null,
      iscartonDetailsContainerVisible: json['IscartonDetailsContainerVisible'] != null ? (json['IscartonDetailsContainerVisible'] is double ? json['IscartonDetailsContainerVisible'].toInt() : json['IscartonDetailsContainerVisible']) : null,
      isMoreDetailsContainerVisible: json['IsMoreDetailsContainerVisible'] != null ? (json['IsMoreDetailsContainerVisible'] is double ? json['IsMoreDetailsContainerVisible'].toInt() : json['IsMoreDetailsContainerVisible']) : null,
      sampleSizeDescr: json['SampleSizeDescr']?.toString(),
      itemID: json['ItemID']?.toString(),
      qrItemBaseMaterialID: json['QRItemBaseMaterialID']?.toString(),
      qrItemBaseMaterialAddOnInfo: json['QRItemBaseMaterial_AddOnInfo']?.toString(),
      barcodeInspectionResult: json['Barcode_InspectionResult']?.toString(),
      onSiteTestInspectionResult: json['OnSiteTest_InspectionResult']?.toString(),
      itemMeasurementInspectionResult: json['ItemMeasurement_InspectionResult']?.toString(),
      workmanshipInspectionResult: json['WorkmanShip_InspectionResult']?.toString(),
      overallInspectionResult: json['Overall_InspectionResult']?.toString(),
      pkgMeInspectionResult: json['PKG_Me_InspectionResult']?.toString(),
      digitals: json['Digitals'] != null ? (json['Digitals'] is double ? json['Digitals'].toInt() : json['Digitals']) : null,
      enclCount: json['EnclCount'] != null ? (json['EnclCount'] is double ? json['EnclCount'].toInt() : json['EnclCount']) : null,
      isSelected: json['IsSelected'] != null ? (json['IsSelected'] is double ? json['IsSelected'].toInt() : json['IsSelected']) : null,
      sizeBreakUP: json['SizeBreakUP'] != null ? (json['SizeBreakUP'] is double ? json['SizeBreakUP'].toInt() : json['SizeBreakUP']) : null,
      shipToBreakUP: json['ShipToBreakUP']?.toString(),
      testReportStatus: json['testReportStatus'] != null ? (json['testReportStatus'] is double ? json['testReportStatus'].toInt() : json['testReportStatus']) : null,
      duplicateFlag: json['DuplicateFlag'] != null ? (json['DuplicateFlag'] is double ? json['DuplicateFlag'].toInt() : json['DuplicateFlag']) : null,
      isHologramExpired: json['IsHologramExpired'] != null ? (json['IsHologramExpired'] is double ? json['IsHologramExpired'].toInt() : json['IsHologramExpired']) : null,
      isImportant: json['IsImportant'] != null ? (json['IsImportant'] is double ? json['IsImportant'].toInt() : json['IsImportant']) : null,
      itemRepeat: json['ItemRepeat'] != null ? (json['ItemRepeat'] is double ? json['ItemRepeat'].toInt() : json['ItemRepeat']) : null,
      pkgMePalletDigitals: json['PKG_Me_Pallet_Digitals']?.toString(),
      pkgMeMasterDigitals: json['PKG_Me_Master_Digitals']?.toString(),
      pkgMeInnerDigitals: json['PKG_Me_Inner_Digitals']?.toString(),
      pkgMeUnitDigitals: json['PKG_Me_Unit_Digitals']?.toString(),
      pkgMeShippingDigitals: json['PKG_Me_Shipping_Digitals']?.toString(),
      pkgAppUnitDigitals: json['PKG_App_Unit_Digitals']?.toString(),
      pkgAppInnerDigitals: json['PKG_App_Inner_Digitals']?.toString(),
      pkgAppMasterDigitals: json['PKG_App_Master_Digitals']?.toString(),
      pkgAppPalletDigitals: json['PKG_App_Pallet_Digitals']?.toString(),
      pkgAppShippingDigitals: json['PKG_App_Shipping_Digitals']?.toString(),
      barcodeInspectionLevelID: json['Barcode_InspectionLevelID']?.toString(),
      barcodeInspectionResultID: json['Barcode_InspectionResultID']?.toString(),
      barcodeRemark: json['Barcode_Remark']?.toString(),
      barcodePalletSampleSizeID: json['Barcode_Pallet_SampleSizeID']?.toString(),
      barcodePalletSampleSizeValue: json['Barcode_Pallet_SampleSizeValue'] != null ? (json['Barcode_Pallet_SampleSizeValue'] is double ? json['Barcode_Pallet_SampleSizeValue'].toInt() : json['Barcode_Pallet_SampleSizeValue']) : null,
      barcodePalletScan: json['Barcode_Pallet_Scan']?.toString(),
      barcodePalletVisual: json['Barcode_Pallet_Visual']?.toString(),
      barcodePalletInspectionResultID: json['Barcode_Pallet_InspectionResultID']?.toString(),
      barcodeMasterSampleSizeID: json['Barcode_Master_SampleSizeID']?.toString(),
      barcodeMasterSampleSizeValue: json['Barcode_Master_SampleSizeValue'] != null ? (json['Barcode_Master_SampleSizeValue'] is double ? json['Barcode_Master_SampleSizeValue'].toInt() : json['Barcode_Master_SampleSizeValue']) : null,
      barcodeMasterVisual: json['Barcode_Master_Visual']?.toString(),
      barcodeMasterScan: json['Barcode_Master_Scan']?.toString(),
      barcodeInnerSampleSizeID: json['Barcode_Inner_SampleSizeID']?.toString(),
      barcodeMasterInspectionResultID: json['Barcode_Master_InspectionResultID']?.toString(),
      barcodeInnerSampleSizeValue: json['Barcode_Inner_SampleSizeValue'] != null ? (json['Barcode_Inner_SampleSizeValue'] is double ? json['Barcode_Inner_SampleSizeValue'].toInt() : json['Barcode_Inner_SampleSizeValue']) : null,
      barcodeInnerVisual: json['Barcode_Inner_Visual']?.toString(),
      barcodeInnerScan: json['Barcode_Inner_Scan']?.toString(),
      barcodeInnerInspectionResultID: json['Barcode_Inner_InspectionResultID']?.toString(),
      barcodeUnitSampleSizeID: json['Barcode_Unit_SampleSizeID']?.toString(),
      barcodeUnitSampleSizeValue: json['Barcode_Unit_SampleSizeValue'] != null ? (json['Barcode_Unit_SampleSizeValue'] is double ? json['Barcode_Unit_SampleSizeValue'].toInt() : json['Barcode_Unit_SampleSizeValue']) : null,
      barcodeUnitVisual: json['Barcode_Unit_Visual']?.toString(),
      barcodeUnitScan: json['Barcode_Unit_Scan']?.toString(),
      barcodeUnitInspectionResultID: json['Barcode_Unit_InspectionResultID']?.toString(),
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

  String get itemCode => itemDescr?.split(' ')[0] ?? '';
} 