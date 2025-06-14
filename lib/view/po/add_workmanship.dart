import 'package:flutter/material.dart';

class AddWorkManShip extends StatefulWidget {
  const AddWorkManShip({super.key});

  @override
  State<AddWorkManShip> createState() => _AddWorkManShipState();
}

class _AddWorkManShipState extends State<AddWorkManShip> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _criticalController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _minorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _criticalController.dispose();
    _majorController.dispose();
    _minorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Workmanship Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Code"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _criticalController,
              decoration: const InputDecoration(labelText: "Critical"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _majorController,
              decoration: const InputDecoration(labelText: "Major"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minorController,
              decoration: const InputDecoration(labelText: "Minor"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final Map<String, dynamic> newItem = {
                  'code': int.tryParse(_codeController.text) ?? 0,
                  'critical': int.tryParse(_criticalController.text) ?? 0,
                  'major': int.tryParse(_majorController.text) ?? 0,
                  'minor': int.tryParse(_minorController.text) ?? 0,
                  'total': (int.tryParse(_criticalController.text) ?? 0) +
                      (int.tryParse(_majorController.text) ?? 0) +
                      (int.tryParse(_minorController.text) ?? 0),
                  'description': _descriptionController.text,
                };
                Navigator.of(context).pop(newItem);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),

    );
  }
} 