import 'package:flutter/material.dart';

class ItemQuantity extends StatefulWidget {
  const ItemQuantity({super.key});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  List<String> listData = <String>['One', 'Two', 'Three', 'Four'];
  String? _dropDownValue;
  String? remark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Over All Result'),
                Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.black,width: 1),
                        color: Colors.white),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: _dropDownValue == null
                            ? const Text('Select')
                            : Text(_dropDownValue!,style: const TextStyle(color: Colors.blue)),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.blue),
                        items: ['PASS', 'FAILED'].map((val) {
                            return DropdownMenuItem<String>(
                              value: val,child: Text(val));}).toList(),
                        onChanged: (val) {
                          setState(() {_dropDownValue = val;},
                          );
                        },
                      ),
                    ))],
            ),
            const Divider(thickness: 1,color: Colors.black),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1),borderRadius: BorderRadius.circular(12),),
              child: Column(
                children: [
                  Row(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text('Latest Delivery Date :',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                    const Text('11-Nov-2022',style: TextStyle(fontSize: 15),)
                  ]),
                  Row(children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text('Shop Via :',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                    const Text('',style: TextStyle(fontSize: 15),)
                  ]),
                  Row(children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text('Order Quantity :',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                    const Text('100.0',style: TextStyle(fontSize: 15),)
                  ]),
                  Row(children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text('Available Quantity :',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                    const Text('100.0',style: TextStyle(fontSize: 15),)
                  ]),
                  Row(children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.4,
                        child: const Text('Accepted Quantity :',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)),
                    const Text('100.0',style: TextStyle(fontSize: 15),)
                  ]),
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
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]), child: const Text('SAVE',style: TextStyle(color: Colors.white)),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
