import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:buyerease/database/database_helper.dart';
import '../model/digitals_upload_model.dart';
import '../model/hologram_model.dart';
import '../model/inspection_model.dart';
import '../model/item_measurement_model.dart';
import '../model/po_item_dtl_model.dart';
import '../model/quality_parameter_model.dart';
import '../model/workmanship_model.dart';
import '../utils//fsl_log.dart';

class GenUtils {
  static const int MINIMUM_VALID_WORD_LENGTH = 4;
  static const int MINIMUM_WORDS_IN_A_VALID_TEXT_STRING = 2;
  static const String TAG = "GenUtils";
  static bool _erro = false;

  static String truncate(String str, int len) {
    FslLog.d(TAG, " string for truncate  ...$str");
    if (str.isNotEmpty) {
      if (str.length > len) {
        return "${str.substring(0, len)}...";
      } else {
        return str;
      }
    } else {
      return "";
    }
  }

  static Text getHtmlText(String pText) {
    // Flutter has different approach to HTML rendering
    // You may need to use flutter_html package for better HTML rendering
    return Text(pText);
  }

  static Color getColorResource(BuildContext context, int id) {
    // Using Theme.of(context) to get colors
    return Theme.of(context).colorScheme.primary; // Adjust as needed
  }

  static void getBackgroundDrawable(Widget view, BuildContext context, int id) {
    // In Flutter, you'd typically use Container with decoration
    // This is more of a conceptual translation
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: view,
    );
  }

  static void forInfoAlertDialog(
    BuildContext context,
    String action,
    String title,
    String message,
    AlertDialogClickListener? clickListener,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(action),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onPositiveButton();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void forSingleButtonAlertDialog(
    BuildContext context,
    String posAction,
    String title,
    String message,
    AlertDialogClickListener? clickListener,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(posAction),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onPositiveButton();
                }
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (clickListener != null) {
        clickListener.onNegativeButton();
      }
    });
  }

  static void forConfirmationAlertDialog(
    BuildContext context, 
    String posAction,
    String negAction,
    String title,
    String message,
    AlertDialogClickListener clickListener,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(negAction),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onNegativeButton();
                }
              },
            ),
            TextButton(
              child: Text(posAction),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onPositiveButton();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void forEditableConfirmationAlertDialog(
    BuildContext context,
    String posAction,
    String negAction,
    String title,
    String msg,
    AlertDialogCallBackClickListener clickListener,
  ) {
    final TextEditingController editTextController = TextEditingController(text: msg);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: TextField(
            controller: editTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(negAction),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onNegativeButton();
                }
              },
            ),
            TextButton(
              child: Text(posAction),
              onPressed: () {
                Navigator.of(context).pop();
                if (clickListener != null) {
                  clickListener.onPositiveButton(editTextController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showListDialog(
    BuildContext context,
    String title,
    List<String> itemsList,
    ListDialogClickListener clickListener,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(itemsList[index]),
                  onTap: () {
                    Navigator.of(context).pop();
                    clickListener.onItemSelectedPos(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static double convertDpToPixel(double dp, BuildContext context) {
    return dp * MediaQuery.of(context).devicePixelRatio;
  }

  static bool isWhiteSpaceOnly(String stringToCheck) {
    return stringToCheck.trim().isEmpty;
  }

  static bool isPotentiallyValidText(String stringToCheck) {
    int wordLenCounter = 0;
    int validWordsCounter = 0;

    for (int i = 0; i < stringToCheck.length; i++) {
      String char = stringToCheck[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        wordLenCounter++;
      } else {
        if (wordLenCounter >= MINIMUM_VALID_WORD_LENGTH) {
          validWordsCounter++;
        }
        wordLenCounter = 0;
      }
    }

    // to count last word
    if (wordLenCounter >= MINIMUM_VALID_WORD_LENGTH) {
      validWordsCounter++;
    }

    FslLog.d("GenUtils.isPotentiallyValidText", "No of valid words is $validWordsCounter");

    return validWordsCounter >= MINIMUM_WORDS_IN_A_VALID_TEXT_STRING;
  }

  static bool isMeaningfulComment(String stringToCheck) {
    if (isWhiteSpaceOnly(stringToCheck)) {
      return false;
    }

    if (RegExp(r'^\d+$').hasMatch(stringToCheck)) {
      return false;
    }

    return isPotentiallyValidText(stringToCheck);
  }

  static String get12HourTimeFormatStr(int hour, int mins) {
    String selectedHourStr, selectedMinStr, am_pmstr;
    
    if (hour > 11) {
      selectedHourStr = hour > 12 ? (hour - 12).toString() : hour.toString();
      am_pmstr = " PM";
    } else {
      selectedHourStr = hour.toString();
      am_pmstr = " AM";
    }

    selectedMinStr = mins > 9 ? mins.toString() : "0$mins";

    return "$selectedHourStr:$selectedMinStr$am_pmstr";
  }

  static String get12HourTimeFormatStrWithSmallAmOrPm(int hour, int mins) {
    String selectedHourStr, selectedMinStr, am_pmstr;
    
    if (hour > 11) {
      selectedHourStr = hour > 12 ? (hour - 12).toString() : hour.toString();
      am_pmstr = " pm";
    } else {
      selectedHourStr = hour.toString();
      am_pmstr = " am";
    }

    selectedMinStr = mins > 9 ? mins.toString() : "0$mins";

    return "$selectedHourStr:$selectedMinStr$am_pmstr";
  }

  static bool isItAMTime(int hour, int mins) {
    return hour <= 11;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isAlphaNumeric(String str) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(str);
  }

  static bool isAlphaNumericSpace(String str) {
    return RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(str);
  }

  static bool isOnlyAlphabets(String str) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(str);
  }

  static String removeAllSpaces(String str) {
    return str.replaceAll(' ', '');
  }

  static bool isValidEmail(String target) {
    return target.isNotEmpty && RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(target);
  }

  static bool isValidDomainName(String target) {
    return target.isNotEmpty && RegExp(r'^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$').hasMatch(target);
  }

  static String addPlusSignInPhoneNum(String number) {
    FslLog.d(TAG, "Phone number received: $number");

    String phoneNumber = number.trim();

    int indexOfPlus = phoneNumber.indexOf('+');
    bool startsWith91 = phoneNumber.startsWith("91");

    if (indexOfPlus == -1 && startsWith91) {
      phoneNumber = "+$phoneNumber";
    }

    FslLog.d(TAG, "Phone number modified: $phoneNumber");

    return phoneNumber;
  }

  static String removePlusSignInPhoneNum(String number) {
    FslLog.d(TAG, "Phone number received: $number");

    String phoneNumber = number.trim();
    int indexOfPlus = phoneNumber.indexOf('+');

    if (indexOfPlus > -1) {
      phoneNumber = phoneNumber.substring(indexOfPlus + 1);
    }

    FslLog.d(TAG, "Phone number modified: $phoneNumber");

    return phoneNumber;
  }

  static bool isValidNameOfString(String str) {
    if (str.isEmpty) {
      return false;
    }
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(str);
  }

  static int calculateNoOfColumns(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    double dpWidth = width / devicePixelRatio;
    int noOfColumns = (dpWidth / 180).floor();
    return noOfColumns;
  }

  static Future<File> getFile(BuildContext context, String folderName, String filename) async {
    Directory directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/$folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/$filename');
  }

  static void grantAllUriPermissions(BuildContext context, Intent intent, Uri uri) {
    // This function is platform-specific
    // In Flutter, we typically don't need to handle permission granting manually
    // as the plugins handle it for us
  }

  static void showToastInThread(BuildContext context, String message) {
    // Using SnackBar instead of Toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void safeToastShow(String TAG, BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Future<Uri?> getUri(BuildContext context, File file) async {
    // This is platform-specific, but Flutter abstracts this
    return Uri.file(file.path);
  }

  static bool isStringInt(String s) {
    try {
      int.parse(s);
      return true;
    } catch (FormatException) {
      return false;
    }
  }

  // JSON serialization methods
  static String serializeInspectionModal(InspectionModal inspectionModal) {
    return jsonEncode(inspectionModal.toJson());
  }

  static InspectionModal deSerializeInspectionModal(String json) {
    return InspectionModal.fromJson(jsonDecode(json));
  }

  static String serializeItemReportModal(POItemDtl itemPackingModel) {
    return jsonEncode(itemPackingModel.toJson());
  }

  static POItemDtl deSerializeItemReportModal(String json) {
    return POItemDtl.fromJson(jsonDecode(json));
  }

  static String serializeDigitalModal(DigitalsUploadModel digitalsUploadModal) {
    return jsonEncode(digitalsUploadModal.toJson());
  }

  static String serializeItemMeasurementModal(ItemMeasurementModel itemMeasurementModal) {
    return jsonEncode(itemMeasurementModal.toJson());
  }

  static ItemMeasurementModel deSerializeItemMeasurement(String json) {
    return ItemMeasurementModel.fromJson(jsonDecode(json));
  }

  static WorkmanshipModel deSerializeWorkmanship(String json) {
    return WorkmanshipModel.fromJson(jsonDecode(json));
  }

  static String serializeWorkmanship(WorkmanshipModel workManShipModel) {
    return jsonEncode(workManShipModel.toJson());
  }

  static POItemDtl deSerializePOItemModal(String json) {
    return POItemDtl.fromJson(jsonDecode(json));
  }

  static String serializePOItemModal(POItemDtl poItemDtl) {
    return jsonEncode(poItemDtl.toJson());
  }

  static DigitalsUploadModel deSerializeDigitalUpload(String json) {
    return DigitalsUploadModel.fromJson(jsonDecode(json));
  }

  static QualityParameter deSerializeQualityParameter(String json) {
    return QualityParameter.fromJson(jsonDecode(json));
  }

  static String serializeQualityParameter(QualityParameter qualityParameter) {
    return jsonEncode(qualityParameter.toJson());
  }

  static HologramModal deSerializeStyle(String json) {
    return HologramModal.fromJson(jsonDecode(json));
  }

  static String serializeStyle(HologramModal hologramModal) {
    return jsonEncode(hologramModal.toJson());
  }

  static List<POItemDtl> deSerializePOItemDtlList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    return jsonList.map((item) => POItemDtl.fromJson(item)).toList();
  }

  static List<HologramModal> deSerializeHologramList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    return jsonList.map((item) => HologramModal.fromJson(item)).toList();
  }

  static String serializeHologramList(List<HologramModal> pList) {
    List<Map<String, dynamic>> jsonList = pList.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }

  // Function to alter a table and add a column with type REAL
  static Future<void> handleToAlterAsReal(String tableName, String columnName) async {
    final db = await DatabaseHelper().database;  // Get the database instance

    // SQL query to add the new column with REAL type
    String alterQuery = "ALTER TABLE $tableName ADD COLUMN $columnName REAL";

    try {
      // Execute the query to alter the table
      await db.execute(alterQuery);
      print("Column $columnName added successfully as REAL in $tableName");
    } catch (e) {
      // Log any error that occurs during the execution
      print("Error altering $tableName: $e");
    }
  }

  static Future<bool> columnExistsInTable(
      {required String table, required String columnToCheck}) async {
    final db = await DatabaseHelper().database;
    bool exists = false;
    
    try {
      // Query a row and check if the column exists
      final result = await db.rawQuery('PRAGMA table_info($table)');
      for (var column in result) {
        if (column['name'] == columnToCheck) {
          exists = true;
          break;
        }
      }
    } catch (e) {
      FslLog.e(TAG, "Error checking if column exists: $e");
    }
    
    return exists;
  }

  static Future<List<Map<String, dynamic>>> getColumnExistsInTable( String table) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> columns = [];
    
    try {
      columns = await db.rawQuery('PRAGMA table_info($table)');
    } catch (e) {
      FslLog.e(TAG, "Error getting table columns: $e");
    }
    
    return columns;
  }
}

// Helper classes
class AlertDialogClickListener {
  final Function onPositiveButton;
  final Function onNegativeButton;

  AlertDialogClickListener({
    required this.onPositiveButton,
    required this.onNegativeButton,
  });
}

class AlertDialogCallBackClickListener {
  final Function(String) onPositiveButton;
  final Function onNegativeButton;

  AlertDialogCallBackClickListener({
    required this.onPositiveButton,
    required this.onNegativeButton,
  });
}

class ListDialogClickListener {
  final Function(int) onItemSelectedPos;
  final Function onCancel;

  ListDialogClickListener({
    required this.onItemSelectedPos,
    required this.onCancel,
  });
}

// This is a mock class for demonstrating Intent functionality
// In Flutter, Intents are typically handled differently
class Intent {
  final String action;
  Intent(this.action);
}
