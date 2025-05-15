/**
 * Created by Sumit Roy 02/05/2025
 */

class InspectionModal {
  String? qrHdrID;
  String? pRowID;
  String? activityID;
  String? activity;
  String? vendorID;
  String? companyID;
  String? qrID;
  String? poType;
  String? vendor;
  String? vendorAddress;
  String? vendorContact;
  String? vendorAcceptanceOn;
  String? vendorAcceptanceComment;
  String? vendorAcceptanceIntimation;
  String? vendorAcceptancePrintFormate;
  String? vendorAcceptanceHostAddress;
  String? vendorAppectanceByID;
  String? vendorAppectanceByName;
  String? vendorAppectanceByEmail;
  String? customer;
  String? poNo;
  String? itemID;
  String? itemNo;
  String? status;
  String? qlMajor;
  String? qlMinor;
  String? sampleCodeID;
  int? availableQty;
  int? allowedInspectionQty;
  int? inspectedQty;
  int? acceptedQty;
  int? shortStockQty;
  int? cartonsPacked;
  int? allowedCartonInspection;
  int? cartonsInspected;
  int? critialDefectsAllowed;
  int? majorDefectsAllowed;
  int? minorDefectsAllowed;
  int? criticalDefect;
  int? majorDefect;
  int? minorDefect;
  String? poqaStatusID;
  String? poqaStatusChangeID;
  String? poqaStatusChangeDescr;
  String? qrParamFormat;
  int? aqlFormula;
  String? autoFillQty;
  String? autoFillAcceptedQty;
  String? autoFillCarton;
  String? defectListType;
  String? rptType;
  String? rptFormat;
  String? rptDefectFormat;
  String? typeofInspection;
  String? inspectionLevel;
  String? inspectionDt;
  String? inspectionPlan;
  String? samplingPlan;
  String? inspectionMode;
  String? inspectionVersion;
  String? typeofInspectionDescr;
  String? inspectionLevelDescr;
  String? completeTime;
  String? inspStartTime;
  String? arrivalTime;
  String? inspectorID;
  String? inspector;
  String? invoiceNo;
  String? nextActivityID;
  String? nextActivityPlanDate;
  String? recApproveDt;
  String? recApproveUser;
  String? recAddDt;
  String? recEnable;
  String? recDirty;
  String? recAddUser;
  String? recUser;
  String? qlMajorDescr;
  String? qlMinorDescr;
  String? qr;
  String? sampleCodeDescr;
  String? factoryAddress;
  String? recDt;
  String? ediDt;
  String? acceptedDt;
  String? factory;
  String? comments;
  String? statusComments;
  String? reinspectionDt;
  String? lastSyncDt;
  String? productionCompletionDt;
  String? productionStatusRemark;
  bool? isCheckedToSync;
  String? poListed;
  String? itemListId;
  int? isImportant;

  InspectionModal({
    this.qrHdrID,
    this.pRowID,
    this.activityID,
    this.activity,
    this.vendorID,
    this.companyID,
    this.qrID,
    this.poType,
    this.vendor,
    this.vendorAddress,
    this.vendorContact,
    this.vendorAcceptanceOn,
    this.vendorAcceptanceComment,
    this.vendorAcceptanceIntimation,
    this.vendorAcceptancePrintFormate,
    this.vendorAcceptanceHostAddress,
    this.vendorAppectanceByID,
    this.vendorAppectanceByName,
    this.vendorAppectanceByEmail,
    this.customer,
    this.poNo,
    this.itemID,
    this.itemNo,
    this.status,
    this.qlMajor,
    this.qlMinor,
    this.sampleCodeID,
    this.availableQty,
    this.allowedInspectionQty,
    this.inspectedQty,
    this.acceptedQty,
    this.shortStockQty,
    this.cartonsPacked,
    this.allowedCartonInspection,
    this.cartonsInspected,
    this.critialDefectsAllowed,
    this.majorDefectsAllowed,
    this.minorDefectsAllowed,
    this.criticalDefect,
    this.majorDefect,
    this.minorDefect,
    this.poqaStatusID,
    this.poqaStatusChangeID,
    this.poqaStatusChangeDescr,
    this.qrParamFormat,
    this.aqlFormula,
    this.autoFillQty,
    this.autoFillAcceptedQty,
    this.autoFillCarton,
    this.defectListType,
    this.rptType,
    this.rptFormat,
    this.rptDefectFormat,
    this.typeofInspection,
    this.inspectionLevel,
    this.inspectionDt,
    this.inspectionPlan,
    this.samplingPlan,
    this.inspectionMode,
    this.inspectionVersion,
    this.typeofInspectionDescr,
    this.inspectionLevelDescr,
    this.completeTime,
    this.inspStartTime,
    this.arrivalTime,
    this.inspectorID,
    this.inspector,
    this.invoiceNo,
    this.nextActivityID,
    this.nextActivityPlanDate,
    this.recApproveDt,
    this.recApproveUser,
    this.recAddDt,
    this.recEnable,
    this.recDirty,
    this.recAddUser,
    this.recUser,
    this.qlMajorDescr,
    this.qlMinorDescr,
    this.qr,
    this.sampleCodeDescr,
    this.factoryAddress,
    this.recDt,
    this.ediDt,
    this.acceptedDt,
    this.factory,
    this.comments,
    this.statusComments,
    this.reinspectionDt,
    this.lastSyncDt,
    this.productionCompletionDt,
    this.productionStatusRemark,
    this.isCheckedToSync,
    this.poListed,
    this.itemListId,
    this.isImportant,
  });

