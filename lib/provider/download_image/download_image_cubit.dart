import 'dart:math' as developer;
import 'dart:developer' as dev;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../master_repo.dart';

part 'download_image_state.dart';

class DownloadImageCubit extends Cubit<DownloadImageState> {
  DownloadImageCubit() : super(DownloadImageInitial());

/*  Future<void> downloadImage(String pRowId) async {
    try {
      emit(DownloadImageLoading(count: 1));

      final response = await MasterRepo().downloadAndUpdateImage(pRowId: pRowId);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        String? base64Content = data["fileContent"];

        if (base64Content != null && base64Content.isNotEmpty) {
          // Decode the base64 string to bytes
          Uint8List bytes = base64Decode(base64Content);

          // Perform the update
          await QrPoItemDtlImageTable().update(pRowId, {
            QrPoItemDtlImageTable.fileContent: bytes,
          });

          emit(DownloadImageSuccess());
        } else {
          emit(DownloadImageFailure("No image data received for ID: $pRowId"));
        }
      } else {
        emit(DownloadImageFailure("Failed to fetch image for ID: $pRowId"));
      }
    } catch (e) {
      emit(DownloadImageFailure("Error downloading image: $e"));
    }
  }*/

Future<String> _saveImageLocally(Uint8List bytes, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName'; // Add extension if needed (e.g., .png)
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return file.path;
}


  Future<void> downloadImages(List<String> pRowIds) async {
    if (pRowIds.isEmpty) {
      emit(DownloadImageSuccess());
      return;
    }

    int totalImages = pRowIds.length;
    int downloadedCount = 0;

    for (String pRowId in pRowIds) {
      try {
        final response = await MasterRepo().downloadAndUpdateImage(pRowId: pRowId);
        downloadedCount++;
        dev.log("data >>>>>>${response.data}");
        dev.log("data >>>>>>${downloadedCount}");

        if (response.statusCode == 200 && response.data != null) {
          final dynamic data = response.data;
          dev.log("Response data type: ${data.runtimeType}");
          dev.log("Response data: $data");
          
        try {
  if (data is List && data.isNotEmpty) {
    final firstItem = data[0];
    if (firstItem is Map<String, dynamic>) {
      String? base64Content = firstItem["fileContent"];
      if (base64Content != null && base64Content.isNotEmpty) {
        Uint8List bytes = base64Decode(base64Content);
        String localFilePath = await _saveImageLocally(bytes, pRowId);
        await QrPoItemDtlImageTable().update(pRowId, {
          QrPoItemDtlImageTable.imagePathID: localFilePath,
        });
        dev.log("Updated database with local file path: $localFilePath");
      }
    }
  }
} catch (e, stackTrace) {
  dev.log("Error processing image: $e");
  dev.log(stackTrace.toString());
}

        }

        emit(DownloadImageLoading(count: downloadedCount));

        if (downloadedCount == totalImages) {
          emit(DownloadImageSuccess());
        }
      } catch (e) {
        print("Error downloading image for $pRowId: $e");
      }
    }
  }
}
