/**
 * Created by Sumit Roy 02/05/2025
 */

import 'digitals_upload_model.dart';

class WorkManShipModel {
  String? pRowID;
  String? code;
  String? description;
  int? critical;
  int? major;
  int? minor;
  String? comments;
  String? digitals;
  String? activity;
  String? inspectionDate;
  String? inspectionId;
  List<DigitalsUploadModel>? listImages;

  WorkManShipModel({
    this.pRowID,
    this.code,
    this.description,
    this.critical,
    this.major,
    this.minor,
    this.comments,
    this.digitals,
    this.activity,
    this.inspectionDate,
    this.inspectionId,
    this.listImages,
  });

  factory WorkManShipModel.fromJson(Map<String, dynamic> json) {
    return WorkManShipModel(
      pRowID: json['pRowID'],
      code: json['Code'],
      description: json['Description'],
      critical: json['Critical'],
      major: json['Major'],
      minor: json['Minor'],
      comments: json['Comments'],
      digitals: json['Digitals'],
      activity: json['Activity'],
      inspectionDate: json['InspectionDate'],
      inspectionId: json['InspectionId'],
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
      'Code': code,
      'Description': description,
      'Critical': critical,
      'Major': major,
      'Minor': minor,
      'Comments': comments,
      'Digitals': digitals,
      'Activity': activity,
      'InspectionDate': inspectionDate,
      'InspectionId': inspectionId,
      'listImages': listImages?.map((e) => e.toJson()).toList(),
    };
  }
} 