import 'package:flutter/material.dart';
import 'parameter_detail_screen.dart';

class QualityParametersResult extends StatefulWidget {
  final String id;
  final VoidCallback onChanged; // ✅ Add this

  const QualityParametersResult({super.key, required this.id, required this.onChanged});

  @override
  State<QualityParametersResult> createState() => _QualityParametersResultState();
}

class _QualityParametersResultState extends State<QualityParametersResult> {
  List<Parameter> parameters = [
    Parameter(name: "Fabric Test", isRadio: false),
    Parameter(name: "Item Level Parameter 2", isRadio: true),
    Parameter(name: "Item Level Parameter 3", isRadio: true),
    Parameter(name: "Packaging", isRadio: false),
    Parameter(name: "PRODUCT PICTURES", isRadio: false),
    Parameter(name: "Rub Test", isRadio: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: parameters.length,
          itemBuilder: (context, index) {
            final param = parameters[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: param.isRadio
                  ? buildRadioRow(param)
                  : buildCheckboxRow(param),
            );
          },
        ),
      ),

    );
  }
  Widget buildCheckboxRow(Parameter param) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(param.name)),
        Row(
          children: [
            Text("Applicable"),
            Checkbox(
              value: param.isApplicable ?? false,
              onChanged: (val) {
                setState(() {
                  param.isApplicable = val;
                });
                if (val == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParameterDetailScreen(
                        parameterName: param.name, id: widget.id,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRadioRow(Parameter param) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(param.name),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text("Yes"),
                value: true,
                groupValue: param.radioValue,
                onChanged: (val) {
                  setState(() {
                    param.radioValue = val;
                  });
                  if (val == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParameterDetailScreen(
                          parameterName: param.name, id: widget.id,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text("No"),
                value: false,
                groupValue: param.radioValue,
                onChanged: (val) {
                  setState(() {
                    param.radioValue = val;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

}


class Parameter {
  final String name;
  final bool isRadio; // true for radio, false for checkbox
  bool? isApplicable; // for checkbox
  bool? radioValue;   // true (Yes), false (No)

  Parameter({
    required this.name,
    required this.isRadio,
    this.isApplicable = false,
    this.radioValue,
  });
}