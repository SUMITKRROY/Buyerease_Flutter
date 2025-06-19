import 'package:buyerease/components/add_image_icon.dart';
import 'package:flutter/material.dart';

import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';

class PackingAppearance extends StatefulWidget {
final String id;

PackingAppearance({required this.id});

  @override
  _PackingAppearanceState createState() => _PackingAppearanceState();
}

class _PackingAppearanceState extends State<PackingAppearance> {
  final List<String> sampleSizes = [
    'A(5)', 'B(3)', 'C(5)', 'D(8)', 'E(13)',
    'F(20)', 'G(32)', 'H(50)', 'J(80)', 'K(125)',
    'L(200)', 'M(315)', 'N(500)', 'Q(1250)', 'P(800)',
  ];

  final List<String> results = ['PASS', 'FAIL'];

  final List<Map<String, String>> items = [
    {"desc": "PACKAGING APPEARANCE"},
    {"desc": "PACKAGING DESCRIPTION"},
    {"desc": "Test"},
    {"desc": "Test12"},
    {"desc": "Test4"},
    {"desc": "Test3"},
    {"desc": "Test1"},
  ];

  late List<String> selectedSamples;
  late List<String> selectedResults;

  @override
  void initState() {
    super.initState();
    selectedSamples = List.generate(items.length, (_) => 'A(5)');
    selectedResults = List.generate(items.length, (_) => 'PASS');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OverAllDropdown(),

        _buildCardSection("Unit Packing"),
        _buildCardSection("Shipping Mark"),
        _buildTableHeader(),
        Expanded(child: _buildDataList()),
        // Remark
        Remarks()
      ],
    );
  }


  Widget _buildCardSection(String title) {
    String selectedSample = 'A(5)';
    String selectedResult = 'PASS';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Title
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Sample Size Dropdown
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSample,
                    underline: const SizedBox(),
                    onChanged: (value) {
                      // Optional: Handle change
                    },
                    items: sampleSizes.map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ),

                // Result Dropdown (PASS / FAIL)
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedResult,
                    underline: const SizedBox(),
                    onChanged: (value) {
                      // Optional: Handle change
                    },
                    items: ['PASS', 'FAIL'].map((result) {
                      return DropdownMenuItem(
                        value: result,
                        child: Text(result, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            title == "Unit Packing"
            ?  AddImageIcon(title: "Unit pack appearance", id: widget.id,)
           : AddImageIcon(title: "Shipping pack appearance", id: widget.id,)
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "SampleSize",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Result",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataList() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  items[index]["desc"]!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 2,
                child: _dropdown(
                  sampleSizes,
                  selectedSamples[index],
                      (value) {
                    setState(() {
                      selectedSamples[index] = value!;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: _dropdown(
                  results,
                  selectedResults[index],
                      (value) {
                    setState(() {
                      selectedResults[index] = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dropdown(List<String> items, String selectedValue, void Function(String?)? onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(height: 1, color: Colors.grey),
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
