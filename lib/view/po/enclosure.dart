import 'package:flutter/material.dart';

class Enclosure extends StatefulWidget {
  final String pRowId;
  const Enclosure({super.key, required this.pRowId});

  @override
  State<Enclosure> createState() => _EnclosureState();
}

class _EnclosureState extends State<Enclosure> {
  String dropdownValue = 'General';
  final TextEditingController fileNameController = TextEditingController();

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          Text('Category', style: TextStyle(fontSize: 12)),
          DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            style: TextStyle(fontSize: 12, color: Colors.black),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['General', 'Invoice', 'Packing List']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12)),
              );
            }).toList(),
          ),
          SizedBox(height: 10),

          // File Name Input
          TextField(
            controller: fileNameController,
            decoration: InputDecoration(
              labelText: 'File Name',
              labelStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 10),

          // Upload and options row
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Handle upload
                },
                icon: Icon(Icons.upload_file),
                label: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle view
                },
                icon: Icon(Icons.visibility),
                label: Text('View'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle delete
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
