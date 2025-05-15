/**
 * Created by Sumit Roy 02/05/2025
 */

class DigitalsUploadModel {
  String? pRowID;
  String? title;
  String? imageName;
  String? imageExtn;
  String? selectedPicPath;
  List<String>? imageArray;

  DigitalsUploadModel({
    this.pRowID,
    this.title,
    this.imageName,
    this.imageExtn,
    this.selectedPicPath,
    this.imageArray,
  });

  factory DigitalsUploadModel.fromJson(Map<String, dynamic> json) {
    return DigitalsUploadModel(
      pRowID: json['pRowID'],
      title: json['title'],
      imageName: json['ImageName'],
      imageExtn: json['ImageExtn'],
      selectedPicPath: json['selectedPicPath'],
      imageArray: json['imageArray'] != null 
          ? List<String>.from(json['imageArray'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pRowID': pRowID,
      'title': title,
      'ImageName': imageName,
      'ImageExtn': imageExtn,
      'selectedPicPath': selectedPicPath,
      'imageArray': imageArray,
    };
  }
} 