import 'dart:io';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

class PackingAppearance extends StatefulWidget {
  const PackingAppearance({super.key});

  @override
  State<PackingAppearance> createState() => _PackingAppearanceState();
}

class _PackingAppearanceState extends State<PackingAppearance> {
  List data = ['Unit Packing', 'Shipping Mark', 'Master Packing'];
  final ImagePickerService _imagePickerService = ImagePickerService();
  String imageName = '';
  String? _dropDownValue;
  String? _dropDownValue2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
              const Divider(thickness: 1,color: Colors.black),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 5);
                  },
                  itemCount: data.length,
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
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Text(data[index])),
                              Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(3),
                                  //   border: Border.all(color: Colors.black, width: 1),
                                  //   color: Colors.white,
                                  // ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: _dropDownValue == null
                                          ? const Text('Select')
                                          : Text(
                                              _dropDownValue!,
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      style: const TextStyle(color: Colors.blue),
                                      items: ['A(2)', 'A(1)'].map(
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(3),
                                //   border: Border.all(color: Colors.black, width: 1),
                                //   color: Colors.white,
                                // ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: _dropDownValue2 == null
                                        ? const Text('Select')
                                        : Text(
                                            _dropDownValue2!,
                                            style:
                                                const TextStyle(color: Colors.blue),
                                          ),
                                    isExpanded: true,
                                    iconSize: 30.0,
                                    style: const TextStyle(color: Colors.blue),
                                    items: ['Awaiting', 'Failed'].map((val) {
                                      return DropdownMenuItem<String>(
                                          value: val, child: Text(val));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          _dropDownValue2 = val;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
