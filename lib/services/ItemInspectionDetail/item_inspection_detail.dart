// import 'package:buyerease/model/workmanship_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../model/po_item_dtl_model.dart';
// import '../../utils/app_constants.dart';
//
//
// class ItemInspectionDetailPage extends StatefulWidget {
//   const ItemInspectionDetailPage({Key? key}) : super(key: key);
//
//   @override
//   State<ItemInspectionDetailPage> createState() => _ItemInspectionDetailPageState();
// }
//
// class _ItemInspectionDetailPageState extends State<ItemInspectionDetailPage> {
//   // UI fields (partial, add more as needed)
//   // In Flutter, you usually use controllers for text fields and manage state for others
//   final TextEditingController editPackingRemarkController = TextEditingController();
//   final TextEditingController editWorkmanshipRemarkController = TextEditingController();
//   final TextEditingController editItemMeasurementRemarkController = TextEditingController();
//   final TextEditingController editOnSiteRemarkController = TextEditingController();
//   final TextEditingController editPackingAppearRemarkController = TextEditingController();
//   final TextEditingController editItemQtyRemarkController = TextEditingController();
//
//   // Example lists (replace dynamic with your model types)
//   List<WorkmanshipModel> workManShipModels = [];
//   List<dynamic> workManShipHistoryModels = [];
//   List<dynamic> digitalsUploadModals = [];
//   List<dynamic> historyInspectionModalList = [];
//   List<dynamic> enclosureModalList = [];
//   List<dynamic> testReportModals = [];
//   List<dynamic> itemMeasurementModalList = [];
//   List<dynamic> itemMeasurementHistoryModalList = [];
//   List<dynamic> qualityParameterList = [];
//   List<dynamic> internalTestList = [];
//
//   // Example state variables
//   int viewFlipperIndex = 0;
//   String? workManShipRemark;
//   String? itemMeasurementRemark;
//   String tag = "ItemInspectionDetail";
//   bool? spinnerTouched;
//   bool? spinnerOnSiteSampleSizeTouched;
//   bool? spinnerOnSiteOverAllTouched;
//   bool? spinnerPkgAppeOverAllTouched;
//   bool? spinnerPkgAppSampleTouched;
//
//   // Example attachment lists for packaging appearance
//   List<String> unitPkgAppAttachmentList = [];
//   List<String> shippingPkgAppAttachmentList = [];
//   List<String> innerPkgAppAttachmentList = [];
//   List<String> masterPkgAppAttachmentList = [];
//   List<String> palletPkgAppAttachmentList = [];
//
//   // Example POItemDtl, InspectionModal, etc. (replace dynamic with your model types)
//   dynamic poItemDtl;
//   dynamic inspectionModal;
//   POItemDtl packagePoItemDetalDetail =   POItemDtl();
//   dynamic onSIteModal;
//   dynamic sampleCollectedModal;
//   dynamic pOItemPkgAppDetail;
//
//   // Static-like variables
//   static int qualityParameterAttachmentPos = -1;
//   static int iternalTestAttachmentPos = -1;
//
//   // Ported: Setup for On-Site Description Dropdowns (spinners)
//   // In Flutter, use DropdownButton and manage selected values in state
//   List<String> inspectionLevelAbbrvs = [];
//   List<dynamic> insLvHdrModals = [];
//   List<dynamic> onSiteList = [];
//   int? selectedOnSiteDesc1;
//   int? selectedOnSiteDesc2;
//   int? selectedOnSiteDesc3;
//   int? selectedOnSiteDesc4;
//   int? selectedOnSiteDesc5;
//   int? selectedOnSiteDesc6;
//   int? selectedOnSiteDesc7;
//   int? selectedOnSiteDesc8;
//   int? selectedOnSiteDesc9;
//   int? selectedOnSiteDesc10;
//
//   void setupOnSiteDropdowns() {
//     // Populate inspectionLevelAbbrvs from insLvHdrModals
//     inspectionLevelAbbrvs = insLvHdrModals.map((e) => e['InspAbbrv'] as String).toList();
//     // Set initial selected values based on onSiteList and insLvHdrModals
//     // This is a sketch; adapt to your actual data structure
//     for (int i = 0; i < onSiteList.length; i++) {
//       final inspectionLevelID = onSiteList[i]['InspectionLevelID'];
//       final idx = insLvHdrModals.indexWhere((e) => e['pRowID'] == inspectionLevelID);
//       switch (i) {
//         case 0:
//           selectedOnSiteDesc1 = idx >= 0 ? idx : null;
//           break;
//         case 1:
//           selectedOnSiteDesc2 = idx >= 0 ? idx : null;
//           break;
//         case 2:
//           selectedOnSiteDesc3 = idx >= 0 ? idx : null;
//           break;
//         case 3:
//           selectedOnSiteDesc4 = idx >= 0 ? idx : null;
//           break;
//         case 4:
//           selectedOnSiteDesc5 = idx >= 0 ? idx : null;
//           break;
//         case 5:
//           selectedOnSiteDesc6 = idx >= 0 ? idx : null;
//           break;
//         case 6:
//           selectedOnSiteDesc7 = idx >= 0 ? idx : null;
//           break;
//         case 7:
//           selectedOnSiteDesc8 = idx >= 0 ? idx : null;
//           break;
//         case 8:
//           selectedOnSiteDesc9 = idx >= 0 ? idx : null;
//           break;
//         case 9:
//           selectedOnSiteDesc10 = idx >= 0 ? idx : null;
//           break;
//       }
//     }
//   }
//
//   // Example Flutter DropdownButton for one of the spinners (add to your build method as needed):
//   // DropdownButton<int>(
//   //   value: selectedOnSiteDesc1,
//   //   items: List.generate(inspectionLevelAbbrvs.length, (i) => DropdownMenuItem(
//   //     value: i,
//   //     child: Text(inspectionLevelAbbrvs[i]),
//   //   )),
//   //   onChanged: (int? newIndex) {
//   //     setState(() {
//   //       selectedOnSiteDesc1 = newIndex;
//   //       // Update your model and call updateOnSite/onSIteModal logic here
//   //     });
//   //   },
//   // )
//
//   // Ported: Start of handleOnSiteTab
//   void handleOnSiteTab() {
//     spinnerTouched = false;
//     // In Flutter, use onTap/onPressed for click listeners
//     // Example: GestureDetector(onTap: () => handleOnSiteDesc())
//     // Call other handler methods as needed
//     // handlePackaging();
//     // updateOverAllResultOnsite();
//     // onSiteList = ... // fetch from your handler
//     // setupOnSiteDropdowns();
//     // handleSampleSizeSpinners(onSiteList);
//     // handleOnSiteOverAllResult(onSiteList);
//     // For showing/hiding UI, use state variables and control widget visibility in build
//   }
//
//   // State variables for sample size dropdowns for on-site descriptions
//   List<String> sampleList = [];
//   List<dynamic> sampleModals = [];
//   int? selectedSampleSizeOnSiteDesc1;
//   int? selectedSampleSizeOnSiteDesc2;
//   int? selectedSampleSizeOnSiteDesc3;
//   int? selectedSampleSizeOnSiteDesc4;
//   int? selectedSampleSizeOnSiteDesc5;
//   int? selectedSampleSizeOnSiteDesc6;
//   int? selectedSampleSizeOnSiteDesc7;
//   int? selectedSampleSizeOnSiteDesc8;
//   int? selectedSampleSizeOnSiteDesc9;
//   int? selectedSampleSizeOnSiteDesc10;
//
//   void setupSampleSizeDropdowns() {
//     // Populate sampleList from sampleModals
//     sampleList = sampleModals.map((e) => "${e['MainDescr']} (${e['SampleVal']})").toList();
//     // Set initial selected values based on onSiteList and sampleModals
//     for (int i = 0; i < onSiteList.length; i++) {
//       final sampleSizeID = onSiteList[i]['SampleSizeID'];
//       final idx = sampleModals.indexWhere((e) => e['SampleCode'] == sampleSizeID);
//       switch (i) {
//         case 0:
//           selectedSampleSizeOnSiteDesc1 = idx >= 0 ? idx : null;
//           break;
//         case 1:
//           selectedSampleSizeOnSiteDesc2 = idx >= 0 ? idx : null;
//           break;
//         case 2:
//           selectedSampleSizeOnSiteDesc3 = idx >= 0 ? idx : null;
//           break;
//         case 3:
//           selectedSampleSizeOnSiteDesc4 = idx >= 0 ? idx : null;
//           break;
//         case 4:
//           selectedSampleSizeOnSiteDesc5 = idx >= 0 ? idx : null;
//           break;
//         case 5:
//           selectedSampleSizeOnSiteDesc6 = idx >= 0 ? idx : null;
//           break;
//         case 6:
//           selectedSampleSizeOnSiteDesc7 = idx >= 0 ? idx : null;
//           break;
//         case 7:
//           selectedSampleSizeOnSiteDesc8 = idx >= 0 ? idx : null;
//           break;
//         case 8:
//           selectedSampleSizeOnSiteDesc9 = idx >= 0 ? idx : null;
//           break;
//         case 9:
//           selectedSampleSizeOnSiteDesc10 = idx >= 0 ? idx : null;
//           break;
//       }
//     }
//   }
//
//   // Example Flutter DropdownButton for one of the sample size spinners (add to your build method as needed):
//   // DropdownButton<int>(
//   //   value: selectedSampleSizeOnSiteDesc1,
//   //   items: List.generate(sampleList.length, (i) => DropdownMenuItem(
//   //     value: i,
//   //     child: Text(sampleList[i]),
//   //   )),
//   //   onChanged: (int? newIndex) {
//   //     setState(() {
//   //       selectedSampleSizeOnSiteDesc1 = newIndex;
//   //       // Update your model and call updateOnSite/onSIteModal logic here
//   //     });
//   //   },
//   // )
//
//   // Dart logic for null/empty checks and assignments for packing findings
//   void assignPackingFindings({
//     required String? mwt,
//     required String? mcbm,
//     required String? pl,
//     required String? pb,
//     required String? ph,
//     required String? pwt,
//     required String? pcbm,
//   }) {
//     // Example: Replace with your actual model and field names
//     packagePoItemDetalDetail.pkgMeMasterFindingWt = (mwt == null || mwt.isEmpty) ? 0 : double.tryParse(mwt) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingCBM = (mcbm == null || mcbm.isEmpty) ? 0 : double.tryParse(mcbm) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingL = (pl == null || pl.isEmpty) ? 0 : double.tryParse(pl) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingB = (pb == null || pb.isEmpty) ? 0 : double.tryParse(pb) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingH = (ph == null || ph.isEmpty) ? 0 : double.tryParse(ph) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingWt = (pwt == null || pwt.isEmpty) ? 0 : double.tryParse(pwt) ?? 0;
//     packagePoItemDetalDetail.pkgMeMasterFindingCBM = (pcbm == null || pcbm.isEmpty) ? 0 : double.tryParse(pcbm) ?? 0;
//   }
//
//   // State variables for packaging appearance overall result dropdowns
//   List<String> pkgAppStatusList = [];
//   List<dynamic> overAllResultStatusList = [];
//   List<dynamic> pkgAppList = [];
//   int? selectedPkgAppearDesc1;
//   int? selectedPkgAppearDesc2;
//   int? selectedPkgAppearDesc3;
//   int? selectedPkgAppearDesc4;
//   int? selectedPkgAppearDesc5;
//   int? selectedPkgAppearDesc6;
//   int? selectedPkgAppearDesc7;
//   int? selectedPkgAppearDesc8;
//   int? selectedPkgAppearDesc9;
//
//   void setupPkgAppDescDropdowns() {
//     // Populate pkgAppStatusList from overAllResultStatusList
//     pkgAppStatusList = overAllResultStatusList.map((e) => e['MainDescr'] as String).toList();
//     // Set initial selected values based on pkgAppList and overAllResultStatusList
//     for (int i = 0; i < pkgAppList.length; i++) {
//       final inspectionResultID = pkgAppList[i]['InspectionResultID'];
//       final idx = overAllResultStatusList.indexWhere((e) => e['pGenRowID'] == inspectionResultID);
//       switch (i) {
//         case 0:
//           selectedPkgAppearDesc1 = idx >= 0 ? idx : null;
//           break;
//         case 1:
//           selectedPkgAppearDesc2 = idx >= 0 ? idx : null;
//           break;
//         case 2:
//           selectedPkgAppearDesc3 = idx >= 0 ? idx : null;
//           break;
//         case 3:
//           selectedPkgAppearDesc4 = idx >= 0 ? idx : null;
//           break;
//         case 4:
//           selectedPkgAppearDesc5 = idx >= 0 ? idx : null;
//           break;
//         case 5:
//           selectedPkgAppearDesc6 = idx >= 0 ? idx : null;
//           break;
//         case 6:
//           selectedPkgAppearDesc7 = idx >= 0 ? idx : null;
//           break;
//         case 7:
//           selectedPkgAppearDesc8 = idx >= 0 ? idx : null;
//           break;
//         case 8:
//           selectedPkgAppearDesc9 = idx >= 0 ? idx : null;
//           break;
//       }
//     }
//   }
//
//   // Example Flutter DropdownButton for one of the packaging appearance spinners (add to your build method as needed):
//   // DropdownButton<int>(
//   //   value: selectedPkgAppearDesc1,
//   //   items: List.generate(pkgAppStatusList.length, (i) => DropdownMenuItem(
//   //     value: i,
//   //     child: Text(pkgAppStatusList[i]),
//   //   )),
//   //   onChanged: (int? newIndex) {
//   //     setState(() {
//   //       selectedPkgAppearDesc1 = newIndex;
//   //       // Update your model and call updatePkgAppearance logic here
//   //     });
//   //   },
//   // )
//
//   // Model/database update logic (placeholders for your actual data handling)
//   void updatePkgAppearance(dynamic pOItemPkgAppDetail) {
//     // TODO: Implement your update logic here
//     print('Update package appearance: $pOItemPkgAppDetail');
//   }
//
//   void insertSampleCollected(dynamic sampleCollectedModal) {
//     // TODO: Implement your insert logic here
//     print('Insert sample collected: $sampleCollectedModal');
//   }
//
//   void insertOnSite(dynamic onSIteModalItem) {
//     // TODO: Implement your insert logic here
//     print('Insert on-site: $onSIteModalItem');
//   }
//
//   void updateSampleCollectedTab() {
//     // TODO: Implement your update logic here
//     print('Update sample collected tab');
//   }
//
//   void updateOnSite(dynamic onSIteModalItem) {
//     // TODO: Implement your update logic here
//     print('Update on-site: $onSIteModalItem');
//     handleOnSiteRemark();
//   }
//
//   // State variables for packaging appearance overall result dropdowns (master, inner, unit, pallet, shipping mark)
//   int? selectedMasterPackingPkgAppear;
//   int? selectedInnerPackingPkgAppear;
//   int? selectedUnitPackingPkgAppear;
//   int? selectedPalletPackingPkgAppear;
//   int? selectedShippingMarkPkgAppear;
//
//   void setupPackagingAppearanceOverAllResultDropdowns() {
//     // Example: Set initial selected values based on your model/data
//     // Replace with your actual logic
//     selectedMasterPackingPkgAppear = 0;
//     selectedInnerPackingPkgAppear = 0;
//     selectedUnitPackingPkgAppear = 0;
//     selectedPalletPackingPkgAppear = 0;
//     selectedShippingMarkPkgAppear = 0;
//   }
//
//   // Example Flutter DropdownButton for one of the packaging appearance spinners (add to your build method as needed):
//   // DropdownButton<int>(
//   //   value: selectedMasterPackingPkgAppear,
//   //   items: List.generate(pkgAppStatusList.length, (i) => DropdownMenuItem(
//   //     value: i,
//   //     child: Text(pkgAppStatusList[i]),
//   //   )),
//   //   onChanged: (int? newIndex) {
//   //     setState(() {
//   //       selectedMasterPackingPkgAppear = newIndex;
//   //       // Update your model and call updateOverResultPackagingAppearance/handleOverAllResult logic here
//   //     });
//   //   },
//   // )
//
//   void handleOnSiteRemark() {
//     // TODO: Implement your logic here
//     print('Handle on-site remark');
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialization logic from onCreate
//     // In Flutter, you would fetch data, initialize controllers, etc. here
//     // Example: initialize lists, fetch data, etc.
//     // TODO: Port logic for fetching and deserializing POItemDtl and InspectionModal
//     // TODO: Port logic for setting up UI state, listeners, etc.
//     // TODO: Port logic for initializing tabs and handlers
//     // For click listeners, use onTap/onPressed in the widget tree
//   }
//
//   // Ported helper method from Java
//   void handlePackagingAppearanceUpload() {
//     // In Dart, just clear and repopulate the lists
//     unitPkgAppAttachmentList.clear();
//     shippingPkgAppAttachmentList.clear();
//     innerPkgAppAttachmentList.clear();
//     masterPkgAppAttachmentList.clear();
//     palletPkgAppAttachmentList.clear();
//
//     // Filter and populate attachments based on title
//     for (var modal in digitalsUploadModals) {
//       if (modal.title != null && modal.selectedPicPath != null) {
//         switch (modal.title) {
//           case "Unit pack appearance":
//             unitPkgAppAttachmentList.add(modal.selectedPicPath);
//             break;
//           case "Shipping pack appearance":
//             shippingPkgAppAttachmentList.add(modal.selectedPicPath);
//             break;
//           case "Inner pack appearance":
//             innerPkgAppAttachmentList.add(modal.selectedPicPath);
//             break;
//           case "Master pack appearance":
//             masterPkgAppAttachmentList.add(modal.selectedPicPath);
//             break;
//           case "Pallet pack appearance":
//             palletPkgAppAttachmentList.add(modal.selectedPicPath);
//             break;
//         }
//       }
//     }
//   }
//
//   // Ported from Java: checkPkgAppShowHideStatus
//   void checkPkgAppShowHideStatus(List<dynamic> statusList) {
//     // In Flutter, you would use setState and control widget visibility in the build method
//     for (var status in statusList) {
//       // Replace with your actual model and field names
//       final subId = status['SubID'];
//       final numVal2 = status['numVal2'];
//       // Example: set state variables to control visibility
//       if (subId == 'PKG_APP_SUB_ID') {
//         // setState(() => showPackagingAppearance = numVal2 == '0');
//       } else if (subId == 'PKG_MEASURMENT_SUB_ID') {
//         // setState(() => showPackingMeasurement = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'BARCODE_SUB_ID') {
//         // setState(() => showBarcode = numVal2 == '0');
//       } else if (subId == 'ON_SITE_TEST_SUB_ID') {
//         // setState(() => showOnSiteTest = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'WORKMANSHIP_SUB_ID') {
//         // setState(() => showWorkmanship = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'SAMPLE_PURPOSE_SUB_ID') {
//         // setState(() => showSampleCollected = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'ITEM_MEASURMENT_SUB_ID') {
//         // setState(() => showItemMeasurement = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'DIGITAL_UPLOAD_SUB_ID') {
//         // setState(() => showDigitalsUploaded = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'ENCLOSURE_SUB_ID') {
//         // setState(() => showEnclosure = numVal2 == '0' || numVal2 == '1');
//       } else if (subId == 'TEST_REPORT_SUB_ID') {
//         // setState(() => showTestReports = numVal2 == '0');
//       } else if (subId == 'INTERNAL_TEST_SUB_ID') {
//         // setState(() => showProductionStatus = numVal2 == '0' || numVal2 == '1');
//       }
//     }
//   }
//
//   // Ported from Java: getPoListItem
//   void getPoListItem() {
//     // TODO: Replace with your actual handler and model logic
//     // Example: poItemDtl['LatestDelDt'] = POItemDtlHandler.getPOListItemLatestDelDate(...);
//     // print('LatestDelDt = \\${poItemDtl['LatestDelDt']}');
//   }
//
//   // Ported from Java: handleItemQty (partial)
//   void handleItemQty() {
//     // Use Dart's DateTime and intl for date parsing/formatting
//     // import 'package:intl/intl.dart';
//     final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
//     try {
//       // print('OrderQty: \\${poItemDtl['OrderQty']}');
//       final latestDelDt = poItemDtl != null ? poItemDtl['LatestDelDt'] : null;
//       if (latestDelDt != null) {
//         final date = format.parse(latestDelDt);
//         print(date);
//         final sdf = DateFormat('dd-MMM-yyyy');
//         // String formattedDate = sdf.format(date);
//         // print('Formatted date: \\${formattedDate}');
//       }
//     } catch (e) {
//       print('Date parsing error: $e');
//     }
//   }
//
//   // Ported from Java: updateAttachmentUI (UI logic should be handled in build method)
//   void updateAttachmentUI(List<String> attachmentList, dynamic attachmentCountWidget, dynamic imagePickerWidget, int index, int size) {
//     // In Flutter, update the state and let the build method reflect the changes
//     // For example, you might call setState(() {}) and use the length of attachmentList to show a badge/count
//     // The actual UI update should be handled in the widget tree
//   }
//
//   // Handler methods for image picking (port of onPalletPackImage, onInnerPackImage, etc.)
//   void onPalletPackImage() {
//     // TODO: Use a Flutter image picker or custom dialog
//     // Example: showDialog(context: context, builder: ...);
//     // Use a unique identifier for pallet packing attachment
//     // MultipleImageHandler.showDialog equivalent
//     print('Pick pallet packing image');
//   }
//
//   void onInnerPackImage() {
//     print('Pick inner packing image');
//   }
//
//   void onUnitPackImage() {
//     print('Pick unit packing image');
//   }
//
//   void onUnitPackageAppearImage() {
//     print('Pick unit package appearance image');
//   }
//
//   void againOpen(String valueToReturn) {
//     print('Again open picker for: $valueToReturn');
//   }
//
//   void onShippingPackageAppearImage() {
//     print('Pick shipping package appearance image');
//   }
//
//   void onInnerPackageAppearImage() {
//     print('Pick inner package appearance image');
//   }
//
//   void onMasterPackageAppearImage() {
//     print('Pick master package appearance image');
//   }
//
//   // In your build method, use GestureDetector, InkWell, or IconButton for clickable images/text
//   // Example:
//   // GestureDetector(
//   //   onTap: onPalletPackImage,
//   //   child: Image.asset('assets/images/pallet.png'),
//   // )
//
//   @override
//   void dispose() {
//     editPackingRemarkController.dispose();
//     editWorkmanshipRemarkController.dispose();
//     editItemMeasurementRemarkController.dispose();
//     editOnSiteRemarkController.dispose();
//     editPackingAppearRemarkController.dispose();
//     editItemQtyRemarkController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Item Details'),
//       ),
//       body: _buildBody(),
//     );
//   }
//
//   Widget _buildBody() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: editPackingRemarkController,
//               decoration: const InputDecoration(labelText: 'Packing Remark'),
//             ),
//           ),
//           // Add more widgets for other fields and UI sections
//         ],
//       ),
//     );
//   }
//
//
//   // Assume these are defined somewhere in your code
//   dynamic loadingDialog;
//
//   void hideDialog() {
//     if (loadingDialog != null && loadingDialog.isShowing && loadingDialog.isIndeterminate) {
//       loadingDialog.dismiss();
//       loadingDialog = null;
//     }
//   }
//
//   void showProgressDialog(String message) {
//     // Implement a loading indicator, e.g., showDialog or loading overlay
//     print("Show progress: $message");
//   }
//
//
//
//   // void updateUIOnDelete() {
//   //   showProgressDialog("Waiting...");
//   //   Future.delayed(Duration(seconds: 1), () {
//   //     handlePackaging();
//   //     updatePackingUI();
//   //     setAdaptor();
//   //     updateDigitalUi();
//   //     setQualityParameterAdaptor();
//   //     hideDialog();
//   //   });
//   // }
//   //
//   // void updateUIOnEdit() {
//   //   showProgressDialog("Waiting...");
//   //   Future.delayed(Duration(seconds: 1), () {
//   //     handlePackaging();
//   //     updatePackingUI();
//   //     setAdaptor();
//   //     updateDigitalUi();
//   //     setQualityParameterAdaptor();
//   //     hideDialog();
//   //   });
//   // }
//
//   void handleOverAllResult() {
//     if (packagePoItemDetalDetail.itemMeasurementInspectionResultID != null &&
//         packagePoItemDetalDetail.itemMeasurementInspectionResultID == FEnumerations.overAllFailResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.itemMeasurementInspectionResultID;
//     } else if (packagePoItemDetalDetail.workmanshipInspectionResultID != null &&
//         packagePoItemDetalDetail.workmanshipInspectionResultID == FEnumerations.overAllFailResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.workmanshipInspectionResultID;
//     } else if (packagePoItemDetalDetail.pkgMeInspectionResultID != null &&
//         packagePoItemDetalDetail.overallInspectionResultID == FEnumerations.overAllFailResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.overallInspectionResultID;
//     } else if (packagePoItemDetalDetail.itemMeasurementInspectionResultID != null &&
//         packagePoItemDetalDetail.itemMeasurementInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.itemMeasurementInspectionResultID;
//     } else if (packagePoItemDetalDetail.workmanshipInspectionResultID != null &&
//         packagePoItemDetalDetail.workmanshipInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.workmanshipInspectionResultID;
//     } else if (packagePoItemDetalDetail.overallInspectionResultID != null &&
//         packagePoItemDetalDetail.overallInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.overallInspectionResultID;
//     } else if (packagePoItemDetalDetail.overallInspectionResultID != null &&
//         packagePoItemDetalDetail.overallInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.overallInspectionResultID;
//     } else if (packagePoItemDetalDetail.onSiteTestInspectionResultID != null &&
//         packagePoItemDetalDetail.onSiteTestInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.onSiteTestInspectionResultID;
//     } else if (packagePoItemDetalDetail.barcodeInnerInspectionResultID != null &&
//         packagePoItemDetalDetail.barcodeInnerInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.barcodeInnerInspectionResultID;
//     } else if (packagePoItemDetalDetail.pkgAppInspectionResultID != null &&
//         packagePoItemDetalDetail.pkgAppInspectionResultID == FEnumerations.overAllHoldResult) {
//       packagePoItemDetalDetail.overallInspectionResultID = packagePoItemDetalDetail.pkgAppInspectionResultID;
//     }
//
//     //handleHoleOverAllResult();
//   }
//
// }