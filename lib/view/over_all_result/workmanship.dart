
import 'package:flutter/material.dart';

import 'add_workmanship.dart';

class WorkManShip extends StatefulWidget {
  const WorkManShip({super.key});

  @override
  State<WorkManShip> createState() => _WorkManShipState();
}

class _WorkManShipState extends State<WorkManShip> {
  String? _dropDownValue;
  String? remark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
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
                          items: ['Pass','failed','Awaiting'].map(
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
                  IconButton(icon: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(12)),
                    child: const
                    Icon(Icons.add),
                  ),onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> const AddWorkManShip()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(children: [
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('Critical')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('Major')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('Minor')),
                  ],),
                  Row(children: [
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('Total')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                  ],),
                  Row(children: [
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('Permissible Defect')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                    Container(alignment: Alignment.center,width:MediaQuery.of(context).size.width* 0.22,child: Text('0')),
                  ],),
                ],
              ),
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
      )
    );
  }
}
