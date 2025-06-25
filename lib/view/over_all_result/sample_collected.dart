import 'package:flutter/material.dart';

class SampleCollected extends StatefulWidget {
  const SampleCollected({super.key});

  @override
  State<SampleCollected> createState() => _SampleCollectedState();
}

class _SampleCollectedState extends State<SampleCollected> {
  final List<Map<String, dynamic>> rows = [];

  void _showInspectionDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Inspection Level',
            style: TextStyle(fontSize: 14), // Title text size
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogOption('ROAD SAMPLE'),
              _buildDialogOption('SAMPLE TO SHOW BUYERS'),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        rows.add({'purpose': result, 'samples': 0});
      });
    }
  }

  Widget _buildDialogOption(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 12), // Content text size
      ),
      onTap: () => Navigator.of(context).pop(title),
    );
  }




  void _removeRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  void _updateSampleCount(int index, String value) {
    setState(() {
      final parsed = int.tryParse(value) ?? 0;
      rows[index]['samples'] = parsed;
    });
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        Expanded(
          flex: 3,
          child: Text('Purpose', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 3,
          child: Text('Number of\nSamples', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 2,
          child: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildDataRow(int index) {
    final row = rows[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(row['purpose'],style: TextStyle(fontSize: 12))),
          Expanded(
            flex: 3,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _updateSampleCount(index, value),
              controller: TextEditingController(
                text: row['samples'].toString(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () => _removeRow(index),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Other content
          const SizedBox(height: 8),
          _buildHeaderRow(),
          const SizedBox(height: 8),
          ...List.generate(rows.length, (index) => _buildDataRow(index)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20), // Adjusted for better placement
        child: FloatingActionButton(
          onPressed: _showInspectionDialog,
          child: const Icon(Icons.add_circle_outline),
        ),
      ),
    );
  }

}
