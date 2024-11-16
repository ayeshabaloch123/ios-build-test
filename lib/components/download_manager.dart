import 'package:ayesha_project/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DownloadManager with ChangeNotifier {
  bool isDownloading = false;
  double progress = 0.0;
  bool downloadSuccess = false;
  bool hasError = false;

  Future<void> downloadFile(String fileName, String fileUrl) async {
    if (isDownloading) return;

    isDownloading = true;
    downloadSuccess = false;
    hasError = false;
    progress = 0.0;
    notifyListeners();

    try {
      String path = "/storage/emulated/0/Download/$fileName";
      final request = http.Request('GET', Uri.parse(fileUrl));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final file = File(path);
        final sink = file.openWrite();

        int downloadedBytes = 0;
        final totalBytes = response.contentLength ?? 1;

        response.stream.listen(
          (data) {
            downloadedBytes += data.length;
            sink.add(data);
            progress = downloadedBytes / totalBytes;
            notifyListeners();
          },
          onDone: () async {
            await sink.close();
            downloadSuccess = true;
            isDownloading = false;
            progress = 0.0;
            notifyListeners();

            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text("File downloaded successfully to $path"),
                backgroundColor: const Color.fromARGB(255, 78, 90, 254),
              ),
            );
          },
          onError: (e) async {
            await sink.close();
            hasError = true;
            isDownloading = false;
            progress = 0.0;
            notifyListeners();

            rootScaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text("Error downloading file: $e"),
                backgroundColor: Colors.red,
              ),
            );
          },
          cancelOnError: true,
        );
      } else {
        isDownloading = false;
        hasError = true;
        notifyListeners();

        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text("Failed to download file."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      isDownloading = false;
      hasError = true;
      notifyListeners();

      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Error downloading file: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
