class FEnumerations {
  // Permissions
  static const int permissionRequest = 100;
  static const int readSmsPermission = 101;
  static const int cameraPermission = 102;
  static const int callPermission = 103;
  static const int readStoragePermission = 104;
  static const int photoPermission = 105;
  static const int saveContactPermission = 106;
  static const int saveDocPermission = 107;

  // Results
  static const int resultReadStorageDenied = 8;
  static const int resultCameraDenied = 9;
  static const int resultReadContacts = 10;
  static const int resultWriteContacts = 11;

  static const int resultCamera = 1;
  static const int resultGallery = 2;

  // Sync
  static const int syncInBackground = 1;
  static const int syncNotInBackground = 0;

  // Send options
  static const int optSend = 1;
  static const int optResend = 2;
  static const int optSubmit = 3;

  // Device density strings
  static const String deviceDensityLdpi = "0.75";
  static const String deviceDensityMdpi = "1.0";
  static const String deviceDensityHdpi = "1.5";
  static const String deviceDensityXhdpi = "2.0";
  static const String deviceDensityXxhdpi = "3.0";
  static const String deviceDensityXxxhdpi = "4.0";



  // Float density values
  static const double deviceDensityLdpiValue = 0.75;
  static const double deviceDensityMdpiValue = 1.0;
  static const double deviceDensityHdpiValue = 1.5;
  static const double deviceDensityXhdpiValue = 2.0;
  static const double deviceDensityXxhdpiValue = 3.0;
  static const double deviceDensityXxxhdpiValue = 4.0;

  // Result codes
  static const int resultLoadImage = 21;
  static const int imageCapture = 22;
  static const int pickfileResultCode = 23;

  static const int requestForProfileAdd = 1;
  static const int requestForProfileEdit = 2;

  static const int resultForDetailCode = 33;
  static const int resultPoItem = 21;
  static const int resultSizeQty = 89;

  static const int requestForChangePassword = 1;
  static const int requestForForgotPassword = 2;

  static const int requestForAlert = 1;
  static const int requestForTodayAlert = 2;

  // Boolean
  static const int trueValue = 1;
  static const int falseValue = 0;

  // View types
  static const int viewTypeItemQuality = 1;
  static const int viewTypeItemWorkmanship = 2;
  static const int viewTypeItemCarton = 3;
  static const int viewTypeMore = 4;

  // Packing fill requests
  static const int requestForInnerPackingFill = 1;
  static const int requestForAddPackingFill = 2;
  static const int requestForMasterPackingFill = 3;
  static const int requestForPalletPackingFill = 7;
  static const int requestForAddWorkmanship = 4;
  static const int requestForUnitPackingFill = 5;
  static const int requestForAddDigitalsUpload = 6;
  static const int requestForAddItemMeasurement = 8;
  static const int requestForAddItemMeasurementFinding = 9;
  static const int requestForEditWorkmanship = 10;
  static const int requestForEditItemMeasurement = 11;
  static const int requestForAddIntimation = 22;
  static const int requestForAddHologram = 33;

  // Attachment requests
  static const int requestForMasterPackingAttachment = 1;
  static const int requestForInnerPackingAttachment = 2;
  static const int requestForUnitPackingAttachment = 3;
  static const int requestForPalletPackingAttachment = 4;
  static const int requestForQualityParameterAttachment = 5;
  static const int requestForInternalTestAttachment = 6;
  static const int requestForEnclosureAttachment = 6;
  static const int requestForUnitPkgAppAttachment = 131;
  static const int requestForShippingPkgAppAttachment = 132;
  static const int requestForInnerPkgAppAttachment = 133;
  static const int requestForMasterPkgAppAttachment = 134;
  static const int requestForPalletPkgAppAttachment = 135;
  static const int requestForUnitBarcodeAttachment = 136;
  static const int requestForInnerBarcodeAttachment = 137;
  static const int requestForMasterBarcodeAttachment = 138;
  static const int requestForPalletBarcodeAttachment = 139;
  static const int requestForOnSiteAttachment = 140;

  // Status IDs
  static const String statusGenId = "36";
  static const String overallResultStatusGenId = "530";
  static const String packageAppearanceOverallResultStatusGenId = "550";
  static const String onsiteOverallResultStatusGenId = "545";
  static const String sampleCollectedOverallResultStatusGenId = "540";

  // View type details
  static const int viewTypeQualityParameterDetailLevel = 5;
  static const int viewTypeQualityParameterInspectionLevel = 6;
  static const int viewTypeInternalTestLevel = 7;

  static const int viewOnlySend = 1;
  static const int viewOnlyGet = 2;
  static const int viewOnlySync = 3;
  static const int viewSendAndSync = 4;

  static const String imageExtn = "jpg";

  // Packaging subsystems
  static const String pkgAppGenId = "79";
  static const String pkgAppMainId = "51";
  static const String pkgAppSubId = "30";
  static const String pkgMeasurementSubId = "31";
  static const String barcodeSubId = "33";
  static const String onsiteTestSubId = "34";
  static const String workmanshipSubId = "35";
  static const String samplePurposeSubId = "36";
  static const String itemMeasurementSubId = "37";
  static const String digitalUploadSubId = "38";
  static const String enclosureSubId = "39";
  static const String testReportSubId = "40";
  static const String qualityParameterSubId = "88";
  static const String internalTestSubId = "95";

