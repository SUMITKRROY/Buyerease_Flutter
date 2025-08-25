/// Created by Roy on 08/07/2025
class ImageModal {
    String? pRowID;
    String? qrHdrID;
    String? qrPOItemHdrID;
    String? length;
    String? fileName;
    String? fileContent;
    String? imagePathID;

    ImageModal({
        this.pRowID,
        this.qrHdrID,
        this.qrPOItemHdrID,
        this.length,
        this.fileName,
        this.fileContent,
        this.imagePathID,
    });

    factory ImageModal.fromJson(Map<String, dynamic> json) {
        return ImageModal(
            pRowID: json['pRowID'],
            qrHdrID: json['QRHdrID'],
            qrPOItemHdrID: json['QRPOItemHdrID'],
            length: json['length'],
            fileName: json['ImageName'],
            fileContent: json['fileContent'],
            imagePathID: json['ImagePathID'],
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
