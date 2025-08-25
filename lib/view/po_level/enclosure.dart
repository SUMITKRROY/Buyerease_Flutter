import 'dart:io';
import 'package:buyerease/services/inspection_list/InspectionListHandler.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

import '../../model/enclosure_modal.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../utils/app_constants.dart';

class Enclosure extends StatefulWidget {
  final dynamic inspectionModal;
  final String pRowId;
  final VoidCallback? onChanged;

  const Enclosure({
    required this.inspectionModal,
    required this.pRowId,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<Enclosure> createState() => _EnclosureState();
}

class _EnclosureState extends State<Enclosure> {
  final List<EnclosureModal> enclosureList = [];
  final TextEditingController nameController = TextEditingController();
  String selectedFilePath = '';
  String? fileExtension;
  String? fileName;
  String selectedType = 'General';
  bool sendAsMail = false;
  bool isLoading = true;

  List<String> enclosureTypes = ['General', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadEnclosures();
  }

  Future<void> _loadEnclosures() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final enclosures = await ItemInspectionDetailHandler.getQREnclosureList(widget.pRowId);
      
      setState(() {
        enclosureList.clear();
        enclosureList.addAll(enclosures);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading enclosures: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButton<String>(
            isExpanded: true,
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value!;
              });
            },
            items: enclosureTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'File Name'),
          ),
          Row(
            children: [
              Checkbox(
                value: sendAsMail,
                onChanged: (val) => setState(() => sendAsMail = val!),
              ),
              const Text("Send as mail")
            ],
          ),
          Text(selectedFilePath.isNotEmpty ? fileName ?? '' : 'No file selected'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text("Select File"),
              ),
              ElevatedButton(
                onPressed: _addEnclosure,
                child: const Text("Add"),
              ),
            ],
          ),
          const Divider(thickness: 1.5,color: Colors.grey,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                    Text("Title"),

                Text("Action"),

              ],
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: enclosureList.isEmpty
                  ? const Center(
                      child: Text(
                        'No enclosures found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: enclosureList.length,
                      itemBuilder: (_, index) {
                        final item = enclosureList[index];
                        return Card(
                         // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: ListTile(
                            // leading: Icon(
                            //   _getFileIcon(item.fileExt),
                            //   color: Colors.blue,
                            //   size: 32,
                            // ),
                            title: Text(
                              item.title ?? item.fileName ?? 'Untitled',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            // subtitle: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text('Type: ${_getEnclosureTypeText(item.enclType)}'),
                            //     if (item.fileExt != null)
                            //       Text('Extension: ${item.fileExt}'),
                            //     if (item.numVal1 == 1)
                            //       const Text(
                            //         'Send as mail',
                            //         style: TextStyle(
                            //           color: Colors.green,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //   ],
                            // ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEnclosure(index),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                    ),
            )
        ],
      ),
    );
  }

  IconData _getFileIcon(String? fileExt) {
    if (fileExt == null) return Icons.insert_drive_file;
    
    final ext = fileExt.toLowerCase();
    if (ext.contains('pdf')) return Icons.picture_as_pdf;
    if (ext.contains('doc') || ext.contains('docx')) return Icons.description;
    if (ext.contains('xls') || ext.contains('xlsx')) return Icons.table_chart;
    if (ext.contains('jpg') || ext.contains('jpeg') || ext.contains('png')) return Icons.image;
    if (ext.contains('txt')) return Icons.text_snippet;
    
    return Icons.insert_drive_file;
  }

  String _getEnclosureTypeText(String? enclType) {
    switch (enclType) {
      case '05':
        return 'General';
      case '99':
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        selectedFilePath = file.path!;
        fileName = file.name;
        fileExtension = lookupMimeType(file.path!)?.split('/').last;
        if (nameController.text.isEmpty) {
          nameController.text = fileName!;
        }
      });
    }
  }

  Future<void> _addEnclosure() async {
    if (selectedFilePath.isEmpty || fileExtension == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file.")),
      );
      return;
    }

    final isImage = fileExtension == 'jpg' || fileExtension == 'png';
    final displayName = nameController.text.trim().isEmpty ? fileName : nameController.text;
    String pRowId = await ItemInspectionDetailHandler().generatePK("QREnclosure");

    final modal = EnclosureModal(
      imageName: displayName,
      title: displayName,
      fileName: displayName,
      fileExt: fileExtension,
      fileContent: selectedFilePath,
      enclType: selectedType == 'General' ? '05' : '99',
      numVal1: sendAsMail ? 1 : 0,
      pRowId: pRowId,
      contextId: widget.pRowId,
    );

    try {
      await ItemInspectionDetailHandler().updateEnclosure(widget.inspectionModal, modal);
      
      setState(() {
        enclosureList.add(modal);
        selectedFilePath = '';
        fileExtension = null;
        fileName = null;
        nameController.clear();
        selectedType = 'General';
        sendAsMail = false;
      });

      widget.onChanged?.call();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enclosure added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding enclosure: $e")),
      );
    }
  }

  Future<void> _deleteEnclosure(int index) async {
    final item = enclosureList[index];
    
    try {
      if (item.pRowId != null) {
        final success = await ItemInspectionDetailHandler.deleteEnclosure(item.pRowId!);
        if (success) {
          setState(() {
            enclosureList.removeAt(index);
          });
          widget.onChanged?.call();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Enclosure deleted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to delete enclosure")),
          );
        }
      } else {
        setState(() {
          enclosureList.removeAt(index);
        });
        widget.onChanged?.call();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting enclosure: $e")),
      );
    }
  }

  Future<void> saveChanges() async {

    _addEnclosure();
    // TODO: Save it to DB or send to server...

    widget.onChanged?.call();
    setState(() {});
  }
}
