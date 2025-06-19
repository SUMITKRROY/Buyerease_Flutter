// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../components/custom_table.dart';
// import '../../components/remarks.dart';
// import '../../config/theame_data.dart';
// import '../../database/table/qr_po_item_dtl_table.dart';
// import '../../model/po_item_dtl_model.dart';
// import '../over_all_result/add_workmanship.dart';
//
// class WorkManShip extends StatefulWidget {
//   final String id;
//   const WorkManShip({super.key, required this.id});
//
//   @override
//   State<WorkManShip> createState() => _WorkManShipState();
// }
//
// class _WorkManShipState extends State<WorkManShip> {
//   String? _dropDownValue;
//   String? remark;
//   List<POItemDtl> poItems = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     try {
//       final qrPoItemDtlTable = QRPOItemDtlTable();
//       final items = await qrPoItemDtlTable.getByCustomerItemRefAndEnabled(widget.id);
//       setState(() {
//         poItems = items;
//         isLoading = false;
//         if (items.isNotEmpty) {
//           _dropDownValue = items.first.workmanshipInspectionResult ?? 'Awaiting';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error loading data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (poItems.isEmpty) {
//       return const Center(child: Text('No data available'));
//     }
//
//     final item = poItems.first;
//
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(3),
//                 border: Border.all(color: Colors.black),
//                 color: Colors.white,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Over All Result'),
//                   Container(
//                     height: 35,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(3),
//                       border: Border.all(color: Colors.black, width: 1),
//                       color: Colors.white,
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton(
//                         value: _dropDownValue,
//                         hint: const Text('Select'),
//                         isExpanded: true,
//                         iconSize: 30.0,
//                         style: const TextStyle(color: Colors.blue),
//                         items: ['Pass', 'Failed', 'Awaiting'].map(
//                           (val) {
//                             return DropdownMenuItem<String>(
//                               value: val,
//                               child: Text(val),
//                             );
//                           },
//                         ).toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             _dropDownValue = val;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Container(
//                       width: 24,
//                       height: 24,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black, width: 1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(Icons.add),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const AddWorkManShip()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // CustomTable(
//                   //   rowData: [
//                   //     '',
//                   //     'Critical',
//                   //     'Major',
//                   //     'Minor',
//                   //   ].map((data) => Text(
//                   //         data,
//                   //         style: TextStyle(
//                   //           fontWeight: FontWeight.bold,
//                   //           fontSize: 12.sp,
//                   //         ),
//                   //       )).toList(),
//                   //   isHeader: true,
//                   //   isFirstCellClickable: false,
//                   // ),
//                   CustomTable(
//                     rowData: [
//                       'Total',
//                       item.criticalDefect?.toString() ?? '0',
//                       item.majorDefect?.toString() ?? '0',
//                       item.minorDefect?.toString() ?? '0',
//                     ].map((data) => Text(
//                           data,
//                           style: TextStyle(fontSize: 10.sp),
//                         )).toList(),
//                     isFirstCellClickable: false,
//                   ),
//                   CustomTable(
//                     rowData: [
//                       'Permissible Defect',
//                       item.criticalDefectsAllowed?.toString() ?? '0',
//                       item.majorDefectsAllowed?.toString() ?? '0',
//                       item.minorDefectsAllowed?.toString() ?? '0',
//                     ].map((data) => Text(
//                           data,
//                           style: TextStyle(fontSize: 10.sp),
//                         )).toList(),
//                     isFirstCellClickable: false,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Remark
//             Remarks()
//           ],
//         ),
//       ),
//     );
//   }
// }
