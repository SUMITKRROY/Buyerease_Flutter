import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theame_data.dart';
import '../../model/inspection_model.dart';
import '../../model/intimation_details_model.dart';
import '../../model/IntimationModal.dart';
import '../../services/ItemInspectionDetail/ItemInspectionDetailHandler.dart';
import '../../components/ResponsiveCustomTable.dart';

class IntimationDetailsScreen extends StatefulWidget {
  final String pRowId;
  final InspectionModal inspectionModal;

  const IntimationDetailsScreen({Key? key,   required this.pRowId, required this.inspectionModal}) : super(key: key);

  @override
  _IntimationDetailsScreenState createState() => _IntimationDetailsScreenState();
}

class _IntimationDetailsScreenState extends State<IntimationDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // Actual data from database
  List<IntimationModal> intimationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load data based on pRowId and inspectionModal
    if (widget.pRowId != null) {
      print("Loading intimation data for pRowId: ${widget.pRowId}");
      _loadIntimationData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadIntimationData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final handler = ItemInspectionDetailHandler();
      final qrHdrID = widget.pRowId ?? '';
      // final qrHdrID = widget.inspectionModal.qrHdrID ?? '';
      final list = await handler.getIntimationList(qrHdrID);
      print("Error loading intimation qrHdrID: $qrHdrID");
      setState(() {
        intimationList = list;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading intimation data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addIntimation() async {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      try {
        final handler = ItemInspectionDetailHandler();
        
        final newIntimation = IntimationModal(
          qrHdrId: widget.pRowId ,
          name: _nameController.text,
          emailId: _emailController.text,
          isLink: 0,
          isReport: 0,
          isHtmlLink: 0,
          isRcvApplicable: 0,
          isSelected: 0,
        );
        
        print('🔍 Attempting to add intimation with data:');
        print('  - qrHdrId: ${newIntimation.qrHdrId}');
        print('  - name: ${newIntimation.name}');
        print('  - emailId: ${newIntimation.emailId}');
        print('  - pRowId: ${newIntimation.pRowId}');
        
        // Save to database immediately
        final result = await handler.updateOrInsertQRPOIntimationDetails(newIntimation);
        
        print('📊 Insert result: $result');
        
        if (result > 0) {
          // Reload the list to get the updated data from database
          await _loadIntimationData();
          
          // Clear the text fields
          _nameController.clear();
          _emailController.clear();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Intimation added successfully!')),
          );
        } else {
          print('❌ Insert failed with result: $result');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add intimation - Error code: $result')),
          );
        }
      } catch (e) {
        print("❌ Error adding intimation: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding intimation: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill both Name and Email fields')),
      );
    }
  }

  Future<void> _saveChanges() async {
    try {
      final handler = ItemInspectionDetailHandler();
      
      // Save all intimation items (for any remaining changes to existing items)
      for (var intimation in intimationList) {
        await handler.updateOrInsertQRPOIntimationDetails(intimation);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All changes saved successfully!')),
      );
    } catch (e) {
      print("Error saving intimation data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    }
  }

  List<String> get _headers => [
    'Select',
    'Name',
    'Email',
    'Link',
    'Report',
    'Html Link',
    'Receive Applicable',
  ];

  List<List<dynamic>> get _rows {
    return intimationList.map((item) => [
      _buildCheckbox(item.isSelected == 1, (value) {
        setState(() {
          item.isSelected = value == true ? 1 : 0;
        });
      }),
      item.name ?? '',
      item.emailId ?? '',
      _buildCheckbox(item.isLink == 1, (value) {
        setState(() {
          item.isLink = value == true ? 1 : 0;
        });
      }, activeColor: Colors.green),
      _buildCheckbox(item.isReport == 1, (value) {
        setState(() {
          item.isReport = value == true ? 1 : 0;
        });
      }, activeColor: Colors.green),
      _buildCheckbox(item.isHtmlLink == 1, (value) {
        setState(() {
          item.isHtmlLink = value == true ? 1 : 0;
        });
      }, activeColor: Colors.green),
      _buildCheckbox(item.isRcvApplicable == 1, (value) {
        setState(() {
          item.isRcvApplicable = value == true ? 1 : 0;
        });
      }, activeColor: Colors.green),
    ]).toList();
  }

  Widget _buildCheckbox(bool value, Function(bool?) onChanged, {Color? activeColor}) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsData.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Intimation Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsData.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Intimation Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'DONE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Form Section
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton(
                    onPressed: _addIntimation,
                    child: Text(
                      'ADD',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Divider(height: 1, color: Colors.grey[300]),
          
          // Table Section
          Expanded(
            child: intimationList.isEmpty
                ? Center(child: Text('No intimation data found'))
                : ResponsiveCustomTable(
                    headers: _headers,
                    rows: _rows,
                    showTotalRow: false,
                  ),
          ),
        ],
      ),
    );
  }
} 