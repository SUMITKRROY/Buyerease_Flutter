import 'dart:developer' as dev;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/table/qr_po_item_dtl_image_table.dart';
import '../master_repo.dart';

part 'download_image_state.dart';

class DownloadImageCubit extends Cubit<DownloadImageState> {
  DownloadImageCubit() : super(DownloadImageInitial());

  Future<String> _saveImageLocally(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName'; // Optionally add extension like .jpg
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

        if (response.statusCode == 200 && response.data != null) {
          final dynamic data = response.data;

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

                  downloadedCount++; // ✅ Increment only after successful save
                  emit(DownloadImageCount(count: downloadedCount));
                  dev.log("Image saved at: $localFilePath for ID: $pRowId");
                }
              }
            }
          } catch (e, stackTrace) {
            dev.log("Error processing image for $pRowId: $e");
            dev.log(stackTrace.toString());
            emit(DownloadImageFailure("Error processing image for ID: $pRowId"));
          }
        } else {
          dev.log("Failed response for $pRowId");
          emit(DownloadImageFailure("Failed to fetch image for ID: $pRowId"));
        }

        emit(DownloadImageLoading(count: downloadedCount));

        if (downloadedCount == totalImages) {
          emit(DownloadImageSuccess());
        }

      } catch (e) {
        dev.log("Exception during image download for $pRowId: $e");
        emit(DownloadImageFailure("Exception for ID $pRowId: $e"));
      }
    }
  }
}
