import 'dart:convert';
import 'dart:developer' as developer;

import 'package:buyerease/model/po_item_dtl_model.dart';
import 'package:buyerease/view/po_level/po_item.dart';
import 'package:buyerease/view/po_level/quality_parameters.dart';
import 'package:buyerease/view/po_level/workmanship/po_workmanship.dart';
import 'package:flutter/material.dart';

import '../../config/theame_data.dart';
import '../../model/inspection_model.dart';
import 'carton.dart';
import 'enclosure.dart';
import 'more_details.dart';

class PoLevelTab extends StatefulWidget {
  final String pRowId;
      final InspectionModal inspectionModal;
      final POItemDtl poItemDtl;
  const PoLevelTab({super.key, required this.pRowId, required this.inspectionModal, required this.poItemDtl});

  @override
  State<PoLevelTab> createState() => _PoLevelTabState();
}

class _PoLevelTabState extends State<PoLevelTab> with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  final GlobalKey<State<StatefulWidget>> _poItemKey = GlobalKey<State<StatefulWidget>>();
final GlobalKey<State<PoWorkmanship>> _workmanshipKey = GlobalKey<State<PoWorkmanship>>();
final GlobalKey<State<Carton>> _cartonKey = GlobalKey<State<Carton>>();
final GlobalKey<State<MoreDetails>> _moreDetailsKey = GlobalKey<State<MoreDetails>>();
final GlobalKey<State<QualityParameters>> _qualityParametersKey = GlobalKey<State<QualityParameters>>();
final GlobalKey<State<Enclosure>> _enclosureKey = GlobalKey<State<Enclosure>>();


  List<Widget> list = const [
    Tab(text: 'PO/ITEM'),
    Tab(text: 'WORKMANSHIP'),
    Tab(text: 'CARTON'),
    Tab(text: 'MORE DETAILS'),
    Tab(text: 'QUALITY PARAMETERS'),
    Tab(text: 'ENCLOSURE'),
  ];


  @override
  void initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);
    developer.log("widget.inspectionModal ${jsonEncode(widget.inspectionModal)}");
    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });
    switch (_selectedIndex) {
      case 0:
        await (_poItemKey.currentState as dynamic)?.saveChanges();
        break;
      case 1:
        await (_workmanshipKey.currentState as dynamic)?.saveChanges();
        break;
      case 2:
        await (_cartonKey.currentState as dynamic)?.saveChanges();
        break;
      case 3:
        await (_moreDetailsKey.currentState as dynamic)?.saveChanges();
        break;
      case 4:
        await (_qualityParametersKey.currentState as dynamic)?.saveChanges();
        break;
      case 5:
        await (_enclosureKey.currentState as dynamic)?.saveChanges();
        break;
    }
    setState(() {
      _hasUnsavedChanges = false;
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully')),
    );
  }

  void _undoChanges() {
    switch (_selectedIndex) {
      case 0:
        (_poItemKey.currentState as dynamic)?.resetQuantities();
        break;
      case 1:
        (_workmanshipKey.currentState as dynamic)?.resetQuantities();
        break;
      case 2:
        (_cartonKey.currentState as dynamic)?.resetQuantities();
        break;
      case 3:
        (_moreDetailsKey.currentState as dynamic)?.resetQuantities();
        break;
      case 4:
        (_qualityParametersKey.currentState as dynamic)?.resetQuantities();
        break;
      case 5:
        (_enclosureKey.currentState as dynamic)?.resetQuantities();
        break;
    }
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: Text(widget.pRowId, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _undoChanges,
            child: const Text('UNDO', style: TextStyle(color: Colors.white)),
          ),
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
      body: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: list,
            controller: _controller,
            onTap: (index) {
              if (_hasUnsavedChanges) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Unsaved Changes'),
                    content: const Text('You have unsaved changes. Please save before navigating.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
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
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                PoItem(
                  key: _poItemKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }, inspectionModal: widget.inspectionModal!,
                ),
                PoWorkmanship(
                  key: _workmanshipKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  },inspectionModal: widget.inspectionModal, poItemDtl: widget.poItemDtl,
                ),
                Carton(
                  key: _cartonKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }, inspectionModal: widget.inspectionModal,
                ),
                MoreDetails(
                  key: _moreDetailsKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }, inspectionModal: widget.inspectionModal,
                ),
                QualityParameters(
                  key: _qualityParametersKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }, inspectionModal: widget.inspectionModal,
                ),
                Enclosure(
                  key: _enclosureKey,
                  pRowId: widget.pRowId,
                  onChanged: () {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }, inspectionModal: widget.inspectionModal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
