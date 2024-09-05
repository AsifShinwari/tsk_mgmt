import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/widgets/base_page.dart';
import '../../../data/models/note.dart';
import '../../../data/services/notes_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesService _notesService = NotesService();
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  @override
  void initState() {
    super.initState();
    _notesService.fetchNotesFromApi(); // Fetch notes from API
  }

  void _addOrUpdateNoteDialog({Note? note}) {
    final TextEditingController controller =
        TextEditingController(text: note?.note ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(note == null ? 'Add Note 2' : 'Update Note'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your note',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(note == null ? 'Add' : 'Update'),
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  // Show a warning message if the note is empty
                  Get.snackbar(
                    'Warning',
                    'Note cannot be empty!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }

                Note newNote = Note(
                  stcId: note?.stcId ?? 0,
                  note: controller.text.trim(),
                );
                await _notesService.addOrUpdateNote(newNote);
                _notesService.fetchNotesFromApi();
                Get.back();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDeleteDialog(Note note) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Get.back(result: false),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
              onPressed: () async {
                await _notesService.deleteNote(note.stcId);
                _notesService.fetchNotesFromApi();
                Get.back(result: true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No notes available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Note note = box.getAt(index)!;
              return Dismissible(
                key: Key(note.stcId.toString()),
                background: Container(
                  color: const Color.fromRGBO(228, 204, 65, 1),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Swipe right to edit
                    _addOrUpdateNoteDialog(note: note);
                    return false; // Return false to prevent dismiss
                  } else if (direction == DismissDirection.endToStart) {
                    // Swipe left to delete
                    return await _confirmDeleteDialog(note);
                  }
                  return false;
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    color: const Color.fromRGBO(255, 247, 209, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1,
                    child: Column(
                      children: [
                        Container(
                          height:
                              5, // Adjust the height as needed for the top border
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(228, 204, 65, 1), // Change this color for the top border
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12),
                            child: Text(
                              note.note,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onPressed: () => _addOrUpdateNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
