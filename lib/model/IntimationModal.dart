class IntimationModal {
    String? pRowId;
    String? locId;
    String? qrHdrId;
    String? name;
    String? emailId;
    String? id;
    int? isLink;
    int? isReport;
    int? recType;
    int? recEnable;
    String? recAddUser;
    String? recAddDt;
    String? recUser;
    String? recDt;
    String? ediDt;
    int? isHtmlLink;
    int? isRcvApplicable;
    int? isSelected;
    String? bePRowId;

    IntimationModal({
        this.pRowId,
        this.locId,
        this.qrHdrId,
        this.name,
        this.emailId,
        this.id,
        this.isLink,
        this.isReport,
        this.recType,
        this.recEnable,
        this.recAddUser,
        this.recAddDt,
        this.recUser,
        this.recDt,
        this.ediDt,
        this.isHtmlLink,
        this.isRcvApplicable,
        this.isSelected,
        this.bePRowId,
    });

    IntimationModal copyWith({
        String? pRowId,
        String? locId,
        String? qrHdrId,
        String? name,
        String? emailId,
        String? id,
        int? isLink,
        int? isReport,
        int? recType,
        int? recEnable,
        String? recAddUser,
        String? recAddDt,
        String? recUser,
        String? recDt,
        String? ediDt,
        int? isHtmlLink,
        int? isRcvApplicable,
        int? isSelected,
        String? bePRowId,
    }) =>
        IntimationModal(
            pRowId: pRowId ?? this.pRowId,
            locId: locId ?? this.locId,
            qrHdrId: qrHdrId ?? this.qrHdrId,
            name: name ?? this.name,
            emailId: emailId ?? this.emailId,
            id: id ?? this.id,
            isLink: isLink ?? this.isLink,
            isReport: isReport ?? this.isReport,
            recType: recType ?? this.recType,
            recEnable: recEnable ?? this.recEnable,
            recAddUser: recAddUser ?? this.recAddUser,
            recAddDt: recAddDt ?? this.recAddDt,
            recUser: recUser ?? this.recUser,
            recDt: recDt ?? this.recDt,
            ediDt: ediDt ?? this.ediDt,
            isHtmlLink: isHtmlLink ?? this.isHtmlLink,
            isRcvApplicable: isRcvApplicable ?? this.isRcvApplicable,
            isSelected: isSelected ?? this.isSelected,
            bePRowId: bePRowId ?? this.bePRowId,
        );
    factory IntimationModal.fromMap(Map<String, dynamic> map) {
        return IntimationModal(
            pRowId: map['pRowID'],
            locId: map['LocID'],
            qrHdrId: map['QRHdrID'],
            name: map['Name'],
            emailId: map['EmailID'],
            id: map['ID'],
            recAddUser: map['recAddUser'],
            recAddDt: map['recAddDt'],
            recUser: map['recUser'],
            recDt: map['recDt'],
            ediDt: map['EDIDt'],
            bePRowId: map['BE_pRowID'],
            isLink: map['IsLink'],
            isReport: map['IsReport'],
            recType: map['recType'],
            recEnable: map['recEnable'],
            isHtmlLink: map['IsHtmlLink'],
            isRcvApplicable: map['IsRcvApplicable'],
            isSelected: map['IsSelected'],
        );
    }

}
