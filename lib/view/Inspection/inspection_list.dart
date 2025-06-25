import 'dart:developer';
import 'dart:developer' as developer;

import 'package:buyerease/main.dart';
import 'package:buyerease/model/status_modal.dart';
import 'package:buyerease/utils/app_constants.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:buyerease/utils/logout.dart';
import 'package:buyerease/view/Inspection/inspection_details.dart';
import 'package:buyerease/view/sync_inception/sync_status_adaptor.dart';
import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import '../../model/inspection_model.dart';
import '../../services/inspection_list/InspectionListHandler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/inspection_list/ItemInspectionDetailHandler.dart';
import '../details/detail_page1.dart';
import '../networks/endpoints.dart';
import '../post/post_api_call.dart';
import 'package:buyerease/config/theame_data.dart';

class InspectionList extends StatefulWidget {
  const InspectionList({super.key});

  @override
  State<InspectionList> createState() => _InspectionListState();
}

class _InspectionListState extends State<InspectionList> {
  bool isLoading = true;
  List<Map<String, dynamic>> inspectionData = [];
  Set<String> selectedItems = {};
  bool isOpen = true; // Track open/closed state
  Set<String> syncedItems = {}; // Track synced items
  String searchQuery = ''; // Add search query state
  List<InspectionModal> inspectionList = [];

  @override
  void initState() {
    super.initState();
    //loadData();
    getLocalList("");
  }

