class POItemDtl {
  // Headers
  String? POhdr;
  String? Itemhdr;
  String? Orderhdr;
  String? InspectedTillDatehdr;
  String? Availablehdr;
  String? Acceptedhdr;
  String? Shorthdr;
  String? ShortStockQtyhdr;
  String? InspectLaterHr;
  String? workmanshipToInspectionhdr;
  String? Inspectedhdr;
  String? Criticalhdr;
  String? Majorhdr;
  String? Minorhdr;
  String? cartonPackeddr;
  String? cartonAvailable;
  String? cartonToInspectedhdr;
  String? packagingMeasurementhdr;
  String? barCodehdr;
  String? digitalUploadedhdr;
  String? enclosuresUploadedhdr;
  String? taskReportshdr;
  String? measurementshdr;
  String? SamplePurposehdr;
  String? OverallInspectionResulthdr;
  String? HologramNohdr;

  // PO Item header
  String? pRowID;
  int? AllowedinspectionQty;
  String? SampleSizeInspection;
  int? InspectedQty;
  int? CriticalDefectsAllowed;
  int? MajorDefectsAllowed;
  int? MinorDefectsAllowed;
  int? CartonsPacked2;
  int? AllowedCartonInspection;
  int? CartonsPacked;
  int? CartonsInspected;

  // PO Item detail
  String? QrItemID;
  String? QRHdrID;
  String? QRPOItemHdrID;
  String? POItemDtlRowID;
  String? SampleCodeID;
  String? LatestDelDt;
  int? AvailableQty;
  int? AcceptedQty;
  int? FurtherInspectionReqd;
  int? Short;
  int? ShortStockQty;

  int? CriticalDefect;
  int? MajorDefect;
  int? MinorDefect;
  int? recDirty;
  String? PONO;
  String? ItemDescr;
  String? OrderQty;
  int? EarlierInspected;
  String? CustomerItemRef;
  String? HologramNo;

  int? POMasterPackQty;

  // OP details
  String? OPDescr;
  double? OPL, OPh, OPW, OPWt, OPCBM;
  int? OPQty;

  // IP details
  String? IPDimn;
  double? IPL, IPh, IPW, IPWt, IPCBM;
  int? IPQty;

  // Pallet details
  String? PalletDimn;
  double? PalletL, Palleth, PalletW, PalletWt, PalletCBM;
  int? PalletQty;

  // Unit dimensions
  String? IDimn;
  int? mapCountUnit, mapCountInner, mapCountMaster, mapCountPallet;
  double? UnitL, Unith, UnitW;
  int? Weight;
  double? CBM;
  double? RetailPrice;

  // Packaging Measurement Results
  String? PKG_Me_InspectionResultID,
      PKG_Me_Master_InspectionResultID,
      PKG_Me_Pallet_InspectionResultID,
      PKG_Me_Unit_InspectionResultID,
      PKG_Me_Inner_InspectionResultID,
      PKG_Me_Remark,
      OnSiteTest_Remark,
      Qty_Remark;

  String? PKG_App_InspectionLevelID,
      PKG_App_InspectionResultID,
      PKG_App_Pallet_InspectionResultID,
      PKG_App_Pallet_SampleSizeID,
      PKG_App_Pallet_SampleSizeValue,
      PKG_App_Master_SampleSizeID,
      PKG_App_Master_SampleSizeValue,
      PKG_App_Master_InspectionResultID,
      PKG_App_Inner_SampleSizeID,
      PKG_App_Inner_SampleSizeValue,
      PKG_App_Unit_SampleSizeID,
      PKG_App_Unit_InspectionResultID,
      PKG_App_shippingMark_SampleSizeId,
      PKG_App_ShippingMark_InspectionResultID,
      PKG_App_Remark;

  String? OnSiteTest_InspectionResultID;
  String? WorkmanShip_InspectionResultID,
      WorkmanShip_Remark,
      ItemMeasurement_InspectionResultID,
      Overall_InspectionResultID,
      ItemMeasurement_Remark;

  List<String> unitPackingAttachmentList = [];
  List<String> innerPackingAttachmentList = [];
  List<String> masterPackingAttachmentList = [];
  List<String> palletPackingAttachmentList = [];

