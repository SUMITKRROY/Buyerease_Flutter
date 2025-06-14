import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/theame_data.dart';

class OverAllDropdown extends StatefulWidget {
    OverAllDropdown({super.key});

  @override
  State<OverAllDropdown> createState() => _OverAllDropdownState();
}

class _OverAllDropdownState extends State<OverAllDropdown> {
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Over All Result',
          style: TextStyle(fontSize: 14.sp), // Font size 12
        ),
        SizedBox(
          width: 10,
        ),
        Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.15,
            //padding: const EdgeInsets.symmetric(horizontal: 10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(3),
            //   border: Border.all(color: Colors.black, width: 1),
            //   color: Colors.white,
            // ),
            child: DropdownButton(
              hint: _dropDownValue == null
                  ? Text('Select', style: TextStyle(fontSize: 12.sp))
                  : Text(
                _dropDownValue!,
                style: const TextStyle(
                    color: ColorsData.primaryColor, fontSize: 12),
              ),
              iconSize: 15.0,
              style:
              const TextStyle(color: ColorsData.primaryColor, fontSize: 12),
              items: ['PASS', 'FAILED'].map(
                    (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, style: const TextStyle(fontSize: 12)),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                      () {
                    _dropDownValue = val;
                  },
                );
              },
            )),
      ],
    );
  }
}
