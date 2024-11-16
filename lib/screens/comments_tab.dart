import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentsTab extends StatefulWidget {
  final String sessionId;

  const CommentsTab({Key? key, required this.sessionId}) : super(key: key);

  @override
  _CommentsTabState createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _addComment(String text) async {
    if (user == null || text.isEmpty) return;

    final comment = {
      'sessionId': widget.sessionId,
      'userId': user!.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('comments').add(comment);
    _commentController.clear();
  }

  Future<void> _editComment(String docId, String newText) async {
    await _firestore
        .collection('comments')
        .doc(docId)
        .update({'text': newText});
  }

  Future<void> _deleteComment(String docId) async {
    await _firestore.collection('comments').doc(docId).delete();
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc['name'] ?? 'Unknown';
    } catch (e) {
      print("Error fetching user name: $e");
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = user?.uid;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('comments')
                  .where('sessionId', isEqualTo: widget.sessionId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final doc = comments[index];
                    final commentData = doc.data() as Map<String, dynamic>;
                    final commentText =
                        commentData['text'] as String? ?? 'No text';
                    final commentUserId =
                        commentData['userId'] as String? ?? 'Unknown user';

                    final isCurrentUser = commentUserId == userId;

                    return FutureBuilder<String>(
                      future: _getUserName(commentUserId),
                      builder: (context, userSnapshot) {
                        final userName = userSnapshot.data ?? 'Unknown';

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.75, // 75% of screen width
                              minWidth: MediaQuery.of(context).size.width *
                                  0.5, // 50% of screen width
                            ),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue[50]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentText,
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isCurrentUser ? 'You' : userName,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black, size: 18),
                                    onPressed: () =>
                                        _showEditDialog(doc.id, commentText),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 18),
                                    onPressed: () => _deleteComment(doc.id),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => _showAddDialog(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 78, 90, 254),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add New',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add Comment'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter comment'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addComment(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(String docId, String currentText) async {
    final controller = TextEditingController(text: currentText);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Comment'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Edit comment'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editComment(docId, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