  factory InspectionModal.fromJson(Map<String, dynamic> json) {
    return InspectionModal(
      qrHdrID: json['QRHdrID'],
      pRowID: json['pRowID'],
      activityID: json['ActivityID'],
      activity: json['Activity'],
      vendorID: json['VendorID'],
      companyID: json['CompanyID'],
      qrID: json['QRID'],
      poType: json['POType'],
      vendor: json['Vendor'],
      vendorAddress: json['VendorAddress'],
      vendorContact: json['VendorContact'],
      vendorAcceptanceOn: json['VendorAcceptanceOn'],
      vendorAcceptanceComment: json['VendorAcceptanceComment'],
      vendorAcceptanceIntimation: json['VendorAcceptanceIntimation'],
      vendorAcceptancePrintFormate: json['VendorAcceptancePrintFormate'],
      vendorAcceptanceHostAddress: json['VendorAcceptanceHostAddress'],
      vendorAppectanceByID: json['VendorAppectanceByID'],
      vendorAppectanceByName: json['VendorAppectanceByName'],
      vendorAppectanceByEmail: json['VendorAppectanceByEmail'],
      customer: json['Customer'],
      poNo: json['PONO'],
      itemID: json['ItemID'],
      itemNo: json['ItemNo'],
      status: json['Status'],
      qlMajor: json['QLMajor'],
      qlMinor: json['QLMinor'],
      sampleCodeID: json['SampleCodeID'],
      availableQty: json['AvailableQty'],
      allowedInspectionQty: json['AllowedInspectionQty'],
      inspectedQty: json['InspectedQty'],
      acceptedQty: json['AcceptedQty'],
      shortStockQty: json['ShortStockQty'],
      cartonsPacked: json['CartonsPacked'],
      allowedCartonInspection: json['AllowedCartonInspection'],
      cartonsInspected: json['CartonsInspected'],
      critialDefectsAllowed: json['CritialDefectsAllowed'],
      majorDefectsAllowed: json['MajorDefectsAllowed'],
      minorDefectsAllowed: json['MinorDefectsAllowed'],
      criticalDefect: json['CriticalDefect'],
      majorDefect: json['MajorDefect'],
      minorDefect: json['MinorDefect'],
      poqaStatusID: json['POQAStatusID'],
      poqaStatusChangeID: json['POQAStatusChangeID'],
      poqaStatusChangeDescr: json['POQAStatusChangeDescr'],
      qrParamFormat: json['QRParamFormat'],
      aqlFormula: json['AQLFormula'],
      autoFillQty: json['AutoFillQty'],
      autoFillAcceptedQty: json['AutoFillAcceptedQty'],
      autoFillCarton: json['AutoFillCarton'],
      defectListType: json['DefectListType'],
      rptType: json['RptType'],
      rptFormat: json['RptFormat'],
      rptDefectFormat: json['RptDefectFormat'],
      typeofInspection: json['TypeofInspection'],
      inspectionLevel: json['InspectionLevel'],
      inspectionDt: json['InspectionDt'],
      inspectionPlan: json['InspectionPlan'],
      samplingPlan: json['SamplingPlan'],
      inspectionMode: json['InspectionMode'],
      inspectionVersion: json['InspectionVersion'],
      typeofInspectionDescr: json['TypeofInspectionDescr'],
      inspectionLevelDescr: json['InspectionLevelDescr'],
      completeTime: json['CompleteTime'],
      inspStartTime: json['InspStartTime'],
      arrivalTime: json['ArrivalTime'],
      inspectorID: json['InspectorID'],
      inspector: json['Inspector'],
      invoiceNo: json['InvoiceNo'],
      nextActivityID: json['NextActivityID'],
      nextActivityPlanDate: json['NextActivityPlanDate'],
      recApproveDt: json['recApproveDt'],
      recApproveUser: json['recApproveUser'],
      recAddDt: json['recAddDt'],
      recEnable: json['recEnable'],
      recDirty: json['recDirty'],
      recAddUser: json['recAddUser'],
      recUser: json['recUser'],
      qlMajorDescr: json['QLMajorDescr'],
      qlMinorDescr: json['QLMinorDescr'],
      qr: json['QR'],
      sampleCodeDescr: json['SampleCodeDescr'],
      factoryAddress: json['FactoryAddress'],
      recDt: json['recDt'],
      ediDt: json['ediDt'],
      acceptedDt: json['AcceptedDt'],
      factory: json['Factory'],
      comments: json['Comments'],
      statusComments: json['StatusComments'],
      reinspectionDt: json['ReinspectionDt'],
      lastSyncDt: json['Last_Sync_Dt'],
      productionCompletionDt: json['ProductionCompletionDt'],
      productionStatusRemark: json['ProductionStatusRemark'],
      isCheckedToSync: json['IsCheckedToSync'],
      poListed: json['POListed'],
      itemListId: json['ItemListId'],
      isImportant: json['IsImportant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'QRHdrID': qrHdrID,
      'pRowID': pRowID,
      'ActivityID': activityID,
      'Activity': activity,
      'VendorID': vendorID,
      'CompanyID': companyID,
      'QRID': qrID,
      'POType': poType,
      'Vendor': vendor,
      'VendorAddress': vendorAddress,
      'VendorContact': vendorContact,
      'VendorAcceptanceOn': vendorAcceptanceOn,
      'VendorAcceptanceComment': vendorAcceptanceComment,
      'VendorAcceptanceIntimation': vendorAcceptanceIntimation,
      'VendorAcceptancePrintFormate': vendorAcceptancePrintFormate,
      'VendorAcceptanceHostAddress': vendorAcceptanceHostAddress,
      'VendorAppectanceByID': vendorAppectanceByID,
      'VendorAppectanceByName': vendorAppectanceByName,
      'VendorAppectanceByEmail': vendorAppectanceByEmail,
      'Customer': customer,
      'PONO': poNo,
      'ItemID': itemID,
      'ItemNo': itemNo,
      'Status': status,
      'QLMajor': qlMajor,
      'QLMinor': qlMinor,
      'SampleCodeID': sampleCodeID,
      'AvailableQty': availableQty,
      'AllowedInspectionQty': allowedInspectionQty,
      'InspectedQty': inspectedQty,
      'AcceptedQty': acceptedQty,
      'ShortStockQty': shortStockQty,
      'CartonsPacked': cartonsPacked,
      'AllowedCartonInspection': allowedCartonInspection,
      'CartonsInspected': cartonsInspected,
      'CritialDefectsAllowed': critialDefectsAllowed,
      'MajorDefectsAllowed': majorDefectsAllowed,
      'MinorDefectsAllowed': minorDefectsAllowed,
      'CriticalDefect': criticalDefect,
      'MajorDefect': majorDefect,
      'MinorDefect': minorDefect,
      'POQAStatusID': poqaStatusID,
      'POQAStatusChangeID': poqaStatusChangeID,
      'POQAStatusChangeDescr': poqaStatusChangeDescr,
      'QRParamFormat': qrParamFormat,
      'AQLFormula': aqlFormula,
      'AutoFillQty': autoFillQty,
      'AutoFillAcceptedQty': autoFillAcceptedQty,
      'AutoFillCarton': autoFillCarton,
      'DefectListType': defectListType,
      'RptType': rptType,
      'RptFormat': rptFormat,
      'RptDefectFormat': rptDefectFormat,
      'TypeofInspection': typeofInspection,
      'InspectionLevel': inspectionLevel,
      'InspectionDt': inspectionDt,
      'InspectionPlan': inspectionPlan,
      'SamplingPlan': samplingPlan,
      'InspectionMode': inspectionMode,
      'InspectionVersion': inspectionVersion,
      'TypeofInspectionDescr': typeofInspectionDescr,
      'InspectionLevelDescr': inspectionLevelDescr,
      'CompleteTime': completeTime,
      'InspStartTime': inspStartTime,
      'ArrivalTime': arrivalTime,
      'InspectorID': inspectorID,
      'Inspector': inspector,
      'InvoiceNo': invoiceNo,
      'NextActivityID': nextActivityID,
      'NextActivityPlanDate': nextActivityPlanDate,
      'recApproveDt': recApproveDt,
      'recApproveUser': recApproveUser,
      'recAddDt': recAddDt,
      'recEnable': recEnable,
      'recDirty': recDirty,
      'recAddUser': recAddUser,
      'recUser': recUser,
      'QLMajorDescr': qlMajorDescr,
      'QLMinorDescr': qlMinorDescr,
      'QR': qr,
      'SampleCodeDescr': sampleCodeDescr,
      'FactoryAddress': factoryAddress,
      'recDt': recDt,
      'ediDt': ediDt,
      'AcceptedDt': acceptedDt,
      'Factory': factory,
      'Comments': comments,
      'StatusComments': statusComments,
      'ReinspectionDt': reinspectionDt,
      'Last_Sync_Dt': lastSyncDt,
      'ProductionCompletionDt': productionCompletionDt,
      'ProductionStatusRemark': productionStatusRemark,
      'IsCheckedToSync': isCheckedToSync,
      'POListed': poListed,
      'ItemListId': itemListId,
      'IsImportant': isImportant,
    };
  }
} 