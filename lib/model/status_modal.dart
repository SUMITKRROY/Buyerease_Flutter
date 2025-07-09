class StatusModel {
  final String tableName;
  String title;
  int status; // Now mutable

  StatusModel({
    required this.tableName,
    required this.title,
    required this.status,
  });

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      tableName: map['tableName'] ?? '',
      title: map['title'] ?? '',
      status: map['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tableName': tableName,
      'title': title,
      'status': status,
    };
  }
}
