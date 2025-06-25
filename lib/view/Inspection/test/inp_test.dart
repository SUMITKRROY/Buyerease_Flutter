import 'package:flutter/material.dart';


import '../../../model/inspection_model.dart';
import '../../../services/inspection_list/InspectionListHandler.dart';
import '../../../utils/gen_utils.dart';
import '../../../utils/toast.dart';

class InspectionListScreen extends StatefulWidget {
  const InspectionListScreen({super.key});

  @override
  State<InspectionListScreen> createState() => _InspectionListScreenState();
}

class _InspectionListScreenState extends State<InspectionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<InspectionModal> _inspectionList = [];
  bool isDefaultOpenList = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  void _loadInspections({String? query}) async {
    setState(() => isLoading = true);
    try {
      final list = isDefaultOpenList
          ? await InspectionListHandler.getSyncedInspectionList("")
          : await InspectionListHandler.getSyncedInspectionList("");

      setState(() => _inspectionList = list);
    } catch (e) {
       showToast(  'Failed to load inspections',false);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _loadInspections();
    } else {
      _loadInspections(query: query);
    }
  }

  void _onToggleList(bool open) {
    setState(() => isDefaultOpenList = open);
    _loadInspections();
  }

  // void _onSyncSelected() {
  //   final selected = _inspectionList.where((item) => item.isCheckedToSync).toList();
  //
  //   if (selected.isNotEmpty) {
  //     // TODO: Call sync handler
  //   showToast( 'Syncing ${selected.length} inspections...',false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspections'),
        actions: [
          IconButton(icon: const Icon(Icons.sync), onPressed: (){}),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'open') _onToggleList(true);
              else if (value == 'closed') _onToggleList(false);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'open', child: Text('Open Inspections')),
              const PopupMenuItem(value: 'closed', child: Text('Closed Inspections')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search by DEL ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _inspectionList.isEmpty
                ? const Center(child: Text('No inspections found'))
                : ListView.builder(
              itemCount: _inspectionList.length,
              itemBuilder: (context, index) {
                return InspectionListItem(
                  modal: _inspectionList[index],
                  onChanged: (checked) {
                    setState(() {
                      _inspectionList[index].isCheckedToSync = checked;
                    });
                  },
                  onTap: () {
                    // Navigate to detail screen
                    Navigator.pushNamed(
                      context,
                      '/po_item_list',
                      arguments: _inspectionList[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class InspectionListItem extends StatelessWidget {
  final InspectionModal modal;
  final Function(bool) onChanged;
  final VoidCallback onTap;

  const InspectionListItem({
    super.key,
    required this.modal,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(""),
      trailing: Checkbox(
        value: modal.isCheckedToSync,
        onChanged: (value) => onChanged(value ?? false),
      ),
      onTap: onTap,
    );
  }
}
