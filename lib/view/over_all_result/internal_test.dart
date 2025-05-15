import 'dart:io';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

class InternalTest extends StatefulWidget {
  const InternalTest({super.key});

  @override
  State<InternalTest> createState() => _InternalTestState();
}

class _InternalTestState extends State<InternalTest> {
  final ImagePickerService _imagePickerService = ImagePickerService();

  String? _dropDownValue;
  String? remark;

  List<String> base64string = [];
  String? imageType;
  String imageName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Internal Wiring'),
                Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: _dropDownValue == null
                            ? const Text('Select')
                            : Text(
                          _dropDownValue!,
                          style: const TextStyle(color: Colors.blue),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.blue),
                        items: ['Yes','No'].map(
                              (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
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
                      ),
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () async  {
                          final File? image = await _imagePickerService.pickImage(context);
                          if (image != null) {
                            imageName = image.path.split('/').last.toString();
                            setState(() {});
                          } else {
                            debugPrint('No image selected.');
                          }
                        },
                        icon: const Icon(Icons.camera_alt))),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(imageName == "" ? 'No Image Selected' : imageName)),
              ],
            ),
            Container(width: MediaQuery.of(context).size.width, child: Text('Add Comment if Yes',style: TextStyle(fontSize: 15),)),
            SizedBox(height: 10),
            Container(
              // width:
              // MediaQuery.of(context).size.width *
              //     0.8,
              // padding: const EdgeInsets.symmetric(
              //     horizontal: 20),
              // // margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                keyboardType: TextInputType.name,
                initialValue: remark,
                onChanged: (value) =>
                remark = value.trim(),
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: " Remark",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