  // Table names
  static const String tableQrpoItemHdr = "Table0";
  static const String tableQrpoItemDtl = "Table1";
  static const String tableQrpoItemDtlImage = "Table2";
  static const String tableQrpoIntimationDetails = "Table3";
  static const String tableGenMst = "Table4";
  static const String tableSysData22 = "Table5";
  static const String tableQualityLevel = "Table6";
  static const String tableQualityLevelDtl = "Table7";
  static const String tableInsplvlHdr = "Table8";
  static const String tableInspLvlDtl = "Table9";
  static const String tableEnclosures = "Table10";
  static const String tableQRInspectionHistory = "Table11";
  static const String tableTestReport = "Table12";
  static const String tableUserMasterUpdateCriticalAllowed = "Table13";
  static const String tableItemMeasurement = "Table14";
  static const String tableAuditBatchDetails = "Table15";
  static const String tableSizeQuantity = "Table16";
    static const String tableGenQualityParameterProductMap = "Table17";
    static const String tableQrFeedback = "Table18";

  static const String tableNameQrpoItemHdr = "QRPOItemHdr";
  static const String tableNameQrpoItemDtl = "QRPOItemDtl";
  static const String tableNameQrpoItemDtlImage = "QRPOItemDtl_Image";
  static const String tableNameSamplePurpose = "QRPOItemDtl_Sample_Purpose";
  static const String tableNameOnSiteTest = "QRPOItemDtl_OnSite_Test";
  static const String tableNamePkgAppDetails = "QRPOItemDtl_PKG_App_Details";
  static const String tableNameIntimationDetails = "QRPOIntimationDetails";
  static const String tableNameGenMst = "GenMst";
  static const String tableNameSysData22 = "SysData22";
  static const String tableNameQualityLevel = "QualityLevel";
  static const String tableNameQualityLevelDtl = "QualityLevelDtl";
  static const String tableNameInsplvlHdr = "InsplvlHdr";
  static const String tableNameInspLvlDtl = "InspLvlDtl";
  static const String tableNameEnclosures = "Enclosures";
  static const String tableNameInspectionHistory = "QRInspectionHistory";
  static const String tableNameTestReport = "TestReport";
  static const String tableNameItemMeasurement = "QRPOItemDtl_ItemMeasurement";
  static const String tableNameAuditBatchDetails = "QRAuditBatchDetails";
  static const String tableNameQRFindings = "QRFindings";

  // Sync
  static const String syncHeaderTable = "HEADER";
  static const String syncSizeQuantityTable = "SIZE QUANTITY";
  static const String syncImagesTable = "IMAGE";
  static const String syncWorkmanshipTable = "WORKMANSHIP";
  static const String syncItemMeasurementTable = "ITEM MEASUREMENT";
  static const String syncFindingTable = "FINDING";
  static const String syncQualityParameterTable = "QUALITY PARAMETER";
  static const String syncFitnessCheckTable = "FITNESS CHECK";
  static const String syncProductionStatusTable = "PRODUCTION STATUS";
  static const String syncIntimationTable = "INTIMATION";
  static const String syncEnclosureTable = "ENCLOSURE";
  static const String syncDigitalUploadTable = "DIGITAL";
  static const String syncFinalizeTable = "FINALIZE";
  static const String syncStyle = "STYLE";
  static const String syncPkgAppearance = "PACKAGING APPEARANCE";
  static const String syncOnSite = "ON SITE";
  static const String syncSampleCollected = "SAMPLE COLLECTED";

  static const int syncPendingStatus = 0;
  static const int syncInProcessStatus = 1;
  static const int syncSuccessStatus = 2;
  static const int syncFailedStatus = 3;

  // Menu
  static const int menuPoViewTypeHeader = 1;
  static const int menuPoViewTypeDtl = 2;
  static const int menuPoViewTypeParameterQuality = 3;
  static const int menuPoViewTypeProductionStatus = 4;
  static const int menuPoViewTypeEnclosure = 5;

  static const int downloadTestReport = 1;
  static const int downloadEnclosure = 2;

  static const int adaptorViewTypeQualityParameter = 1;
  static const int adaptorViewTypeInternal = 2;

  static const int inspectionReportLevel = 1;
  static const int inspectionMaterialLevel = 2;

  static const String overAllFailResult = "DEL0002717";
  static const String overAllHoldResult = "DEL0002773";
  static const String overAllDescResult = "DEL0002770";

  static const int viewTypeHistory = 2;
  static const int viewTypeNormal = 1;

  static const int viewTypeInspection = 1;
  static const int viewTypeSync = 2;
  static const int viewTypeHologramStyle = 3;
  static const int viewTypeStyleList = 4;

  static const int userTypeAdmin = 1;
  static const int userTypeQR = 2;
  static const int userTypeMR = 3;

  static const int sendFileImageStyle = 2;
  static const int sendFileImageInspection = 0;
  static const int sendFileImageEnclosure = 1;
}
