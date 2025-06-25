import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/po_item_dtl_model.dart';

class QualityParameters extends StatefulWidget {
  final String pRowId;
  final VoidCallback? onChanged;

  const QualityParameters({super.key, required this.pRowId,this.onChanged});

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

  Widget _buildRadio(String title, String value1, String value2, String? groupValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(value1, style: TextStyle(fontSize: 12.sp)),
                value: value1,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(value2, style: TextStyle(fontSize: 12.sp)),
                value: value2,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
