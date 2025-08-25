class EnclosureModal {
  String? pRowId;
  String? qrpoItemDtlId;
  String? qrpoItemHdrId;
  String? qrHdrId;
  String? contextType;
  int? seqNo;
  String? contextId;
  String? contextDs;
  String? contextDs1;
  String? contextDs2;
  String? contextDs2A;
  String? contextDs3;
  String? enclType;
  String? enclFileType;
  String? enclRowId;
  String? title;
  String? imageName;
  String? fileIcon;
  String? imagePathId;
  int? numVal1;
  String? fileName;
  String? fileContent;
  String? fileExt;
  int? isImportant;
  int? isRead;

  EnclosureModal({
    this.pRowId,
    this.qrpoItemDtlId,
    this.qrpoItemHdrId,
    this.qrHdrId,
    this.contextType,
    this.seqNo,
    this.contextId,
    this.contextDs,
    this.contextDs1,
    this.contextDs2,
    this.contextDs2A,
    this.contextDs3,
    this.enclType,
    this.enclFileType,
    this.enclRowId,
    this.title,
    this.imageName,
    this.fileIcon,
    this.imagePathId,
    this.numVal1,
    this.fileName,
    this.fileContent,
    this.fileExt,
    this.isImportant,
    this.isRead,
  });

  EnclosureModal copyWith({
    String? pRowId,
    String? qrpoItemDtlId,
    String? qrpoItemHdrId,
    String? qrHdrId,
    String? contextType,
    int? seqNo,
    String? contextId,
    String? contextDs,
    String? contextDs1,
    String? contextDs2,
    String? contextDs2A,
    String? contextDs3,
    String? enclType,
    String? enclFileType,
    String? enclRowId,
    String? title,
    String? imageName,
    String? fileIcon,
    String? imagePathId,
    int? numVal1,
    String? fileName,
    String? fileContent,
    String? fileExt,
    int? isImportant,
    int? isRead,
  }) =>
      EnclosureModal(
        pRowId: pRowId ?? this.pRowId,
        qrpoItemDtlId: qrpoItemDtlId ?? this.qrpoItemDtlId,
        qrpoItemHdrId: qrpoItemHdrId ?? this.qrpoItemHdrId,
        qrHdrId: qrHdrId ?? this.qrHdrId,
        contextType: contextType ?? this.contextType,
        seqNo: seqNo ?? this.seqNo,
        contextId: contextId ?? this.contextId,
        contextDs: contextDs ?? this.contextDs,
        contextDs1: contextDs1 ?? this.contextDs1,
        contextDs2: contextDs2 ?? this.contextDs2,
        contextDs2A: contextDs2A ?? this.contextDs2A,
        contextDs3: contextDs3 ?? this.contextDs3,
        enclType: enclType ?? this.enclType,
        enclFileType: enclFileType ?? this.enclFileType,
        enclRowId: enclRowId ?? this.enclRowId,
        title: title ?? this.title,
        imageName: imageName ?? this.imageName,
        fileIcon: fileIcon ?? this.fileIcon,
        imagePathId: imagePathId ?? this.imagePathId,
        numVal1: numVal1 ?? this.numVal1,
        fileName: fileName ?? this.fileName,
        fileContent: fileContent ?? this.fileContent,
        fileExt: fileExt ?? this.fileExt,
        isImportant: isImportant ?? this.isImportant,
        isRead: isRead ?? this.isRead,
      );
}
