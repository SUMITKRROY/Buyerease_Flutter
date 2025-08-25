import 'dart:core';
 

class OnSiteModal {
    String? pRowID;
    String? locID;
    String? onSiteTestID;
    String? inspectionLevelID;
    String? sampleSizeID;
    String? sampleSizeValue;
    String? inspectionResultID;
    int? recEnable;
    String? recUser;
    String? recDt;
    String? qrpoItemDtlID;
    String? qrHdrID;
    String? qrpoItemHdrID;

    OnSiteModal({
        this.pRowID,
        this.locID,
        this.onSiteTestID,
        this.inspectionLevelID,
        this.sampleSizeID,
        this.sampleSizeValue,
        this.inspectionResultID,
        this.recEnable,
        this.recUser,
        this.recDt,
        this.qrpoItemDtlID,
        this.qrHdrID,
        this.qrpoItemHdrID,
    });

    // Getters and setters for each field
    String? getpRowID() { return pRowID; }
    void setpRowID(String? pRowID) { this.pRowID = pRowID; }
    // ...repeat for all fields...

    // Optionally, override toString()
    @override
    String toString() {
        return "OnSiteModal{" +
                "pRowID='$pRowID', " +
                "locID='$locID', " +
                "onSiteTestID='$onSiteTestID', " +
                "inspectionLevelID='$inspectionLevelID', " +
                "sampleSizeID='$sampleSizeID', " +
                "sampleSizeValue='$sampleSizeValue', " +
                "inspectionResultID='$inspectionResultID', " +
                "recEnable=$recEnable, " +
                "recUser='$recUser', " +
                "recDt='$recDt', " +
                "qrpoItemDtlID='$qrpoItemDtlID', " +
                "qrHdrID='$qrHdrID', " +
                "qrpoItemHdrID='$qrpoItemHdrID'" +
                '}';
    }
}