// File: defect_master_model.dart

class DefectMasterModel {
  String? pRowID;
  String? locID;
  String? defectName;
  String? code;
  String? dclTypeID;
  String? inspectionStage;
  String? recAddUser;
  int? chkCritical;
  int? chkMajor;
  int? chkMinor;

  DefectMasterModel({
    this.pRowID,
    this.locID,
    this.defectName,
    this.code,
    this.dclTypeID,
    this.inspectionStage,
    this.recAddUser,
    this.chkCritical,
    this.chkMajor,
    this.chkMinor,
  });

  factory DefectMasterModel.fromJson(Map<String, dynamic> json) {
    return DefectMasterModel(
      pRowID: json['pRowID'],
      locID: json['LocID'],
      defectName: json['DefectName'],
      code: json['Code'],
      dclTypeID: json['DCLTypeID'],
      inspectionStage: json['InspectionStage'],
      recAddUser: json['recAddUser'],
      chkCritical: json['chkCritical'],
      chkMajor: json['chkMajor'],
      chkMinor: json['chkMinor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'LocID': locID,
      'DefectName': defectName,
      'Code': code,
      'DCLTypeID': dclTypeID,
      'InspectionStage': inspectionStage,
      'recAddUser': recAddUser,
      'chkCritical': chkCritical,
      'chkMajor': chkMajor,
      'chkMinor': chkMinor,
    };
  }
}
