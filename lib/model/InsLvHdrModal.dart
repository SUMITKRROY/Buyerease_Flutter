// InsLvHdrModal class
class InsLvHdrModal {
    String pRowID;
    String LocID;
    String InspDescr;
    String inspAbbrv;
    int recDirty;
    int recEnable;
    String recUser;
    String recDt;
    int IsDefault;

    InsLvHdrModal({
        required this.pRowID,
        required this.LocID,
        required this.InspDescr,
        required this.inspAbbrv,
        required this.recDirty,
        required this.recEnable,
        required this.recUser,
        required this.recDt,
        required this.IsDefault,
    });

    // Create an InsLvHdrModal from a map (SQLite row)
    factory InsLvHdrModal.fromMap(Map<String, dynamic> map) {
        return InsLvHdrModal(
            pRowID: map['pRowID'],
            LocID: map['LocID'],
            InspDescr: map['InspDescr'],
            inspAbbrv: map['InspAbbrv'],
            recDirty: map['recDirty'],
            recEnable: map['recEnable'],
            recUser: map['recUser'],
            recDt: map['recDt'],
            IsDefault: map['IsDefault'],
        );
    }

    // Create an InsLvHdrModal from JSON
    factory InsLvHdrModal.fromJson(Map<String, dynamic> json) {
        return InsLvHdrModal(
            pRowID: json['pRowID'],
            LocID: json['LocID'],
            InspDescr: json['InspDescr'],
            inspAbbrv: json['InspAbbrv'],
            recDirty: json['recDirty'],
            recEnable: json['recEnable'],
            recUser: json['recUser'],
            recDt: json['recDt'],
            IsDefault: json['IsDefault'],
        );
    }

    // Convert InsLvHdrModal to a map (for SQLite insert)
    Map<String, dynamic> toMap() {
        return {
            'pRowID': pRowID,
            'LocID': LocID,
            'InspDescr': InspDescr,
            'InspAbbrv': inspAbbrv,
            'recDirty': recDirty,
            'recEnable': recEnable,
            'recUser': recUser,
            'recDt': recDt,
            'IsDefault': IsDefault,
        };
    }
}