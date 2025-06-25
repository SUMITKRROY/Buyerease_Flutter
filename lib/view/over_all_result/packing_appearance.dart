import 'package:buyerease/components/add_image_icon.dart';
import 'package:buyerease/components/sample_size_dropdown.dart';
import 'package:flutter/material.dart';
import '../../database/table/genmst.dart';
import '../../components/over_all_dropdown.dart';
import '../../components/remarks.dart';

class PackingAppearance extends StatefulWidget {
  final String id;
  final VoidCallback onChanged;

  const PackingAppearance({super.key, required this.id, required this.onChanged});

  @override
  _PackingAppearanceState createState() => _PackingAppearanceState();
}

class _PackingAppearanceState extends State<PackingAppearance> {
  final List<String> results = ['PASS', 'FAIL'];
  List<Map<String, String>> items = [];
  late List<String> selectedSamples;
  late List<String> selectedResults;

  @override
  void initState() {
    super.initState();
    _loadGenMstData();
  }

  Future<void> _loadGenMstData() async {
    try {
      GenMst genMst = GenMst();
      final List<Map<String, dynamic>> data = await genMst.getByGenID('550');
      setState(() {
        items = data.map((item) {
          return {
            "desc": item['MainDescr']?.toString() ?? '',
          };
        }).toList();

        selectedSamples = List.generate(items.length, (_) => 'A(5)');
        selectedResults = List.generate(items.length, (_) => 'PASS');
      });
    } catch (e) {
      print('Error loading GenMst data: $e');
      setState(() {
        items = [];
        selectedSamples = [];
        selectedResults = [];
      });
    }
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
        Remarks()
      ],
    );
  }

  Widget _buildCardSection(String title) {
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

                // ✅ Safe usage, no Expanded inside SampleSizeDropdown anymore
                Expanded(
                  flex: 2,
                  child: SampleSizeDropdown(),
                ),

                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedResult,
                    underline: const SizedBox(),
                    onChanged: (value) {},
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
                ? AddImageIcon(
              title: "Unit pack appearance",
              id: widget.id,
              onImageAdded: widget.onChanged,
            )
                : AddImageIcon(
              title: "Shipping pack appearance",
              id: widget.id,
              onImageAdded: widget.onChanged,
            )
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
                child: SampleSizeDropdown(),
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

  Future<void> saveChanges() async {
    setState(() {});
    widget.onChanged.call();
  }
}
