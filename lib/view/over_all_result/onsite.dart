import 'package:flutter/material.dart';

class OnSite extends StatefulWidget {
  const OnSite({super.key});

  @override
  State<OnSite> createState() => _OnSiteState();
}

class _OnSiteState extends State<OnSite> {
  String? _dropDownValue;
  String? remark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:
        Column(
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
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    Container(child: Text('Description',style: TextStyle(fontWeight: FontWeight.w500),)),
                    Container(width: MediaQuery.of(context).size.width * 0.2,child: Text('Description',style: TextStyle(fontWeight: FontWeight.w500),)),
                    Container(width: MediaQuery.of(context).size.width * 0.2,child: Text('Sample Size',style: TextStyle(fontWeight: FontWeight.w500),)),
                    Container(width: MediaQuery.of(context).size.width * 0.2,child: Text('Result',style: TextStyle(fontWeight: FontWeight.w500),))
                  ],),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListView.builder(
                    itemCount: 2,
                      itemBuilder: (e, index){return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Container(child: const Text('Description')),
                        Container(child:  Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.2,
                            // padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              ),
                            ))),
                        Container(child:  Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.2,
                            // padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              ),
                            ))),
                        Container(child:  Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.2,
                            // padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              ),
                            )))
                      ],);}),
                ),
              ],
            ),
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
        ),)
    );
  }
}
