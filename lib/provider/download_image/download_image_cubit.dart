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

        // Only proceed if response is received
        downloadedCount++;

        if (response.statusCode == 200 && response.data != null) {
          final dynamic data = response.data;

          if (data is Map<String, dynamic>) {
            String? base64Content = data["fileContent"];

            if (base64Content != null && base64Content.isNotEmpty) {
              Uint8List bytes = base64Decode(base64Content);
              await QrPoItemDtlImageTable().update(pRowId, {
                QrPoItemDtlImageTable.fileContent: bytes,
              });
            }
          } else {
            print("Unexpected response format: $data");
          }
        }

        print("downloadedCount $downloadedCount");
        emit(DownloadImageLoading(count: downloadedCount));

        if (downloadedCount == totalImages) {
          emit(DownloadImageSuccess());
        }
      } catch (e) {
        // Do NOT increment here – since response was not received
        print("Error downloading image for $pRowId: $e");
        // Optional: emit error state or log
      }
    }
  }

}
