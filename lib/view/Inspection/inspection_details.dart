import 'package:flutter/material.dart';

class InspectionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('DEL0067121'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('SAVE', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('31-Jan-2025', style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          _infoRow('Customer', 'A H ASSO'),
          _infoRow('Vendor', 'A.B International'),
          _infoRow('Inspector', 'Admin'),
          _infoRow('Activity', 'In-Line'),
          _infoRow('Location', 'A.B International'),
          _infoRowWithTextField('Vendor Representative', 'Enter name'),
          SizedBox(height: 16),
          Text('Inspection detail', style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _dropdownField('Inspection Level', ['G-II'])),
              SizedBox(width: 16),
              Expanded(child: _dropdownField('Quality Level Major', ['AQL 2.5'])),
            ],
          ),
          SizedBox(height: 16),
          _dropdownField('Quality Level Minor', ['AQL 2.5']),
          SizedBox(height: 16),
          _dropdownField('Status', ['Select Status']),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _radioOption('Report Level')),
              Expanded(child: _radioOption('Material Level')),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _timeField('Arrival Time')),
              Expanded(child: _timeField('Start Time')),
              Expanded(child: _timeField('Complete Time')),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Remark',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {},
            child: Text('GO TO  PO DETAILS'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _infoRowWithTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: UnderlineInputBorder(), // <-- Only underline
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Customize color if needed
                ),
                focusedBorder: UnderlineInputBorder(),
              ),
            ),


          ),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {},
    );
  }

  Widget _radioOption(String label) {
    return Row(
      children: [
        Radio(value: false, groupValue: false, onChanged: (v) {}),
        Text(label),
      ],
    );
  }

  Widget _timeField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.teal)),
        Row(
          children: [
            Text('00:00'),
            IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
