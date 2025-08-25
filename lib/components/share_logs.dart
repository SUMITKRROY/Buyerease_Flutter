import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareLogFile() async {
  try {
    // Original file path (internal storage)
    final originalFile = File('/data/user/0/com.example.buyerease/files/FslLog.txt');

    // Get temp directory (you can also use getExternalStorageDirectory for permanent access)
    final tempDir = await getTemporaryDirectory();
    final newPath = '${tempDir.path}/FslLog.txt';

    // Copy to shareable path
    final copiedFile = await originalFile.copy(newPath);

    // Share the file
    await Share.shareXFiles([XFile(copiedFile.path)], text: 'Sharing FslLog.txt');
  } catch (e) {
    print("Error sharing file: $e");
  }
}
