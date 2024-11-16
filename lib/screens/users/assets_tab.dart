import 'package:ayesha_project/components/download_manager.dart';
import 'package:ayesha_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetsTab extends StatefulWidget {
  final String sessionId;

  const AssetsTab({super.key, required this.sessionId});

  @override
  _AssetsTabState createState() => _AssetsTabState();
}

class _AssetsTabState extends State<AssetsTab> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> files = [];
  final Color primaryColor = const Color.fromARGB(255, 78, 90, 254);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final querySnapshot = await firestore
          .collection('session_files')
          .where('sessionId', isEqualTo: widget.sessionId)
          .get();

      setState(() {
        files.clear();
        files.addAll(querySnapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['fileName'],
              'size': (doc['size'] / (1024 * 1024)).toStringAsFixed(2),
              'url': doc['fileUrl'],
            }));
        isLoading = false;
      });
    } catch (e) {
      print("Error loading files: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadManager>(
      builder: (context, downloadManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            downloadManager.isDownloading
                ? LinearProgressIndicator(
                    value: downloadManager.progress,
                    color: primaryColor,
                  )
                : Container(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : files.isEmpty
                      ? const Center(child: Text("No files available"))
                      : ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: const Icon(Icons.insert_drive_file,
                                    color: Colors.blueAccent),
                                title: Text(file['name']),
                                trailing: IconButton(
                                  icon:
                                      Icon(Icons.download, color: primaryColor),
                                  onPressed: () {
                                    if (!downloadManager.isDownloading) {
                                      downloadManager.downloadFile(
                                          file['name'], file['url']);
                                    } else {
                                      rootScaffoldMessengerKey.currentState
                                          ?.showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "A download is already in progress.",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: primaryColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}
