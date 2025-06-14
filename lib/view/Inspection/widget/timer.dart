import 'package:flutter/material.dart';

class TimePickerDemo extends StatefulWidget {
  @override
  _TimePickerDemoState createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _timeField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.teal)),
        Row(
          children: [
            Text(_selectedTime.format(context)),
            IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () => _selectTime(context),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Time Picker Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _timeField("Select Time"),
      ),
    );
  }
}
