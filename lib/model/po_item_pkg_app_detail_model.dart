/// Created by Sumit Roy 02/06/2025
class POItemPkgAppDetail {
  String? pRowID;
  String? locID;
  String? descrID;
  String? sampleSizeID;
  String? sampleSizeValue;
  String? inspectionResultID;
  String? recUser;

  // Attachment lists for different packaging types
  List<String> unitPkgAppAttachmentList;
  List<String> shippingPkgAppAttachmentList;
  List<String> innerPkgAppAttachmentList;
  List<String> masterPkgAppAttachmentList;
  List<String> palletPkgAppAttachmentList;

  POItemPkgAppDetail({
    this.pRowID,
    this.locID,
    this.descrID,
    this.sampleSizeID,
    this.sampleSizeValue,
    this.inspectionResultID,
    this.recUser,
    List<String>? unitPkgAppAttachmentList,
    List<String>? shippingPkgAppAttachmentList,
    List<String>? innerPkgAppAttachmentList,
    List<String>? masterPkgAppAttachmentList,
    List<String>? palletPkgAppAttachmentList,
  })  : unitPkgAppAttachmentList = unitPkgAppAttachmentList ?? [],
        shippingPkgAppAttachmentList = shippingPkgAppAttachmentList ?? [],
        innerPkgAppAttachmentList = innerPkgAppAttachmentList ?? [],
        masterPkgAppAttachmentList = masterPkgAppAttachmentList ?? [],
        palletPkgAppAttachmentList = palletPkgAppAttachmentList ?? [];

  factory POItemPkgAppDetail.fromJson(Map<String, dynamic> json) {
    return POItemPkgAppDetail(
      pRowID: json['pRowID']?.toString(),
      locID: json['locID']?.toString(),
      descrID: json['descrID']?.toString(),
      sampleSizeID: json['sampleSizeID']?.toString(),
      sampleSizeValue: json['sampleSizeValue']?.toString(),
      inspectionResultID: json['inspectionResultID']?.toString(),
      recUser: json['recUser']?.toString(),
      unitPkgAppAttachmentList: List<String>.from(json['unitPkgAppAttachmentList'] ?? []),
      shippingPkgAppAttachmentList: List<String>.from(json['shippingPkgAppAttachmentList'] ?? []),
      innerPkgAppAttachmentList: List<String>.from(json['innerPkgAppAttachmentList'] ?? []),
      masterPkgAppAttachmentList: List<String>.from(json['masterPkgAppAttachmentList'] ?? []),
      palletPkgAppAttachmentList: List<String>.from(json['palletPkgAppAttachmentList'] ?? []),
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
      'unitPkgAppAttachmentList': unitPkgAppAttachmentList,
      'shippingPkgAppAttachmentList': shippingPkgAppAttachmentList,
      'innerPkgAppAttachmentList': innerPkgAppAttachmentList,
      'masterPkgAppAttachmentList': masterPkgAppAttachmentList,
      'palletPkgAppAttachmentList': palletPkgAppAttachmentList,
    };
  }
}
