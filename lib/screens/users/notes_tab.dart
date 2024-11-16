import 'package:ayesha_project/models/hive/note_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class NotesTab extends StatefulWidget {
  final String sessionId;

  const NotesTab({Key? key, required this.sessionId}) : super(key: key);

  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notesBox');
  }

  void _addNote(String content) {
    final newNote = Note(sessionId: widget.sessionId, content: content);
    notesBox.add(newNote);
    setState(() {});
  }

  void _editNote(int index, String newContent) {
    final note = notesBox.getAt(index);
    if (note != null && note.sessionId == widget.sessionId) {
      note.content = newContent;
      note.save();
    }
    setState(() {});
  }

  void _deleteNote(int index) {
    final note = notesBox.getAt(index);
    if (note != null && note.sessionId == widget.sessionId) {
      notesBox.deleteAt(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Notes List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notesBox.listenable(),
              builder: (context, Box<Note> box, _) {
                final sessionNotes = box.values
                    .where((note) => note.sessionId == widget.sessionId)
                    .toList();

                if (sessionNotes.isEmpty) {
                  return const Center(child: Text('No notes yet.'));
                }

                return ListView.builder(
                  itemCount: sessionNotes.length,
                  itemBuilder: (context, index) {
                    final note = sessionNotes[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () =>
                                  _showEditDialog(index, note.content),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // "Add New Note" Button
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
              child: const Text('Add New Note'),
            ),
          ),
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
          title: const Text('Add Note'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter note content'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNote(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(int index, String currentContent) async {
    final controller = TextEditingController(text: currentContent);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Note'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Edit note content'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editNote(index, controller.text);
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
