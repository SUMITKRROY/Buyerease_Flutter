import 'package:flutter/material.dart';
import 'package:buyerease/view/po/po_item.dart';
import 'package:buyerease/view/po/quality_parameters.dart';
import 'package:buyerease/view/po/workmanship/po_workmanship.dart';
import '../../config/theame_data.dart';
import 'carton.dart';
import 'enclosure.dart';
import 'more_details.dart';

class PoPage extends StatefulWidget {
  final String pRowId;
  const PoPage({super.key, required this.pRowId});

  @override
  State<PoPage> createState() => _PoPageState();
}

class _PoPageState extends State<PoPage> with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  final GlobalKey<State<StatefulWidget>> _poItemKey = GlobalKey<State<StatefulWidget>>();


  List<Widget> list = const [
    Tab(text: 'PO/ITEM'),
    Tab(text: 'WorkManShip'),
    Tab(text: 'Carton'),
    Tab(text: 'More Details'),
    Tab(text: 'Quality Parameters'),
    Tab(text: 'Enclosure'),
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });
    await (_poItemKey.currentState as dynamic)?.saveChanges();
    setState(() {
      _hasUnsavedChanges = false;
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully')),
    );
  }

  void _undoChanges() {
    (_poItemKey.currentState as dynamic)?.resetQuantities();
    setState(() {
      _hasUnsavedChanges = true;
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
                  },
                ),
                PoWorkmanship(pRowId: widget.pRowId),
                Carton(pRowId: widget.pRowId),
                MoreDetails(pRowId: widget.pRowId),
                QualityParameters(pRowId: widget.pRowId),
                Enclosure(pRowId: widget.pRowId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
