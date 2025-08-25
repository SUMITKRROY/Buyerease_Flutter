import 'dart:math';

import 'package:buyerease/components/add_image_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theame_data.dart';
import '../../model/po_item_dtl_model.dart';

class ParameterDetailScreen extends StatefulWidget {  final String id;
  final String parameterName;
  final String? existingComment;
final POItemDtl poItemDtl;
  const ParameterDetailScreen({
    super.key,
    required this.parameterName,
    this.existingComment, required this.id, required this.poItemDtl
  });

  @override
  State<ParameterDetailScreen> createState() => _ParameterDetailScreenState();
}

class _ParameterDetailScreenState extends State<ParameterDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _commentController;
  bool _hasImage = false;
  String? _errorMessage;
  late POItemDtl poItemDtl;

  @override
  void initState() {
    super.initState();
    print('developer log parameterName ${widget.parameterName}');
    poItemDtl = widget.poItemDtl;
    _commentController = TextEditingController(text: widget.existingComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final comment = _commentController.text.trim();
    
    if (comment.isEmpty && !_hasImage) {
      setState(() {
        _errorMessage = 'Please add either a comment or an image';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    Navigator.pop(context, {
      'comment': comment,
      'hasPhoto': _hasImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Replace with your desired color
        ),
        backgroundColor: ColorsData.primaryColor,
        title: Text(widget.parameterName,style: TextStyle(color: Colors.white,fontSize: 18.sp),),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Add your comments here...',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsData.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade300),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    if (!_hasImage) {
                      return 'Please add either a comment or an image';
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddImageIcon(title: widget.parameterName, id: widget.id, pRowId: '', poItemDtl: poItemDtl,),
                  const SizedBox(width: 20),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 16,
                      color: _hasImage ? ColorsData.primaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
              if (_hasImage)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Photo added',
                    style: TextStyle(
                      color: ColorsData.primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndPop,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: ColorsData.primaryColor,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 