  List<String> unitBarcodeAttachmentList = [];
  List<String> innerBarcodeAttachmentList = [];
  List<String> masterBarcodeAttachmentList = [];
  List<String> palletBarcodeAttachmentList = [];

  double? PKG_Me_Inner_FindingL,
      PKG_Me_Inner_FindingB,
      PKG_Me_Inner_FindingH,
      PKG_Me_Inner_FindingWt,
      PKG_Me_Inner_FindingQty;

  double? PKG_Me_Unit_FindingL,
      PKG_Me_Unit_FindingB,
      PKG_Me_Unit_FindingH,
      PKG_Me_Unit_FindingWt,
      PKG_Me_Unit_FindingQty;

  double? PKG_Me_Pallet_FindingL,
      PKG_Me_Pallet_FindingB,
      PKG_Me_Pallet_FindingH,
      PKG_Me_Pallet_FindingWt,
      PKG_Me_Pallet_FindingQty;

  double? PKG_Me_Master_FindingL,
      PKG_Me_Master_FindingB,
      PKG_Me_Master_FindingH,
      PKG_Me_Master_FindingWt,
      PKG_Me_Master_FindingQty;

  String? PKG_Me_Master_SampleSizeID,
      PKG_Me_Pallet_SampleSizeID,
      PKG_Me_Unit_SampleSizeID,
      PKG_Me_Inner_SampleSizeID;

  double? PKG_Me_Master_FindingCBM,
      PKG_Me_Pallet_FindingCBM,
      PKG_Me_Unit_FindingCBM,
      PKG_Me_Inner_FindingCBM;

  int? IsQuantityContainerVisible;
  int? IsWorkmanshipContainerVisible;
  int? IscartonDetailsContainerVisible;
  int? IsMoreDetailsContainerVisible;

  String? SampleSizeDescr;
  String? ItemID;

  String? QRItemBaseMaterialID;
  String? QRItemBaseMaterial_AddOnInfo;

  String? Barcode_InspectionResult;
  String? OnSiteTest_InspectionResult;
  String? ItemMeasurement_InspectionResult;
  String? WorkmanShip_InspectionResult;
  String? Overall_InspectionResult;
  String? PKG_Me_InspectionResult;

  int? Digitals;
  int? EnclCount;
  int? IsSelected;
  int? SizeBreakUP;
  String? ShipToBreakUP;
  int? testReportStatus;
  int? DuplicateFlag;

  int? IsHologramExpired;
  int? IsImportant;
  int? ItemRepeat;

  String? PKG_Me_Pallet_Digitals,
      PKG_Me_Master_Digitals,
      PKG_Me_Inner_Digitals,
      PKG_Me_Unit_Digitals,
      PKG_Me_Shipping_Digitals;

  String? PKG_App_Unit_Digitals,
      PKG_App_Inner_Digitals,
      PKG_App_Master_Digitals,
      PKG_App_Pallet_Digitals,
      PKG_App_Shipping_Digitals;

  String? Barcode_InspectionLevelID;
  String? Barcode_InspectionResultID;
  String? Barcode_Remark;

  String? Barcode_Pallet_SampleSizeID;
  int? Barcode_Pallet_SampleSizeValue;
  String? Barcode_Pallet_Scan;
  String? Barcode_Pallet_Visual;
  String? Barcode_Pallet_InspectionResultID;

  String? Barcode_Master_SampleSizeID;
  int? Barcode_Master_SampleSizeValue;
  String? Barcode_Master_Visual;
  String? Barcode_Master_Scan;

  String? Barcode_Inner_SampleSizeID;
  int? Barcode_Inner_SampleSizeValue;
  String? Barcode_Inner_Visual;
  String? Barcode_Inner_Scan;
  String? Barcode_Inner_InspectionResultID;

  String? Barcode_Unit_SampleSizeID;
  int? Barcode_Unit_SampleSizeValue;
  String? Barcode_Unit_Visual;
  String? Barcode_Unit_Scan;
  String? Barcode_Unit_InspectionResultID;
}
