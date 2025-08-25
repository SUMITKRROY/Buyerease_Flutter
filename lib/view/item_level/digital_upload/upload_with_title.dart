import 'package:flutter/material.dart';
import '../../../components/add_image_icon.dart';
import '../../../model/po_item_dtl_model.dart';
import '../../../model/digitals_upload_model.dart';
import '../../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';

class DigitalUploadWithTitle extends StatefulWidget {
  final String id;
  final String pRowId;
  final POItemDtl poItemDtl;
  final VoidCallback? onImageAdded;

  const DigitalUploadWithTitle({
    super.key,
    required this.id,
    required this.pRowId,
    required this.poItemDtl,
    this.onImageAdded,
  });

  @override
  State<DigitalUploadWithTitle> createState() => _DigitalUploadWithTitleState();
}

class _DigitalUploadWithTitleState extends State<DigitalUploadWithTitle> {
  List<DigitalsUploadModel> _titles = [];
  DigitalsUploadModel? _selectedTitleModel;
  bool _loading = true;
  String? _error;
  String qrHdrID = '';
  String qrPOItemHdrID = '';

  final TextEditingController _otherTitleController = TextEditingController();
  bool _isOtherSelected = false;

  @override
  void initState() {
    super.initState();
    _init();
    _otherTitleController.addListener(() {
      if (_isOtherSelected) {
        setState(() {}); // rebuild UI to update title in AddImageIcon
      }
    });
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      qrHdrID = widget.poItemDtl.qrHdrID ?? '';
      qrPOItemHdrID = widget.poItemDtl.qrpoItemHdrID ?? '';

      final titles = await ItemInspectionDetailHandler().getImageTitle(qrHdrID, qrPOItemHdrID);

      setState(() {
        _titles = titles;
        _titles.add(DigitalsUploadModel(title: 'Other')); // Add "Other" option
        if (_titles.isNotEmpty) {
          _selectedTitleModel = _titles.first;
          _isOtherSelected = _selectedTitleModel?.title == 'Other';
        }
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load titles';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _otherTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String finalTitle = _isOtherSelected
        ? _otherTitleController.text.trim()
        : _selectedTitleModel?.title ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Digital'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Select Image Title',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<DigitalsUploadModel>(
              isExpanded: true,
              value: _selectedTitleModel,
              items: _titles.map((model) {
                return DropdownMenuItem<DigitalsUploadModel>(
                  value: model,
                  child: Text(model.title ?? '[No Title]'),
                );
              }).toList(),
              onChanged: (model) {
                setState(() {
                  _selectedTitleModel = model;
                  _isOtherSelected = model?.title == 'Other';
                });
              },
              hint: const Text('Select Title'),
            ),
            if (_isOtherSelected) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otherTitleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Custom Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_selectedTitleModel != null || _isOtherSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AddImageIcon(
                    title: finalTitle, // ✅ Now updated with real input
                    id: widget.id,
                    pRowId: '',
                    poItemDtl: widget.poItemDtl,
                    onImageAdded: widget.onImageAdded,
                    isCountShow: false,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Add Image for "$finalTitle"',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
