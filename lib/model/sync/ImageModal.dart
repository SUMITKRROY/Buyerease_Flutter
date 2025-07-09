/// Created by Roy on 08/07/2025
class ImageModal {
    String? pRowID;
    String? qrHdrID;
    String? qrPOItemHdrID;
    String? length;
    String? fileName;
    String? fileContent;

    ImageModal({
        this.pRowID,
        this.qrHdrID,
        this.qrPOItemHdrID,
        this.length,
        this.fileName,
        this.fileContent,
    });

    factory ImageModal.fromJson(Map<String, dynamic> json) {
        return ImageModal(
            pRowID: json['pRowID'],
            qrHdrID: json['qrHdrID'],
            qrPOItemHdrID: json['qrPOItemHdrID'],
            length: json['length'],
            fileName: json['fileName'],
            fileContent: json['fileContent'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'pRowID': pRowID,
            'qrHdrID': qrHdrID,
            'qrPOItemHdrID': qrPOItemHdrID,
            'length': length,
            'fileName': fileName,
            'fileContent': fileContent,
        };
    }
}
