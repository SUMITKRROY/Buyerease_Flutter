import 'package:flutter/material.dart';
import '../database/table/genmst.dart';

class SampleSizeDropdown extends StatefulWidget {
  const SampleSizeDropdown({super.key});

  @override
  State<SampleSizeDropdown> createState() => _SampleSizeDropdownState();
}

class _SampleSizeDropdownState extends State<SampleSizeDropdown> {
  List<String> _items = [];
  String? _selected;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final genMst = GenMst();
    final items = await genMst.getSampleSizeDropdownItems();
    setState(() {
      _items = items;
      if (_items.isNotEmpty) _selected = _items.first;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownButton<String>(
      isExpanded: true,
      underline: const SizedBox(),
      value: _selected,
      items: _items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selected = value;
        });
      },
      hint: const Text('Select Sample Size'),
    );
  }
}
