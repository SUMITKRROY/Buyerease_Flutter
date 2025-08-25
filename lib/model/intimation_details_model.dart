class IntimationDetailsModel {
  String? name;
  String? email;
  bool link;
  bool report;
  bool htmlLink;
  bool receiveApplicable;
  bool isSelected;

  IntimationDetailsModel({
    this.name,
    this.email,
    this.link = false,
    this.report = false,
    this.htmlLink = false,
    this.receiveApplicable = false,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'link': link,
      'report': report,
      'htmlLink': htmlLink,
      'receiveApplicable': receiveApplicable,
      'isSelected': isSelected,
    };
  }

  factory IntimationDetailsModel.fromJson(Map<String, dynamic> json) {
    return IntimationDetailsModel(
      name: json['name'],
      email: json['email'],
      link: json['link'] ?? false,
      report: json['report'] ?? false,
      htmlLink: json['htmlLink'] ?? false,
      receiveApplicable: json['receiveApplicable'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }
} 