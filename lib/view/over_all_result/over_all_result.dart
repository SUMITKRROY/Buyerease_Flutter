
import 'package:buyerease/view/over_all_result/packing_appearance.dart';
import 'package:buyerease/view/over_all_result/packing_measurement.dart';
import 'package:buyerease/view/over_all_result/quality_parameters_result.dart';
import 'package:buyerease/view/over_all_result/sample_collected.dart';
import 'package:buyerease/view/over_all_result/test_reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theame_data.dart';
import 'over_all_workmanship.dart';
import 'barcode.dart';
import 'digital_uploaded.dart';
import 'history.dart';
import 'internal_test.dart';
import 'item_measurement.dart';
import 'item_quantity.dart';
import 'onsite.dart';


class OverAllResult extends StatefulWidget {
  const OverAllResult({super.key, required this.id});

  final String id;

  @override
  State<OverAllResult> createState() => _OverAllResultState();
}

class _OverAllResultState extends State<OverAllResult>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  String? _dropDownValue;

  bool _hasUnsavedChanges = false; // NEW
  bool _isSaving = false; // NEW

  final GlobalKey<State<ItemQuantity>> _itemQuantityKey = GlobalKey(); // NEW
  final GlobalKey<State<PackingAppearance>> _packingAppearanceKey = GlobalKey(); // NEW
  final GlobalKey<State<PackingMeasurement>> _packingMeasurementKey = GlobalKey(); // NEW
  final GlobalKey<State<BarCode>> _barcodeKey = GlobalKey(); // NEW
  final GlobalKey<State<WorkManShip>> _workmanshipKey = GlobalKey(); // NEW
  final GlobalKey<State<QualityParametersResult>> _qualityParametersResultKey = GlobalKey(); // NEW
  final GlobalKey<State<DigitalUploaded>> _digitalUploadedKey = GlobalKey(); // NEW
  final GlobalKey<State<TestReports>> _testReportsKey = GlobalKey(); // NEW

  List<Widget> list = const [
    Tab(text: 'Item/Quantity'),
    Tab(text: 'Packing Appearance'),
    Tab(text: 'Packing Measurement'),
    Tab(text: 'Barcode'),
    Tab(text: 'OnSite'),
    Tab(text: 'Workmanship'),
    Tab(text: 'Sample Collected'),
    Tab(text: 'Item Measurement'),
    Tab(text: 'History'),
    Tab(text: 'Quality Parameters'),
    Tab(text: 'Internal Test'),
    Tab(text: 'Digital Uploaded'),
    Tab(text: 'Test Reports'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      switch (_selectedIndex) {
        case 0:
          await (_itemQuantityKey.currentState as dynamic)?.saveChanges();
          break;
        case 1:
          await (_packingAppearanceKey.currentState as dynamic)?.saveChanges();
          break;
        case 2:
          await (_packingMeasurementKey.currentState as dynamic)?.saveChanges();
          break;
        case 3:
          await (_barcodeKey.currentState as dynamic)?.saveChanges();
          break;
        case 5:
          await (_workmanshipKey.currentState as dynamic)?.saveChanges();
          break;
        case 9:
          await (_qualityParametersResultKey.currentState as dynamic)?.saveChanges();
          break;
        case 11:
          await (_digitalUploadedKey.currentState as dynamic)?.saveChanges();
          break;
        case 12:
          await (_testReportsKey.currentState as dynamic)?.saveChanges();
          break;
      }

      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: ListTile(
          title: Text("Item detail", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          subtitle: Text("Item no.(${widget.id})", style: TextStyle(color: Colors.white, fontSize: 12.sp)),
        ),
        actions: [
          TextButton(
            onPressed: (_hasUnsavedChanges && !_isSaving) ? _saveChanges : null,
            child: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(
              'SAVE',
              style: TextStyle(
                color: _hasUnsavedChanges ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Over All Result'),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: _dropDownValue == null
                            ? const Text('Select')
                            : Text(_dropDownValue!, style: const TextStyle(color: ColorsData.primaryColor)),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: ColorsData.primaryColor),
                        items: ['PASS', 'FAILED']
                            .map((val) => DropdownMenuItem<String>(value: val, child: Text(val)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _dropDownValue = val;
                            _hasUnsavedChanges = true; // NEW
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TabBar(
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabs: list,
                controller: _controller,
                onTap: (index) {
                  if (_hasUnsavedChanges) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Unsaved Changes'),
                        content: const Text('Please save changes before switching tabs.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _controller!.index = index;
                  }
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    ItemQuantity(
                      key: _itemQuantityKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    PackingAppearance(
                      key: _packingAppearanceKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    PackingMeasurement(
                      key: _packingMeasurementKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    BarCode(
                      key: _barcodeKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    const OnSite(),
                    WorkManShip(
                      key: _workmanshipKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    const SampleCollected(),
                    const ItemMeasurement(),
                    const History(),
                    QualityParametersResult(
                      key: _qualityParametersResultKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    const InternalTest(),
                    DigitalUploaded(
                      key: _digitalUploadedKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    TestReports(
                      key: _testReportsKey,
                      id: widget.id,
                      onChanged: () {
                        setState(() {
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
