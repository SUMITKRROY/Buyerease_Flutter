import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddWorkManShip extends StatefulWidget {
  const AddWorkManShip({super.key});

  @override
  State<AddWorkManShip> createState() => _AddWorkManShipState();
}

class _AddWorkManShipState extends State<AddWorkManShip> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? code;
  String? description;
  String? critical;
  String? major;
  String? minor;
  String? comments;
  String? _dropDownValue;
  List<String> base64string = [];
  String? imageType;
  String imageName = '';

  _convertImage(dynamic imageFile) async {
    Uint8List imageBytes;
    File imageToFile = File(imageFile!.path);
    imageBytes = await imageToFile.readAsBytes();
    imageType = imageToFile.path.split('.').last.toLowerCase();
    // base64string.add(base64.encode(imageBytes));
    base64string.add(base64.encode(imageBytes));
    log('base64string $base64string');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Workmanship',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              maxLines: 2,
              minLines: 1,
              // enabled: _customerCodeSetting != '0' ? false : true,
              keyboardType: TextInputType.name,
              onChanged: (value) => code = value,
              // initialValue: customerCode,
              controller: TextEditingController(text: code),
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
                label: Text('Code'),
                labelStyle: TextStyle(fontSize: 15),
                hintText: "Code",
              ),
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
              ),
            ),
            const SizedBox(height: 10),
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
                    onChanged: (value) => critical = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: critical),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Critical';
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
                      label: Text('Critical'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "Critical",
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
                    onChanged: (value) => major = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: major),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Major';
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
                      label: Text('Major'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "Major",
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
                    onChanged: (value) => minor = value,
                    // initialValue: customerCode,
                    controller: TextEditingController(text: minor),
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
                      label: Text('Minor'),
                      labelStyle: TextStyle(fontSize: 15),
                      hintText: "minor",
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
              onChanged: (value) => comments = value,
              // initialValue: customerCode,
              controller: TextEditingController(text: comments),
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
                label: Text('Comments'),
                labelStyle: TextStyle(fontSize: 15),
                hintText: "Customer Code",
              ),
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
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Done'))
          ],
        ),
      ),
    );
  }


}
