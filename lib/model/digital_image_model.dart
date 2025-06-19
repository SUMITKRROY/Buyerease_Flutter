class DigitalImageModel {
  final String pRowID;
  final String title;
  final String imagePath;
  final String? description;

  DigitalImageModel({
    required this.pRowID,
    required this.title,
    required this.imagePath,
    this.description,
  });

  factory DigitalImageModel.fromMap(Map<String, dynamic> map) {
    return DigitalImageModel(
      pRowID: map['pRowID'] ?? '',
      title: map['title'] ?? '',
      imagePath: map['imagePath'] ?? '',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pRowID': pRowID,
      'title': title,
      'imagePath': imagePath,
      'description': description,
    };
  }
} 