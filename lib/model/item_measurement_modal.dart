/**
 * Created by Sumit Roy 02/05/2025
 */

import 'digitals_upload_model.dart';

class ItemMeasurementModal {
  String? pRowID;
  String? qrHdrID;
  String? qrpoItemHdrID;
  double? dimHeight;
  double? dimLength;
  double? dimWidth;
  String? sampleSizeValue;
  String? sampleSizeID;
  String? inspectionResultID;
  String? toleranceRange;
  String? itemMeasurementDescr;
  String? digitals;
  double? oldHeight;
  double? oldWidth;
  double? oldLength;
  String? pRowIDForFinding;
  String? activity;
  String? inspectionDate;
  List<DigitalsUploadModel>? listImages;

  ItemMeasurementModal({
    this.pRowID,
    this.qrHdrID,
    this.qrpoItemHdrID,
    this.dimHeight,
    this.dimLength,
    this.dimWidth,
    this.sampleSizeValue,
    this.sampleSizeID,
    this.inspectionResultID,
    this.toleranceRange,
    this.itemMeasurementDescr,
    this.digitals,
    this.oldHeight,
    this.oldWidth,
    this.oldLength,
    this.pRowIDForFinding,
    this.activity,
    this.inspectionDate,
    this.listImages,
  });

  factory ItemMeasurementModal.fromJson(Map<String, dynamic> json) {
    return ItemMeasurementModal(
      pRowID: json['pRowID'],
      qrHdrID: json['QRHdrID'],
      qrpoItemHdrID: json['QRPOItemHdrID'],
      dimHeight: json['Dim_Height'],
      dimLength: json['Dim_length'],
      dimWidth: json['Dim_Width'],
      sampleSizeValue: json['SampleSizeValue'],
      sampleSizeID: json['SampleSizeID'],
      inspectionResultID: json['InspectionResultID'],
      toleranceRange: json['Tolerance_Range'],
      itemMeasurementDescr: json['ItemMeasurementDescr'],
      digitals: json['Digitals'],
      oldHeight: json['OLD_Height'],
      oldWidth: json['OLD_Width'],
      oldLength: json['OLD_Length'],
      pRowIDForFinding: json['pRowIDForFinding'],
      activity: json['Activity'],
      inspectionDate: json['InspectionDate'],
      listImages: json['listImages'] != null
          ? (json['listImages'] as List)
              .map((e) => DigitalsUploadModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'QRHdrID': qrHdrID,
      'QRPOItemHdrID': qrpoItemHdrID,
      'Dim_Height': dimHeight,
      'Dim_length': dimLength,
      'Dim_Width': dimWidth,
      'SampleSizeValue': sampleSizeValue,
      'SampleSizeID': sampleSizeID,
      'InspectionResultID': inspectionResultID,
      'Tolerance_Range': toleranceRange,
      'ItemMeasurementDescr': itemMeasurementDescr,
      'Digitals': digitals,
      'OLD_Height': oldHeight,
      'OLD_Width': oldWidth,
      'OLD_Length': oldLength,
      'pRowIDForFinding': pRowIDForFinding,
      'Activity': activity,
      'InspectionDate': inspectionDate,
      'listImages': listImages?.map((e) => e.toJson()).toList(),
    };
  }

  ItemMeasurementModal copyWith({
    String? pRowID,
    String? qrHdrID,
    String? qrpoItemHdrID,
    double? dimHeight,
    double? dimLength,
    double? dimWidth,
    String? sampleSizeValue,
    String? sampleSizeID,
    String? inspectionResultID,
    String? toleranceRange,
    String? itemMeasurementDescr,
    String? digitals,
    double? oldHeight,
    double? oldWidth,
    double? oldLength,
    String? pRowIDForFinding,
    String? activity,
    String? inspectionDate,
    List<DigitalsUploadModel>? listImages,
  }) {
    return ItemMeasurementModal(
      pRowID: pRowID ?? this.pRowID,
      qrHdrID: qrHdrID ?? this.qrHdrID,
      qrpoItemHdrID: qrpoItemHdrID ?? this.qrpoItemHdrID,
      dimHeight: dimHeight ?? this.dimHeight,
      dimLength: dimLength ?? this.dimLength,
      dimWidth: dimWidth ?? this.dimWidth,
      sampleSizeValue: sampleSizeValue ?? this.sampleSizeValue,
      sampleSizeID: sampleSizeID ?? this.sampleSizeID,
      inspectionResultID: inspectionResultID ?? this.inspectionResultID,
      toleranceRange: toleranceRange ?? this.toleranceRange,
      itemMeasurementDescr: itemMeasurementDescr ?? this.itemMeasurementDescr,
      digitals: digitals ?? this.digitals,
      oldHeight: oldHeight ?? this.oldHeight,
      oldWidth: oldWidth ?? this.oldWidth,
      oldLength: oldLength ?? this.oldLength,
      pRowIDForFinding: pRowIDForFinding ?? this.pRowIDForFinding,
      activity: activity ?? this.activity,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      listImages: listImages ?? (this.listImages != null ? List<DigitalsUploadModel>.from(this.listImages!) : null),
    );
  }
} 