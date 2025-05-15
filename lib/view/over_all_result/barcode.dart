import 'dart:io';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

class BarCode extends StatefulWidget {
  const BarCode({super.key});

  @override
  State<BarCode> createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final specificationController = TextEditingController();
  final visualController = TextEditingController();
  String? _dropDownValue;
  String? remark;
  List dataBarCode = [
    'Unit Packing',
    'Master Packing'
  ];
  List<String> base64string = [];
  String? imageType;
  String imageName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Over All Result'),
                  Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                      ),
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
                        items: ['PASS', 'FAILED'].map(
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
                      )),
                ],
              ),
              const Divider(thickness: 1, color: Colors.blue),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.builder(
                    itemCount: dataBarCode.length,
                    itemBuilder: (e, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dataBarCode[index], style: const TextStyle(color: Colors.blueAccent, fontSize: 15)),
                                Container(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(3),
                                    //   border: Border.all(color: Colors.black, width: 1),
                                    //   color: Colors.white,
                                    // ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: _dropDownValue == null
                                            ? const Text('Select')
                                            : Text(_dropDownValue!, style: const TextStyle(color: Colors.blue),),
                                        isExpanded: true,
                                        iconSize: 30.0,
                                        style: const TextStyle(color: Colors.blue),
                                        items: ['A(2)', 'A(1)'].map(
                                          (val) {return DropdownMenuItem<String>(value: val,child: Text(val),
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
                                    ))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Result', style: TextStyle(color: Colors.blueAccent[200], fontSize: 12)),
                                Container(height: 35,width: MediaQuery.of(context).size.width * 0.3,padding: const EdgeInsets.symmetric(horizontal: 10),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(3),
                                    //   border: Border.all(color: Colors.black, width: 1),
                                    //   color: Colors.white,
                                    // ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: _dropDownValue == null
                                            ? const Text('Select')
                                            : Text(_dropDownValue!, style: const TextStyle(color: Colors.blue)),
                                        isExpanded: true,
                                        iconSize: 30.0,
                                        style: const TextStyle(color: Colors.blue),
                                        items: ['A(2)', 'A(1)'].map((val) {return DropdownMenuItem<String>(value: val,child: Text(val));}).toList(),
                                        onChanged: (val) {setState(() {_dropDownValue = val;});},
                                      ),
                                    ))
                              ],
                            ),
                            Column(children: [
                              Row(mainAxisAlignment :MainAxisAlignment.spaceEvenly, children: [
                                Container(width: MediaQuery.of(context).size.width * 0.3,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Specification')),
                                Container(width: MediaQuery.of(context).size.width * 0.3,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Visual')),
                              ],
                              ),
                              const SizedBox(height: 0.5),
                              Row(mainAxisAlignment :MainAxisAlignment.spaceEvenly, children: [
                                Container(width: MediaQuery.of(context).size.width * 0.3,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: TextField(controller: specificationController)),
                                Container(width: MediaQuery.of(context).size.width * 0.3,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: TextField(controller: visualController)),
                                ],
                              )
                            ]),
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
                                            setState(() {});}
                                          else {debugPrint('No image selected.');}
                                        },
                                        icon: const Icon(Icons.camera_alt))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(imageName == "" ? 'No Image Selected' : imageName)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 10),
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
                    borderRadius: BorderRadius.circular(12)),
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
      ),
    );
  }
}
