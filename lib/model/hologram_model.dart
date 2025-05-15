/**
 * Created by Sumit Roy 02/05/2025
 */

class HologramModal {
  String? itemID;
  String? styleRefNo;
  String? code;
  String? description;
  String? customerName;
  String? department;
  String? vendor;
  String? hologramStatus;
  String? editableDate;
  String? hologramNo;
  String? hologramEstablishDate;
  String? hologramExpiryDate;
  int? synced;
  bool? isCheckedToSync;
  List<String>? imagesList;

  HologramModal({
    this.itemID,
    this.styleRefNo,
    this.code,
    this.description,
    this.customerName,
    this.department,
    this.vendor,
    this.hologramStatus,
    this.editableDate,
    this.hologramNo,
    this.hologramEstablishDate,
    this.hologramExpiryDate,
    this.synced,
    this.isCheckedToSync,
    this.imagesList,
  });

  factory HologramModal.fromJson(Map<String, dynamic> json) {
    return HologramModal(
      itemID: json['ItemID'],
      styleRefNo: json['style_ref_no'],
      code: json['code'],
      description: json['description'],
      customerName: json['customerName'],
      department: json['department'],
      vendor: json['vendor'],
      hologramStatus: json['hologramStatus'],
      editableDate: json['editable_date'],
      hologramNo: json['hologram_no'],
      hologramEstablishDate: json['hologram_establish_date'],
      hologramExpiryDate: json['hologram_expiry_date'],
      synced: json['synced'],
      isCheckedToSync: json['IsCheckedToSync'],
      imagesList: json['imagesList'] != null 
          ? List<String>.from(json['imagesList'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemID': itemID,
      'style_ref_no': styleRefNo,
      'code': code,
      'description': description,
      'customerName': customerName,
      'department': department,
      'vendor': vendor,
      'hologramStatus': hologramStatus,
      'editable_date': editableDate,
      'hologram_no': hologramNo,
      'hologram_establish_date': hologramEstablishDate,
      'hologram_expiry_date': hologramExpiryDate,
      'synced': synced,
      'IsCheckedToSync': isCheckedToSync,
      'imagesList': imagesList,
    };
  }
} 