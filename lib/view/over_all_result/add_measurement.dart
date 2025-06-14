import 'dart:io';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

import '../../config/theame_data.dart';

class AddMeasurement extends StatefulWidget {
  const AddMeasurement({super.key});

  @override
  State<AddMeasurement> createState() => _AddMeasurementState();
}

class _AddMeasurementState extends State<AddMeasurement> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? length;
  String? width;
  String? height;
  String? description;
  String? _dropDownValue;
  String? _dropDownValue2;

  List<String> base64string = [];
  String? imageType;
  String imageName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: const Text('Add Measurement',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {},
            icon: Icon(Icons.search), // or any other icon
          )

        ],
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    maxLines: 2,
                    minLines: 1,
                    // enabled: _customerCodeSetting != '0' ? false : true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => length = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: length),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter length';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true, // important line
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      border: InputBorder.none,
                      label: Text('length'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "length",
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    maxLines: 2,
                    minLines: 1,
                    // enabled: _customerCodeSetting != '0' ? false : true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => width = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: width),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter width';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true, // important line
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.0)),
                      border: InputBorder.none,
                      label: Text('width'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "width",
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    maxLines: 2,
                    minLines: 1,
                    // enabled: _customerCodeSetting != '0' ? false : true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => height = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: height),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter height';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true, // important line
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      border: InputBorder.none,
                      label: Text('Height'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "Height",
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 2,
              minLines: 1,
              // enabled: _customerCodeSetting != '0' ? false : true,
              keyboardType: TextInputType.name,
              onChanged: (value) => description = value,
              // initialValue: customerCode,
              controller: TextEditingController(text: description),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Customer code';
                }
                return null;
              },
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                isDense: true, // important line
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                border: InputBorder.none,
                label: Text('Description'),
                labelStyle: TextStyle(fontSize: 15),
                hintText: "Customer Code",
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    items: ['Pass', 'failed', 'Awaiting'].map(
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
                    hint: _dropDownValue2 == null
                        ? const Text('Select')
                        : Text(
                      _dropDownValue2!,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    isExpanded: true,
                    iconSize: 30.0,
                    style: const TextStyle(color: Colors.blue),
                    items: ['Pass', 'failed', 'Awaiting'].map(
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
                          _dropDownValue2 = val;
                        },
                      );
                    },
                  ),
                )),
              ],
            ),
            const SizedBox(height: 10),
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     IconButton(onPressed: () {  }, icon: const Icon(Icons.camera_alt)),
            //     IconButton(onPressed: () {  }, icon: const Icon(Icons.camera_alt)),
            //   ],
            // ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Return measurement data to previous screen
                Navigator.pop(context, {
                  'length': length,
                  'width': width,
                  'height': height,
                  'description': description,
                  'result1': _dropDownValue,
                  'result2': _dropDownValue2,
                  'imageName': imageName,
                });
              },
              child: const Text('Finding')
            )
          ],
        ),
      ),
    );
  }
}
