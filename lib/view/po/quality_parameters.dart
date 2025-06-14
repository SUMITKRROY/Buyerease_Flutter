import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QualityParameters extends StatefulWidget {
  @override
  _QualityParametersState createState() => _QualityParametersState();
}

class _QualityParametersState extends State<QualityParameters> {
  // Checkbox states
  bool sheetSize = false;
  bool metalDetection = false;
  bool radioactivity = false;
  bool radioactivityTest = false;
  bool woodTreatment = false;
  bool measurementAudit = false;

  // Radio states
  String? careLabel = 'No';
  String? frontBack = 'No';

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: EdgeInsets.all(08),
      child: ListView(
        children: [
          _buildCheckbox("Sheet size", sheetSize, (value) {
            setState(() {
              sheetSize = value!;
            });
          }),
          _buildCheckbox("METAL DETECTION REQUIRED", metalDetection, (value) {
            setState(() {
              metalDetection = value!;
            });
          }),
          _buildCheckbox("RADIOACTIVITY", radioactivity, (value) {
            setState(() {
              radioactivity = value!;
            });
          }),
          _buildCheckbox("RADIOACTIVITY TEST REQUIRED (STAINLESS STEEL)", radioactivityTest, (value) {
            setState(() {
              radioactivityTest = value!;
            });
          }),
          _buildCheckbox("WOOD TREATMENT REQUIRED", woodTreatment, (value) {
            setState(() {
              woodTreatment = value!;
            });
          }),
          _buildRadio("CARE LABEL", "Yes", "No", careLabel, (value) {
            setState(() {
              careLabel = value!;
            });
          }),
          _buildRadio("FRONT BACK", "Yes", "No", frontBack, (value) {
            setState(() {
              frontBack = value!;
            });
          }),
          _buildCheckbox("MEASUREMENT AUDIT", measurementAudit, (value) {
            setState(() {
              measurementAudit = value!;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 12.sp),
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildRadio(String title, String yes, String no, String? groupValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: yes,
                      groupValue: groupValue,
                      onChanged: onChanged,
                    ),
                    Text(
                      yes,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: no,
                      groupValue: groupValue,
                      onChanged: onChanged,
                    ),
                    Text(
                      no,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
