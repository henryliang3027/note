import 'package:hive/hive.dart';
import 'dart:async';
import '../models/note_model.dart';

class NoteRepository {
  NoteRepository() : _noteBox = Hive.box('Note');
  final Box<Note> _noteBox;

  // get full note
  Future<List<Note>> getFullNote() async => _noteBox.values.toList();

  // to add data in box
  Future<void> addToBox(Note note) async => await _noteBox.add(note);

  // delete data from box
  Future<void> removeFromBox(int index) async => await _noteBox.deleteAt(index);

  // delete all data from box
  Future<void> deleteAll() async => await _noteBox.clear();

  // update data
  Future<void> updateNote(int index, Note note) async =>
      await _noteBox.putAt(index, note);
}
