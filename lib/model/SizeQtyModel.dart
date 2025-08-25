class SizeQtyModel {
  int? acceptedQty;
  int? availableQty;
  int? earlierInspected;
  int? orderQty;
  String? poid;
  String? qrpoItemDtlId;
  String? qrpoItemHdrId;
  String? sizeGroupDescr;
  String? sizeId;

  SizeQtyModel({
    this.acceptedQty,
    this.availableQty,
    this.earlierInspected,
    this.orderQty,
    this.poid,
    this.qrpoItemDtlId,
    this.qrpoItemHdrId,
    this.sizeGroupDescr,
    this.sizeId,
  });

  factory SizeQtyModel.fromJson(Map<String, dynamic> json) {
    return SizeQtyModel(
      acceptedQty: json['AcceptedQty'] as int?,
      availableQty: json['AvailableQty'] as int?,
      earlierInspected: json['EarlierInspected'] as int?,
      orderQty: json['OrderQty'] as int?,
      poid: json['POID'] as String?,
      qrpoItemDtlId: json['QRPOItemDtlID'] as String?,
      qrpoItemHdrId: json['QRPOItemHdrID'] as String?,
      sizeGroupDescr: json['SizeGroupDescr'] as String?,
      sizeId: json['SizeID'] as String?,
    );
  }

  SizeQtyModel copyWith({
    int? acceptedQty,
    int? availableQty,
    int? earlierInspected,
    int? orderQty,
    String? poid,
    String? qrpoItemDtlId,
    String? qrpoItemHdrId,
    String? sizeGroupDescr,
    String? sizeId,
  }) =>
      SizeQtyModel(
        acceptedQty: acceptedQty ?? this.acceptedQty,
        availableQty: availableQty ?? this.availableQty,
        earlierInspected: earlierInspected ?? this.earlierInspected,
        orderQty: orderQty ?? this.orderQty,
        poid: poid ?? this.poid,
        qrpoItemDtlId: qrpoItemDtlId ?? this.qrpoItemDtlId,
        qrpoItemHdrId: qrpoItemHdrId ?? this.qrpoItemHdrId,
        sizeGroupDescr: sizeGroupDescr ?? this.sizeGroupDescr,
        sizeId: sizeId ?? this.sizeId,
      );
}
