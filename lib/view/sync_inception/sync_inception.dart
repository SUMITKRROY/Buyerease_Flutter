import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/provider/defect_master/defect_master_cubit.dart';
import 'package:buyerease/provider/sync_cubit/sync_cubit.dart';
import 'package:buyerease/utils/app_constants.dart';

import 'package:buyerease/utils/toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../components/custom_appbar.dart';
import '../../database/database_helper.dart';
import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../../provider/download_image/download_image_cubit.dart';
import '../../provider/login_cubit/login_cubit.dart';
import '../../routes/route_path.dart';
import '../networks/endpoints.dart';
import '../post/post_api_call.dart';

class SyncInception extends StatefulWidget {
  const SyncInception({super.key});

  @override
  State<SyncInception> createState() => _SyncInceptionState();
}

class _SyncInceptionState extends State<SyncInception> {
  bool dataDownloaded = false;
  bool imagesDownloaded = false;
  int totalImages = 0;
  int downloadedImages = 0;

  StreamSubscription? progressSubscription;
  String deviceID = '';
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    getUserId();
  }

  Future<Object?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.id;
      debugPrint('deviceID $deviceID');
    }
    return null;
  }

  Future<void> getUserId() async {
    final userRecords = await UserMasterTable().getAll();

    if (userRecords.isNotEmpty) {
      setState(() {
        userId = userRecords.first[UserMasterTable.pUserID];
      });
      print("User ID: $userId");
    } else {
      print("No user record found.");
    }
  }


  void _showDataSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Data Sync Progress"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(child: Text("Downloading data")),
                  dataDownloaded
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Processing"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Row(
                children: [
                  Expanded(child: Text("Getting image data...")),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Image Download Progress"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text("Downloading images")),
                      imagesDownloaded
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : totalImages > 0
                              ? Text("$downloadedImages/$totalImages")
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(name: 'Buyerease\'s'),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SyncCubit, SyncState>(
              listener: (context, state) async {
                if (state is SyncLoading) {
                  _showDataSyncDialog(context);
                } else if (state is SyncSuccess) {
                  // Close the data sync dialog first
                  Navigator.of(context).pop();
                  
                  // Fetch defect master data
                  BlocProvider.of<DefectMasterCubit>(context).fetchDefectMaster(data: userId);
                  setState(() {
                    dataDownloaded = true;
                  });

                  // Show loading dialog while getting image data
                  _showLoadingDialog(context);

                  // Get all item IDs for image download
                  final ids = await fetchAllItemIds();
                  
                  // Close loading dialog
                  Navigator.of(context).pop();

                  if (ids.isNotEmpty) {
                    // Show image download dialog after data sync is complete
                    _showImageDownloadDialog(context);
                    await startImageDownload(ids);
                  } else {
                    // No images to download, navigate directly
                    Navigator.pushReplacementNamed(context, RoutePath.inspection);
                  }
                } else if (state is SyncFailure) {
                  Navigator.of(context).pop(); // Close dialog if failed
                  showToast("Sync failed: ${state.error}", false);
                }
              },
            ),
            BlocListener<DownloadImageCubit, DownloadImageState>(
              listener: (context, state) {
                if (state is DownloadImageLoading) {
                  setState(() {
                    downloadedImages = state.count;
                  });
                } else if (state is DownloadImageSuccess) {
                  setState(() {
                    imagesDownloaded = true;
                  });
                  checkDownloadComplete();
                } else if (state is DownloadImageFailure) {
                  setState(() {
                    downloadedImages++;
                  });
                  checkDownloadComplete();
                }
              },
            ),
          ],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<SyncCubit>().sync(
                      user: userId,
                      deviceId: deviceID,
                      deviceIP: "10.0.2.16",
                      hddSerialNo: "",
                      deviceType: "A",
                      location: "",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void checkDownloadComplete() {
    if (downloadedImages >= totalImages && totalImages > 0) {
      setState(() {
        imagesDownloaded = true;
      });
      // Close only the image download dialog
      Navigator.of(context).pop();
      showToast("Sync completed successfully", true);
      // Navigate to the next page
      Navigator.pushReplacementNamed(context, RoutePath.inspection);
    }
  }

  Future<List<String>> fetchAllItemIds() async {
    List<String> itemIds = [];
    try {
      final Database db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT DISTINCT ${QrPoItemDtlImageTable.pRowID} FROM ${QrPoItemDtlImageTable.TABLE_NAME} WHERE ${QrPoItemDtlImageTable.recEnable}=1',
      );
      for (final row in result) {
        final imageName = row[QrPoItemDtlImageTable.pRowID];
        if (imageName != null) {
          print('Image RowID: $imageName');
          itemIds.add(imageName.toString());
        }
      }
    } catch (e) {
      print('Error fetching item IDs: $e');
    }
    return itemIds;
  }

  Future<void> startImageDownload(List<String> itemIds) async {
    if (itemIds.isEmpty) {
      setState(() {
        imagesDownloaded = true;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, RoutePath.inspection);
      return;
    }

    setState(() {
      totalImages = itemIds.length;
      downloadedImages = 0;
    });

    context.read<DownloadImageCubit>().downloadImages(itemIds);
  }
}
