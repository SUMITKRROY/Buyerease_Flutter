import 'package:flutter/material.dart';

class Enclosure extends StatefulWidget {
  @override
  _EnclosureState createState() => _EnclosureState();
}

class _EnclosureState extends State<Enclosure> {
  String dropdownValue = 'General';
  final TextEditingController fileNameController = TextEditingController();
  bool sendAsMail = false;

  List<Map<String, String>> files = [];

  void _uploadFile() {
    print('Upload file clicked'); // Add real file logic here
  }

  void _saveFile() {
    if (fileNameController.text.trim().isEmpty) return;

    setState(() {
      files.add({
        'title': fileNameController.text.trim(),
        'action': 'View/Delete',
      });
      fileNameController.clear();
      sendAsMail = false;
    });
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
                onPressed: _uploadFile,
                icon: Icon(Icons.add_circle_outline),
                label: Text('Upload File', style: TextStyle(fontSize: 12)),
              ),
              SizedBox(width: 10),
              Checkbox(
                value: sendAsMail,
                onChanged: (value) {
                  setState(() {
                    sendAsMail = value!;
                  });
                },
              ),
              Text('send as mail', style: TextStyle(fontSize: 12)),
              Spacer(),
              OutlinedButton(
                onPressed: _saveFile,
                child: Text('SAVE', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          Divider(height: 30),

          // Table headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text('Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(),

          // File list
          Expanded(
            child: files.isEmpty
                ? Center(child: Text('No files added', style: TextStyle(fontSize: 12)))
                : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index]['title'] ?? '', style: TextStyle(fontSize: 12)),
                  trailing: Text(files[index]['action'] ?? '', style: TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
