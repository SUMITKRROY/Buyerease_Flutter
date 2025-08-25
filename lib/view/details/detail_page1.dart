// import 'package:buyerease/database/database_helper.dart';
//
// import 'package:buyerease/utils/loading.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../over_all_result/item_level_tab.dart';
// import '../po/po_level_tab.dart';
//
// class DetailPageOne extends StatefulWidget {
//   const DetailPageOne({super.key, required this.id});
//
//   final String id;
//
//   @override
//   State<DetailPageOne> createState() => _DetailPageOneState();
// }
//
// class _DetailPageOneState extends State<DetailPageOne> {
//   bool loading = true;
//   bool showData = true;
//   bool showDataTwo = true;
//   bool isCheckedReport = false;
//   bool isCheckedMaterial = false;
//
//   // Inspection Level
//   List<InspectionLevel>? _inspectionLevels;
//   InspectionLevel? _selectedInspectionLevel;
//   String? inspectionLevelDescrValue;
//
//   // Quality Level both Major & Minor
//   List<QualityLevel>? _qualityLevels;
//   QualityLevel? _selectedQualityMajorLevel;
//   QualityLevel? _selectedQualityMinorLevel;
//
//   String? qualityMajorLevelDescrValue;
//   String? qualityMinorLevelDescrValue;
//
//   // Status
//   List<Status>? _status;
//   Status? _selectedStatus;
//   int? statusDescrValue;
//
//   // Time
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TimeOfDay selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
//   TimeOfDay selectedCompleteTime = const TimeOfDay(hour: 00, minute: 00);
//   String arrivalTime = "";
//   String startTime = "";
//   String completeTime = "";
//
//   FocusNode myFocusNode = FocusNode();
//   String vendorPresentative = '';
//
//   List data = [];
//   List dataInspectionLevel = [];
//   List dataQualityLevel = [];
//   List dataStatus = [];
//
//   _convertTime() async {
//     final now = DateTime.now();
//
//     final dateTimeIn = DateTime(now.year, now.month, now.day, selectedTime.hour,
//         selectedTime.minute, 0);
//     String formattedTimeIn = DateFormat('HH:mm').format(dateTimeIn);
//
//     setState(() {
//       arrivalTime = formattedTimeIn;
//     });
//
//     final dateTimeOut = DateTime(now.year, now.month, now.day,
//         selectedStartTime.hour, selectedStartTime.minute, 0);
//
//     setState(() {
//       startTime = DateFormat('HH:mm').format(dateTimeOut);
//     });
//
//     final dateTimePlanIn = DateTime(now.year, now.month, now.day,
//         selectedCompleteTime.hour, selectedCompleteTime.minute, 0);
//
//     setState(() {
//       completeTime = DateFormat('HH:mm').format(dateTimePlanIn);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//    // getData();
//   }
//
//   // Future<void> getData() async {
//   //   await getTableDataRow();
//   //   await syncDataInspectionLevel();
//   //   await syncDataLevel();
//   //   await syncDataStatus();
//   // }
//
//   // Get information of PO
//   // Future<void> getTableDataRow() async {
//   //   data = await SQLHelper.getTableDataRow(16, widget.id);
//   //   inspectionLevelDescrValue = data[0]['InspectionLevelDescr'];
//   //   qualityMajorLevelDescrValue = data[0]['QLMajorDescr'];
//   //   qualityMinorLevelDescrValue = data[0]['QLMinorDescr'];
//   //   statusDescrValue = data[0]['Status'];
//   //   setState(() {});
//   // }
//   //
//   // // get Data of Inspection,Quality & status
//   // Future<void> syncDataInspectionLevel() async {
//   //   dataInspectionLevel = await SQLHelper.getTableData(8);
//   //   _inspectionLevels = _parseData(dataInspectionLevel);
//   //   _selectedInspectionLevel = _inspectionLevels!.firstWhere(
//   //     (level) => level.inspAbbrv == inspectionLevelDescrValue,
//   //   );
//   //   setState(() {});
//   // }
//   //
//   // Future<void> syncDataLevel() async {
//   //   dataQualityLevel = await SQLHelper.getTableData(6);
//   //   _qualityLevels = _parseDataQuality(dataQualityLevel);
//   //   _selectedQualityMajorLevel = _qualityLevels!.firstWhere(
//   //     (level) => level.qualityLevel == qualityMajorLevelDescrValue,
//   //   );
//   //   _selectedQualityMinorLevel = _qualityLevels!.firstWhere(
//   //     (level) => level.qualityLevel == qualityMinorLevelDescrValue,
//   //   );
//   //   setState(() {});
//   // }
//   //
//   // Future<void> syncDataStatus() async {
//   //   List<Map<String, dynamic>> getStatus = await SQLHelper.getTableData(5);
//   //   dataStatus =
//   //       getStatus.where((item) => item['MasterName'] == 'Status').toList();
//   //   _status = _parseDataStatus(dataStatus);
//   //   _selectedStatus = _status!.firstWhere(
//   //     (level) => level.mainID == statusDescrValue,
//   //   );
//   //   loading = false;
//   //   setState(() {});
//   // }
//
//   // Model Manager
//   List<InspectionLevel> _parseData(List<dynamic> data) {
//     return data.map((item) {
//       return InspectionLevel(
//         id: item['id'],
//         pRowID: item['pRowID'],
//         locID: item['LocID'],
//         inspDescr: item['InspDescr'],
//         inspAbbrv: item['InspAbbrv'],
//         recDirty: item['recDirty'],
//         recEnable: item['recEnable'],
//         recUser: item['recUser'],
//         recAddDt: item['recAddDt'],
//         recDt: item['recDt'],
//         ediDt: item['ediDt'],
//         isDefault: item['IsDefault'],
//         createdAt: item['createdAt'],
//       );
//     }).toList();
//   }
//
//   List<QualityLevel> _parseDataQuality(List<dynamic> data) {
//     return data.map((item) {
//       return QualityLevel(
//         id: item['id'],
//         pRowID: item['pRowID'],
//         locID: item['LocID'],
//         qualityLevel: item['QualityLevel'],
//         recDirty: item['recDirty'],
//         recEnable: item['recEnable'],
//         recUser: item['recUser'],
//         recAddDt: item['recAddDt'],
//         recDt: item['recDt'],
//         ediDt: item['ediDt'],
//       );
//     }).toList();
//   }
//
//   List<Status> _parseDataStatus(List<dynamic> data) {
//     return data.map((item) {
//       return Status(
//         id: item['id'],
//         genID: item['GenID'],
//         masterName: item['MasterName'],
//         mainID: item['MainID'],
//         mainDescr: item['MainDescr'],
//         subID: item['SubID'],
//         subDescr: item['SubDescr'],
//         numVal1: item['numVal1'],
//         numVal2: item['numVal2'],
//         form: item['Form'],
//         addonInfo: item['AddonInfo'],
//         moreInfo: item['MoreInfo'],
//         priviledge: item['Priviledge'],
//         a: item['a'],
//         moduleAccess: item['ModuleAccess'],
//         moduleID: item['ModuleID'],
//         createdAt: item['createdAt'],
//       );
//     }).toList();
//   }
//
//   // Save Data to SQL
//   Future<void> saveDataSql() async {
//     debugPrint('inspectionLevelDescrValue $inspectionLevelDescrValue');
//     dynamic updatedData = {
//       'InspectionLevelDescr': inspectionLevelDescrValue,
//       'QLMajorDescr': qualityMajorLevelDescrValue,
//       'QLMinorDescr': qualityMinorLevelDescrValue,
//       'Status': statusDescrValue,
//       'ArrivalTime': arrivalTime,
//       'InspStartTime': startTime,
//       'CompleteTime': completeTime,
//     };
//     // debugPrint('updated $updatedData');
//    // dynamic updatedResult = await SQLHelper.updateItem(updatedData, widget.id);
//     //debugPrint('update0 $updatedResult');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(widget.id, style: const TextStyle(color: Colors.white)),
//             GestureDetector(
//               child: const Text('Save', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 saveDataSql();
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: loading == true
//             ? Center(child: Loading())
//             : Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 child: Column(
//                   children: [
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 35,
//                             // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             width: MediaQuery.of(context).size.width * 0.9,
//                             child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(data[0]['InspectionDt'],
//                                       style: const TextStyle(fontSize: 18)),
//                                   IconButton(
//                                       icon: Icon(
//                                           showData == true
//                                               ? Icons.keyboard_arrow_up_outlined
//                                               : Icons.keyboard_arrow_down,
//                                           size: 30),
//                                       onPressed: () {
//                                         setState(() {
//                                           if (showData == true) {
//                                             showData = false;
//                                           } else {
//                                             showData = true;
//                                           }
//                                         });
//                                       })
//                                 ])),
//                         showData == true
//                             ? Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(2),
//                                     border: Border.all(
//                                         color: Colors.black, width: 0.5)),
//                                 // margin: const EdgeInsets.symmetric(horizontal: 5,vertical: ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 5),
//                                 width: MediaQuery.of(context).size.width * 0.9,
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.3,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Customer')),
//                                         Expanded(
//                                             child: Text(data[0]['Customer'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Vender')),
//                                         Expanded(
//                                             child: Text(data[0]['Vendor'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Inspector')),
//                                         Expanded(
//                                             child: Text(data[0]['Inspector'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Activity')),
//                                         Expanded(
//                                             child: Text(data[0]['Activity'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Location')),
//                                         Expanded(
//                                             child: Text(
//                                                 data[0]['FactoryAddress'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.3,
//                                             child: const Text('Vendor')),
//                                         Expanded(
//                                             child: Text(data[0]['Factory'],
//                                                 style: const TextStyle(
//                                                     fontSize: 15)))
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: MediaQuery.of(context).size.width,
//                                       child: TextFormField(
//                                         maxLines: 2,
//                                         minLines: 1,
//                                         focusNode: myFocusNode,
//                                         onChanged: (value) =>
//                                             vendorPresentative = value,
//                                         initialValue: vendorPresentative,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Enter Remarks';
//                                           }
//                                           return null;
//                                         },
//                                         style: const TextStyle(fontSize: 12),
//                                         decoration: InputDecoration(
//                                           isDense: true, // important line
//                                           contentPadding:
//                                               const EdgeInsets.all(10),
//                                           enabledBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black,
//                                                       width: 1.0)),
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black,
//                                                       width: 1.0)),
//                                           border: InputBorder.none,
//                                           label: const Text(
//                                               'Vendor Representative Name'),
//                                           labelStyle: TextStyle(
//                                               color: myFocusNode.hasFocus
//                                                   ? Colors.blue
//                                                   : Colors.black),
//                                           hintText:
//                                               "Vendor Representative Name",
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10),
//                                   ],
//                                 ))
//                             : Container(),
//                         // const SizedBox(height: 10),
//                         SizedBox(
//                             height: 35,
//                             // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             width: MediaQuery.of(context).size.width * 0.9,
//                             child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text('Inspection Detail',
//                                       style: TextStyle(fontSize: 18)),
//                                   IconButton(
//                                       icon: Icon(
//                                           showDataTwo == true
//                                               ? Icons.keyboard_arrow_up_outlined
//                                               : Icons.keyboard_arrow_down,
//                                           size: 30),
//                                       onPressed: () {
//                                         setState(() {
//                                           if (showDataTwo == true) {
//                                             showDataTwo = false;
//                                           } else {
//                                             showDataTwo = true;
//                                           }
//                                         });
//                                       })
//                                 ])),
//                         showDataTwo == true
//                             ? Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         children: [
//                                           SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               child: const Text(
//                                                   'Inspection Level')),
//                                           const SizedBox(height: 2),
//                                           Container(
//                                               height: 35,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 border: Border.all(
//                                                     color: Colors.black,
//                                                     width: 1),
//                                                 color: Colors.white,
//                                               ),
//                                               child:
//                                                   DropdownButtonHideUnderline(
//                                                 child: DropdownButton<
//                                                     InspectionLevel>(
//                                                   value:
//                                                       _selectedInspectionLevel,
//                                                   onChanged: (InspectionLevel?
//                                                       newValue) {
//                                                     setState(() {
//                                                       _selectedInspectionLevel =
//                                                           newValue!;
//                                                       inspectionLevelDescrValue =
//                                                           newValue.inspAbbrv;
//                                                     });
//                                                   },
//                                                   items: _inspectionLevels?.map(
//                                                       (InspectionLevel level) {
//                                                     return DropdownMenuItem<
//                                                         InspectionLevel>(
//                                                       value: level,
//                                                       child:
//                                                           Text(level.inspAbbrv),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               )),
//                                         ],
//                                       ),
//                                       Column(
//                                         children: [
//                                           SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               child: const Text(
//                                                   'Quality Level major')),
//                                           const SizedBox(height: 2),
//                                           Container(
//                                               height: 35,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 border: Border.all(
//                                                     color: Colors.black,
//                                                     width: 1),
//                                                 color: Colors.white,
//                                               ),
//                                               child:
//                                                   DropdownButtonHideUnderline(
//                                                 child: DropdownButton<
//                                                     QualityLevel>(
//                                                   value:
//                                                       _selectedQualityMajorLevel,
//                                                   onChanged:
//                                                       (QualityLevel? newValue) {
//                                                     setState(() {
//                                                       _selectedQualityMajorLevel =
//                                                           newValue!;
//                                                       qualityMajorLevelDescrValue =
//                                                           newValue.qualityLevel;
//                                                     });
//                                                   },
//                                                   items: _qualityLevels?.map(
//                                                       (QualityLevel level) {
//                                                     return DropdownMenuItem<
//                                                         QualityLevel>(
//                                                       value: level,
//                                                       child: Text(
//                                                           level.qualityLevel),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               )),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         children: [
//                                           SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               child: const Text(
//                                                   'Quality Level Minor')),
//                                           const SizedBox(height: 2),
//                                           Container(
//                                               height: 35,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 border: Border.all(
//                                                     color: Colors.black,
//                                                     width: 1),
//                                                 color: Colors.white,
//                                               ),
//                                               child:
//                                                   DropdownButtonHideUnderline(
//                                                 child: DropdownButton<
//                                                     QualityLevel>(
//                                                   value:
//                                                       _selectedQualityMinorLevel,
//                                                   onChanged:
//                                                       (QualityLevel? newValue) {
//                                                     setState(() {
//                                                       _selectedQualityMinorLevel =
//                                                           newValue!;
//                                                       qualityMinorLevelDescrValue =
//                                                           newValue.qualityLevel;
//                                                     });
//                                                   },
//                                                   items: _qualityLevels?.map(
//                                                       (QualityLevel level) {
//                                                     return DropdownMenuItem<
//                                                         QualityLevel>(
//                                                       value: level,
//                                                       child: Text(
//                                                           level.qualityLevel),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               )),
//                                         ],
//                                       ),
//                                       Column(
//                                         children: [
//                                           SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               child: const Text('Status')),
//                                           const SizedBox(height: 2),
//                                           Container(
//                                               height: 35,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.45,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 border: Border.all(
//                                                     color: Colors.black,
//                                                     width: 1),
//                                                 color: Colors.white,
//                                               ),
//                                               child:
//                                                   DropdownButtonHideUnderline(
//                                                 child: DropdownButton<Status>(
//                                                   isExpanded: true,
//                                                   value: _selectedStatus,
//                                                   onChanged:
//                                                       (Status? newValue) {
//                                                     setState(() {
//                                                       _selectedStatus =
//                                                           newValue!;
//                                                       statusDescrValue =
//                                                           newValue.mainID;
//                                                     });
//                                                   },
//                                                   items: _status
//                                                       ?.map((Status level) {
//                                                     return DropdownMenuItem<
//                                                         Status>(
//                                                       value: level,
//                                                       child:
//                                                           Text(level.mainDescr),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               )),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Checkbox(
//                                           value: isCheckedReport,
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               isCheckedReport = value!;
//                                             });
//                                           }),
//                                       const Text('Report Level'),
//                                       Checkbox(
//                                           value: isCheckedMaterial,
//                                           onChanged: (bool? value) {
//                                             setState(() {
//                                               isCheckedMaterial = value!;
//                                             });
//                                           }),
//                                       const Text('Material Level'),
//                                     ],
//                                   ),
//                                   const Divider(
//                                       thickness: 1, color: Colors.black),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             border: Border.all(
//                                                 color: Colors.black, width: 1)),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Column(children: [
//                                               const Text('Arrival Time'),
//                                               Text(arrivalTime),
//                                             ]),
//                                             IconButton(
//                                                 icon: const Icon(
//                                                     Icons.access_time),
//                                                 onPressed: () {
//                                                   _selectTime(context);
//                                                 }),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             border: Border.all(
//                                                 color: Colors.black, width: 1)),
//                                         child: Row(
//                                           children: [
//                                             Column(children: [
//                                               const Text('Start Time'),
//                                               Text(startTime),
//                                             ]),
//                                             IconButton(
//                                                 icon: const Icon(
//                                                     Icons.access_time),
//                                                 onPressed: () {
//                                                   _selectTimeStart(context);
//                                                 }),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             border: Border.all(
//                                                 color: Colors.black, width: 1)),
//                                         child: Row(
//                                           children: [
//                                             Column(children: [
//                                               const Text('Complete Time'),
//                                               Text(completeTime),
//                                             ]),
//                                             IconButton(
//                                                 icon: const Icon(
//                                                     Icons.access_time),
//                                                 onPressed: () {
//                                                   _selectTimeComplete(context);
//                                                 })
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         border: Border.all(
//                                             color: Colors.black, width: 1)),
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.9,
//                                     child: TextFormField(
//                                       keyboardType: TextInputType.name,
//                                       onChanged: (value) =>
//                                           vendorPresentative = value.trim(),
//                                       style: const TextStyle(
//                                           fontSize: 12, color: Colors.black),
//                                       decoration: const InputDecoration(
//                                           label: Text('Remark')),
//                                     ),
//                                   )
//                                 ],
//                               )
//                             : Container(),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       // builder: (_) => PoPage(id:widget.id)));
//                                       builder: (_) => OverAllResult(id: '',)));
//                             },
//                             child: const Text('Go To Po Details')),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
//
//   _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//     await _convertTime();
//   }
//
//   _selectTimeStart(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedStartTime,
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != selectedStartTime) {
//       setState(() {
//         selectedStartTime = picked;
//       });
//     }
//     await _convertTime();
//   }
//
//   _selectTimeComplete(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedCompleteTime,
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != selectedCompleteTime) {
//       setState(() {
//         selectedCompleteTime = picked;
//       });
//     }
//     await _convertTime();
//   }
// }
//
// class InspectionLevel {
//   final int id;
//   final String pRowID;
//   final String locID;
//   final String inspDescr;
//   final String inspAbbrv;
//   final int recDirty;
//   final int recEnable;
//   final String recUser;
//   final String recAddDt;
//   final String recDt;
//   final dynamic ediDt;
//   final int isDefault;
//   final String createdAt;
//
//   InspectionLevel({
//     required this.id,
//     required this.pRowID,
//     required this.locID,
//     required this.inspDescr,
//     required this.inspAbbrv,
//     required this.recDirty,
//     required this.recEnable,
//     required this.recUser,
//     required this.recAddDt,
//     required this.recDt,
//     required this.ediDt,
//     required this.isDefault,
//     required this.createdAt,
//   });
// }
//
// class QualityLevel {
//   final int id;
//   final String pRowID;
//   final String locID;
//   final String qualityLevel;
//   final int recDirty;
//   final int recEnable;
//   final String recUser;
//   final String recAddDt;
//   final String recDt;
//   final dynamic ediDt;
//
//   QualityLevel({
//     required this.id,
//     required this.pRowID,
//     required this.locID,
//     required this.qualityLevel,
//     required this.recDirty,
//     required this.recEnable,
//     required this.recUser,
//     required this.recAddDt,
//     required this.recDt,
//     required this.ediDt,
//   });
// }
//
// class Status {
//   final int id;
//   final int genID;
//   final String masterName;
//   final int mainID;
//   final String mainDescr;
//   final String subID;
//   final String subDescr;
//   final int numVal1;
//   final int numVal2;
//   final String form;
//   final String addonInfo;
//   final String moreInfo;
//   final int priviledge;
//   final int a;
//   final String moduleAccess;
//   final String moduleID;
//   final dynamic createdAt;
//
//   Status({
//     required this.id,
//     required this.genID,
//     required this.masterName,
//     required this.mainID,
//     required this.mainDescr,
//     required this.subID,
//     required this.subDescr,
//     required this.numVal1,
//     required this.numVal2,
//     required this.form,
//     required this.addonInfo,
//     required this.moreInfo,
//     required this.priviledge,
//     required this.a,
//     required this.moduleAccess,
//     required this.moduleID,
//     required this.createdAt,
//   });
// }
