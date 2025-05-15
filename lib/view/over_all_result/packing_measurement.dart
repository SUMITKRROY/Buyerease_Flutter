import 'dart:io';

import 'package:buyerease/utils/camera.dart';
import 'package:flutter/material.dart';

class PackingMeasurement extends StatefulWidget {
  const PackingMeasurement({super.key});

  @override
  State<PackingMeasurement> createState() => _PackingMeasurementState();
}

class _PackingMeasurementState extends State<PackingMeasurement> {
  final List<Map<String, dynamic>> _itemList = [
    {
      'L': '10.0',
      'B': '14.0',
      'H': '6.0',
      'Wt': '0.0',
      'CBM': '9.0E-4',
      'Quantity': '0.0'
    }
  ];
  final ImagePickerService _imagePickerService = ImagePickerService();
  String imageName = '';
  final lController = TextEditingController();
  final bController = TextEditingController();
  final hController = TextEditingController();
  final wtController = TextEditingController();
  final cbmController = TextEditingController();
  final quantityController = TextEditingController();
  final remarkController = TextEditingController();
  String? _dropDownValue;
  String? remark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          // color:Colors.red,
          height: MediaQuery.of(context).size.height * 0.9,
          // height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.symmetric( vertical: 10),
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
              SingleChildScrollView(
            child: SizedBox(
              // height: 500,
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                  itemCount: 2,
                  itemBuilder: (e, index){
                return Container(
                  // color: Colors.blue,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Item Measurements"),
                        Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.3,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(hint: _dropDownValue == null ? const Text('Select'): Text(_dropDownValue!,style: const TextStyle(color: Colors.blue)),
                                    isExpanded: true, iconSize: 30.0,style: const TextStyle(color: Colors.blue), items: ['A(2)', 'A(1)'].map((val) {return DropdownMenuItem<String>(value: val, child: Text(val));},).toList(),
                                    onChanged: (val) {setState(() {_dropDownValue = val;});})))]),
                      Container(alignment: Alignment.centerLeft,child: const Text('Specification',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                      const SizedBox(height: 10),
                      Column(children: [
                        Row(mainAxisAlignment :MainAxisAlignment.spaceBetween, children: [
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'L')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'B')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'H')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Wt.')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'CBM')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Quantity')),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Row(mainAxisAlignment :MainAxisAlignment.spaceBetween, children: [
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['L'].toString(),style: const TextStyle(color: Colors.white),)),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['B'].toString(),style: const TextStyle(color: Colors.white),)),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['H'].toString(),style: const TextStyle(color: Colors.white),)),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['Wt'].toString(),style: const TextStyle(color: Colors.white),)),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['cbm'].toString(),style: const TextStyle(color: Colors.white),)),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,alignment:Alignment.center,color:Colors.blueAccent[100],child: Text(_itemList[0]['Quantity'].toString(),style: const TextStyle(color: Colors.white),))
                        ],
                        )
                      ]),
                      const SizedBox(height: 20),
                      Container(alignment: Alignment.centerLeft,child: const Text('Findings',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                      const SizedBox(height: 10),
                      Column(children: [
                        Row(mainAxisAlignment :MainAxisAlignment.spaceBetween, children: [
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'L')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'B')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'H')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Wt.')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'CBM')),
                          Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,color:Colors.blueAccent[100],alignment:Alignment.center,child: const Text(style:TextStyle(color: Colors.white),'Quantity'))]
                        ),
                        const SizedBox(height: 0.5),
                        Row(mainAxisAlignment :MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: lController)),
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: bController)),
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: hController)),
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: wtController)),
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: cbmController)),
                            Container(width: MediaQuery.of(context).size.width * 0.15,height:MediaQuery.of(context).size.width * 0.1,padding:const EdgeInsets.symmetric(horizontal: 10),color:Colors.blueAccent[100],child: TextField(controller: quantityController)),
                          ],
                        )
                      ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                        const Text('Result',style: TextStyle(color: Colors.grey,fontSize: 15)),
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
                              hint: _dropDownValue == null
                                  ? const Text('Select')
                                  : Text(_dropDownValue!,style: const TextStyle(color: Colors.blue)),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: const TextStyle(color: Colors.blue),
                              items: ['Awaiting', 'Failed'].map((val) {return DropdownMenuItem<String>(value: val, child: Text(val));}).toList(),
                              onChanged: (val) {setState(() {_dropDownValue = val;});},))),
                        const Text('0')]),
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
                  separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 5);
              }
              ),
            ),
          ),
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
    );
  }
}
