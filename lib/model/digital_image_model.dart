class DigitalImageModel {
  final String pRowID;
  final String title;
  final String imagePath;
  final String? description;

  final String? QRHdrID;
  final String? QRPOItemHdrID;
  final String? Length;
  final String? FileName;
  final String? fileContent;

  DigitalImageModel({
    required this.pRowID,
    required this.title,
    required this.imagePath,
    this.description,
    this.QRHdrID,
    this.QRPOItemHdrID,
    this.Length,
    this.FileName,
    this.fileContent,
  });

  factory DigitalImageModel.fromMap(Map<String, dynamic> map) {
    return DigitalImageModel(
      pRowID: map['pRowID'] ?? '',
      title: map['title'] ?? '',
      imagePath: map['imagePath'] ?? '',
      description: map['description'],
      QRHdrID: map['QRHdrID'],
      QRPOItemHdrID: map['QRPOItemHdrID'],
      Length: map['Length'],
      FileName: map['FileName'],
      fileContent: map['fileContent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pRowID': pRowID,
      'title': title,
      'imagePath': imagePath,
      'description': description,
      'QRHdrID': QRHdrID,
      'QRPOItemHdrID': QRPOItemHdrID,
      'Length': Length,
      'FileName': FileName,
      'fileContent': fileContent,
    };
  }
}
