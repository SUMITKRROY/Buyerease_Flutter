/**
 * Created by Sumit Roy 02/05/2025
 */

import 'digitals_upload_model.dart';

class ApplicableList {
  String? title;
  int? value;

  ApplicableList({
    this.title,
    this.value,
  });

  factory ApplicableList.fromJson(Map<String, dynamic> json) {
    return ApplicableList(
      title: json['title'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
    };
  }
}

class QualityParameter {
  String? pRowID;
  String? qualityParameterID;
  String? mainDescr;
  String? abbrv;
  String? optionValue;
  int? promptType;
  int? position;
  int? isApplicable;
  int? optionSelected;
  int? recDirty;
  String? remarks;
  String? digitals;
  int? imageRequired;
  List<ApplicableList>? applicableLists;
  List<DigitalsUploadModel>? imageAttachmentList;

  QualityParameter({
    this.pRowID,
    this.qualityParameterID,
    this.mainDescr,
    this.abbrv,
    this.optionValue,
    this.promptType,
    this.position,
    this.isApplicable,
    this.optionSelected,
    this.recDirty,
    this.remarks,
    this.digitals,
    this.imageRequired,
    this.applicableLists,
    this.imageAttachmentList,
  });

  factory QualityParameter.fromJson(Map<String, dynamic> json) {
    return QualityParameter(
      pRowID: json['pRowID'],
      qualityParameterID: json['QualityParameterID'],
      mainDescr: json['MainDescr'],
      abbrv: json['Abbrv'],
      optionValue: json['OptionValue'],
      promptType: json['PromptType'],
      position: json['Position'],
      isApplicable: json['IsApplicable'],
      optionSelected: json['OptionSelected'],
      recDirty: json['recDirty'],
      remarks: json['Remarks'],
      digitals: json['Digitals'],
      imageRequired: json['ImageRequired'] ?? 0,
      applicableLists: json['applicableLists'] != null
          ? (json['applicableLists'] as List)
              .map((e) => ApplicableList.fromJson(e))
              .toList()
          : null,
      imageAttachmentList: json['imageAttachmentList'] != null
          ? (json['imageAttachmentList'] as List)
              .map((e) => DigitalsUploadModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'QualityParameterID': qualityParameterID,
      'MainDescr': mainDescr,
      'Abbrv': abbrv,
      'OptionValue': optionValue,
      'PromptType': promptType,
      'Position': position,
      'IsApplicable': isApplicable,
      'OptionSelected': optionSelected,
      'recDirty': recDirty,
      'Remarks': remarks,
      'Digitals': digitals,
      'ImageRequired': imageRequired,
      'applicableLists': applicableLists?.map((e) => e.toJson()).toList(),
      'imageAttachmentList': imageAttachmentList?.map((e) => e.toJson()).toList(),
    };
  }
} 