  Future<void> getLocalList(String searchStr) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<InspectionModal> localList = await InspectionListHandler.getInspectionList(searchStr);
      setState(() {
        inspectionList.clear();
        if (localList.isNotEmpty) {
          inspectionList.addAll(localList);
          print("Fetched inspections: ${inspectionList.length}");
          for (var item in localList) {
            print("pRowID: ${item.pRowID}, QRHdrID: ${item.qrHdrID}");
          }
        } else {
          Fluttertoast.showToast(msg: "Inspection did not find");
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching local list: $e");
      Fluttertoast.showToast(msg: "Failed to load inspections");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedItems.contains(id)) {
        selectedItems.remove(id);
      } else {
        selectedItems.add(id);
      }
    });
  }

  void selectAll() {
    setState(() {
      selectedItems = inspectionList
          .where((item) => !syncedItems.contains(item.pRowID))
          .map((item) => item.pRowID ?? "")
          .toSet();
    });
  }

  void unselectAll() {
    setState(() {
      selectedItems.clear();
    });
  }

  void toggleOpenClosed() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  List<StatusModel> _convertToStatusModels(List<InspectionModal> inspections) {
    return inspections.where((item) => selectedItems.contains(item.pRowID)).map((item) {
      return StatusModel(
        tableName: "Inspection",
        title: "Syncing inspection ${item.pRowID}",
        status: SyncStatus.pending
      );
    }).toList();
  }

  Future<void> syncSelectedItems() async {
    if (selectedItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sync'),
          content: Text('Are you sure? Do you want to sync ${selectedItems.length} inspection${selectedItems.length > 1 ? 's' : ''}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the confirmation dialog
                final statusModels = _convertToStatusModels(inspectionList);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SyncStatusPage( )
                ));
                // handleSubmitToSync(context);
                setState(() {
                  isLoading = true;
                });
                
                // Simulate sync process
                await Future.delayed(const Duration(seconds: 2));
                
                setState(() {
                  syncedItems.addAll(selectedItems);
                  selectedItems.clear();
                  isLoading = false;
                });
              },
              child: const Text('Sync', style: TextStyle(color: ColorsData.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Add search function
  List<InspectionModal> getFilteredItems() {
    if (searchQuery.isEmpty) {
      return inspectionList.where((item) {
        final isSynced = syncedItems.contains(item.pRowID);
        return isOpen ? !isSynced : isSynced;
      }).toList();
    }

    final query = searchQuery.trim();
    
    return inspectionList.where((item) {
      final isSynced = syncedItems.contains(item.pRowID);
      final matchesState = isOpen ? !isSynced : isSynced;
      
      if (!matchesState) return false;

      // Convert all searchable fields to lowercase strings and handle null values
      final searchableFields = [
        item.pRowID?.toString().toLowerCase() ?? '',
        item.customer?.toString().toLowerCase() ?? '',
        item.poListed?.toString().toLowerCase() ?? '',
        item.itemListId?.toString().toLowerCase() ?? '',
        item.vendor?.toString().toLowerCase() ?? '',
        item.vendorContact?.toString().toLowerCase() ?? '',
        item.vendorAddress?.toString().toLowerCase() ?? '',
        item.qr?.toString().toLowerCase() ?? '',
        item.inspector?.toString().toLowerCase() ?? '',
        item.status?.toString().toLowerCase() ?? '',
      ];

      // Check if any field contains the search query
      return searchableFields.any((field) => field.contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: ColorsData.primaryColor,
        title: const Text('Inspection', style: TextStyle(color: Colors.white)),
        actions: [
          if (selectedItems.isNotEmpty) ...[
            Text(
              '${selectedItems.length} selected',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(width: 16),
          ],
          TextButton(
            onPressed: selectedItems.isEmpty ? null : syncSelectedItems,
            // onPressed: selectedItems.isEmpty ? null : syncSelectedItems,
            child: const Text('SYNC', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: selectedItems.isEmpty ? null : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure? Do you want to delete inspection?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            inspectionData.removeWhere(
                              (item) => selectedItems.contains(item['pRowID'])
                            );
                            selectedItems.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'REMOVE',
              style: TextStyle(
                color: selectedItems.isEmpty ? Colors.white60 : Colors.white
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'check_all':
                  selectAll();
                  break;
                case 'uncheck_all':
                  unselectAll();
                  break;
                case 'toggle_open':
                  toggleOpenClosed();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'check_all',
                child: Row(
                  children: [
                    Icon(Icons.check_box, color: ColorsData.primaryColor),
                    SizedBox(width: 8),
                    Text('Check All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'uncheck_all',
                child: Row(
                  children: [
                    Icon(Icons.check_box_outline_blank, color: ColorsData.primaryColor),
                    SizedBox(width: 8),
                    Text('Uncheck All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_open',
                child: Row(
                  children: [
                    Icon(
                      isOpen ? Icons.lock_open : Icons.lock_outline,
                      color: ColorsData.primaryColor
                    ),
                    const SizedBox(width: 8),
                    Text(isOpen ? 'Close' : 'Open'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: Loading()) 
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search by ID or Customer ID...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                ),
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty 
                ? Center(
                    child: Text(
                      searchQuery.isEmpty
                        ? (isOpen ? 'No Open Inspections' : 'No Closed Inspections')
                        : 'No results found',
                      style: const TextStyle(
                        fontSize: 16,
                        color: ColorsData.darkGrayColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = selectedItems.contains(item.pRowID);
                      
                      return GestureDetector(
                        onTap: () {
                          developer.log("item qrHdrID ${item.qrHdrID}");
                          if (selectedItems.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InspectionDetailScreen(data: {
                                  'pRowID': item.pRowID,
                                  'inspectionDt': item.inspectionDt,
                                  'activity': item.activity,
                                  'customer': item.customer,
                                  'poListed': item.poListed,
                                  'itemListId': item.itemListId,
                                  'vendor': item.vendor,
                                  'vendorContact': item.vendorContact,
                                  'vendorAddress': item.vendorAddress,
                                  'qr': item.qr,
                                  'inspector': item.inspector,
                                  'status': item.status,
                                  'qrHdrID': item.qrHdrID,
                                })
                              )
                            );
                          } else {
                            toggleSelection(item.pRowID ?? "");
                          }
                        },
                        onLongPress: () {
                          toggleSelection(item.pRowID ?? "");
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? ColorsData.primaryColor : Colors.grey.shade300,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            color: isSelected ? ColorsData.primaryColor.withOpacity(0.05) : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ${item.inspectionDt}',
                                      style: const TextStyle(
                                        color: ColorsData.textColor,
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (_) => toggleSelection(item.pRowID ?? ""),
                                        activeColor: ColorsData.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.activity ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsData.textColor,
                                  ),
                                ),
                                const Divider(color: ColorsData.darkGrayColor),
                                _buildInfoRow('ID', item.pRowID ?? ""),
                                _buildInfoRow('Customer', item.customer ?? ""),
                                _buildInfoRow('PO No', item.poListed ?? ""),
                                _buildInfoRow('Style No.', item.itemListId ?? ""),
                                _buildInfoRow('Vendor', item.vendor ?? ""),
                                _buildInfoRow('Vendor Contact', item.vendorContact ?? ""),
                                _buildInfoRow('Vendor Address', item.vendorAddress ?? ""),
                                _buildInfoRow('QR', item.qr ?? ""),
                                _buildInfoRow('Inspector', item.inspector ?? ""),
                                _buildInfoRow('Status', item.status ?? ""),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value ?? ''),
          ),
        ],
      ),
    );
  }
  void handleSubmitToSync(BuildContext context) async {
    if (inspectionList != null && inspectionList.isNotEmpty) {
      List<String> idsList = [];

      for (var item in inspectionList) {
        if (item.isCheckedToSync == true) {
          idsList.add(item.pRowID ?? "");
          if (!isOpen) {
            await ItemInspectionDetailHandler.updateImageToMakeAgainNotSync(item.qrHdrID ?? "");
          }
        }
      }

      if (idsList.isNotEmpty) {
        bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: Text('Are you sure? Do you want to sync ${idsList.length} inspection(s)?'),
              actions: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                ),
              ],
            );
          },
        );


      }
    }
  }

}
