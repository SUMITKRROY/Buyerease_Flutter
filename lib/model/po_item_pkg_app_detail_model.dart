/**
 * Created by Sumit Roy 02/05/2025
 */

class POItemPkgAppDetail {
  String? pRowID;
  String? locID;
  String? descrID;
  String? sampleSizeID;
  String? sampleSizeValue;
  String? inspectionResultID;
  String? recUser;

  POItemPkgAppDetail({
    this.pRowID,
    this.locID,
    this.descrID,
    this.sampleSizeID,
    this.sampleSizeValue,
    this.inspectionResultID,
    this.recUser,
  });

  factory POItemPkgAppDetail.fromJson(Map<String, dynamic> json) {
    return POItemPkgAppDetail(
      pRowID: json['pRowID'],
      locID: json['locID'],
      descrID: json['descrID'],
      sampleSizeID: json['sampleSizeID'],
      sampleSizeValue: json['sampleSizeValue'],
      inspectionResultID: json['inspectionResultID'],
      recUser: json['recUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'locID': locID,
      'descrID': descrID,
      'sampleSizeID': sampleSizeID,
      'sampleSizeValue': sampleSizeValue,
      'inspectionResultID': inspectionResultID,
      'recUser': recUser,
    };
  }
} 