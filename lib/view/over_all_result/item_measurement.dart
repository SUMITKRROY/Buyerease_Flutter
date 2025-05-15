
import 'package:flutter/material.dart';

import 'add_measurement.dart';

class ItemMeasurement extends StatefulWidget {
  const ItemMeasurement({super.key});

  @override
  State<ItemMeasurement> createState() => _ItemMeasurementState();
}

class _ItemMeasurementState extends State<ItemMeasurement> {
  String? _dropDownValue;
  String? remark;
  String? toleranceRange;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Over All Result'),
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
                  IconButton(
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.add),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> const AddMeasurement()),);
                      }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              // width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.black),
                  color: Colors.white),
              child: Column(
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Length', style: TextStyle(fontSize: 12)),
                        Text('Height', style: TextStyle(fontSize: 12)),
                        Text('Width', style: TextStyle(fontSize: 12)),
                        Text('Sample Size', style: TextStyle(fontSize: 12)),
                        Text('Delete', style: TextStyle(fontSize: 12))
                      ]),
                  const SizedBox(height: 15),
                  SizedBox(
                    height:MediaQuery.of(context).size.width * 0.2,
                    child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (e, index) {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('10.0'),
                              Text('10.0'),
                              Text('10.0'),
                              Text('10.0'),
                              Icon(Icons.delete)
                            ],
                          );
                        }),
                  ),
                  Row(
                    children: [
                      Text('Tolerance Range'),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          maxLines: 2,
                          minLines: 1,
                          // enabled: _customerCodeSetting != '0' ? false : true,
                          keyboardType: TextInputType.name,
                          onChanged: (value) => toleranceRange = value,
                          // initialValue: customerCode,
                          controller: TextEditingController(text: toleranceRange),
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
                            label: Text(''),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Description'),
                      SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          enabled: false,
                          maxLines: 2,
                          minLines: 1,
                          // enabled: _customerCodeSetting != '0' ? false : true,
                          keyboardType: TextInputType.name,
                          onChanged: (value) => toleranceRange = value,
                          // initialValue: customerCode,
                          controller: TextEditingController(text: toleranceRange),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Description ';
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
                            hintText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(width: MediaQuery.of(context).size.width * 1, child: const  Text('Remark',style: TextStyle(fontSize: 16),),),
            Container(
              // width:
              // MediaQuery.of(context).size.width *
              //     0.8,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20),
              // // margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 1),
                  borderRadius: BorderRadius.circular(3)),
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
        ));
  }
}
