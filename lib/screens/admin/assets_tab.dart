import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAssetsTab extends StatefulWidget {
  final String sessionId;

  const AdminAssetsTab({Key? key, required this.sessionId}) : super(key: key);

  @override
  _AssetsTabState createState() => _AssetsTabState();
}

class _AssetsTabState extends State<AdminAssetsTab> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> files = [];
  final Color primaryColor = const Color.fromARGB(255, 78, 90, 254);
  bool isLoading = true;
  bool isUploading = false;

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

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      setState(() {
        isUploading = true;
      });

      try {
        await supabase.storage.from('rethink').upload(fileName, file);
        final fileUrl = supabase.storage.from('rethink').getPublicUrl(fileName);
        final docRef = await firestore.collection('session_files').add({
          'sessionId': widget.sessionId,
          'fileName': fileName,
          'fileUrl': fileUrl,
          'size': file.lengthSync(),
          'uploadedAt': Timestamp.now(),
        });

        setState(() {
          files.add({
            'id': docRef.id,
            'name': fileName,
            'size': (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2),
            'url': fileUrl,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('File uploaded successfully'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        print("Upload error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to upload file',
                style: TextStyle(color: Colors.white)),
            backgroundColor: primaryColor,
          ),
        );
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Future<void> _deleteFile(String fileName, String docId) async {
    try {
      await supabase.storage.from('rethink').remove([fileName]);
      await firestore.collection('session_files').doc(docId).delete();

      setState(() {
        files.removeWhere((file) => file['id'] == docId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('File deleted successfully'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to delete file',
              style: TextStyle(color: Colors.white)),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : files.isEmpty
                  ? const Center(child: Text("No files available"))
                  : isUploading
                      ? const Center(child: CircularProgressIndicator())
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
                                subtitle: Text('${file['size']} MB'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _deleteFile(file['name'], file['id']),
                                ),
                              ),
                            );
                          },
                        ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Upload', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
