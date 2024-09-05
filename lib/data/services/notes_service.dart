import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:task_mgmnt_system/data/models/user_model.dart';

import '../models/note.dart';

class NotesService {
  final Dio _dio = Dio();
  final Box<Note> _notesBox = Hive.box<Note>('notes');
  final Box<UserModel> _userBox = Hive.box<UserModel>('user');

  var notes = <Note>[].obs;

  void onInit() {
    loadTasksFromLocal();
  }

  void loadTasksFromLocal() {
    notes.assignAll(_notesBox.values.toList());
  }

  Future<void> fetchNotesFromApi() async {
    final empId = getUserId();

    final response = await _dio.get(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/fnGetStickNote',
        queryParameters: {'empId': empId});

    if (response.statusCode == 200) {
      var resNotes = response.data.map<Note>((noteData) {
        int stickyNoteId = noteData['StickyNoteID'] ?? 0;
        return Note(
          stcId: stickyNoteId,
          note: noteData['Note'] ?? '', // Ensure note text is not null
          isSynced: true,
        );
      }).toList();

      // Save notes locally
      await _notesBox.clear(); // Clear old notes
      await _notesBox.addAll(resNotes);
    }
  }

  Future<void> addOrUpdateNote(Note note) async {
    final userId = getUserId();

    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      final response = await _dio.post(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/fnAddEditStickyNote',
        queryParameters: {
          'stcId': note.stcId,
          'myNote': note.note,
          'empId': userId
        },
      );

      if (response.statusCode == 200) {
        note.isSynced = true;
      }
    }

    // Save to local Hive database
    await _notesBox.put((note.stcId==0) ? note.stcId + 1:note.stcId, note);
    notes.assignAll(_notesBox.values.toList());
  }

  Future<void> deleteNote(int stcId) async {
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      await _dio.post(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/fnAddEditStickyNote',
        queryParameters: {'stckId': stcId},
      );
    }
    // Delete from local Hive database
    await _notesBox.delete(stcId);
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncLocalNotes() async {
    bool isConnected = await checkInternetConnection();
    if (isConnected) {
      final unsyncedNotes =
          _notesBox.values.where((note) => !note.isSynced).toList();
      for (var note in unsyncedNotes) {
        await addOrUpdateNote(note);
      }
    }
    notes.assignAll(_notesBox.values.toList());
  }

  int getUserId() {
    var usr = _userBox.get('user');
    int empId = 0;
    if (usr != null) {
      empId = usr.employeeID;
    }
    return empId;
  }
}
