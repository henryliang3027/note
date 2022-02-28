import 'package:equatable/equatable.dart';
import 'package:note/models/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/repositories/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _noteRepository;

  NoteBloc(this._noteRepository) : super(const NoteState()) {
    on<GetNotesEvent>(_onGetNotesEvent);
    on<AddNoteEvent>(_onAddNoteEvent);
    on<RemoveNoteEvent>(_onRemoveNoteEvent);
    on<UpdateNoteEvent>(_onUpdateNoteEvent);
  }

  void _onGetNotesEvent(GetNotesEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    final List<Note> _notes = await _getNotes();
    _notes.isNotEmpty
        ? emit(state.copyWith(status: NoteStatus.success, notes: _notes))
        : emit(state.copyWith(status: NoteStatus.empty));
  }

  void _onAddNoteEvent(AddNoteEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    await _addToNotes(event.note.title, event.note.content, event.note.colorId,
        event.note.imageContents);
    final List<Note> _notes = await _getNotes();
    emit(state.copyWith(status: NoteStatus.success, notes: _notes));
  }

  void _onUpdateNoteEvent(
      UpdateNoteEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    await _updateNote(event.index, event.note.title, event.note.content,
        event.note.colorId, event.note.imageContents);
    final List<Note> _notes = await _getNotes();
    emit(state.copyWith(status: NoteStatus.success, notes: _notes));
  }

  void _onRemoveNoteEvent(
      RemoveNoteEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    await _removeFromNotes(event.indices);
    final List<Note> _notes = await _getNotes();
    _notes.isNotEmpty
        ? emit(state.copyWith(status: NoteStatus.success, notes: _notes))
        : emit(state.copyWith(status: NoteStatus.empty));
  }

  // Helper Functions
  Future<List<Note>> _getNotes() async {
    List<Note> _notes = [];
    await _noteRepository.getFullNote().then((value) {
      _notes = value;
    });
    return _notes;
  }

  Future<void> _addToNotes(String title, String content, int colorId,
      List<ImageContent> imageContents) async {
    await _noteRepository.addToBox(Note(
        title: title,
        content: content,
        colorId: colorId,
        imageContents: imageContents));
  }

  Future<void> _updateNote(int index, String newTitle, String newContent,
      int newColorId, List<ImageContent> newImageContents) async {
    await _noteRepository.updateNote(
        index,
        Note(
            title: newTitle,
            content: newContent,
            colorId: newColorId,
            imageContents: newImageContents));
  }

  Future<void> _removeFromNotes(List<int> indices) async {
    indices.sort((a, b) => b.compareTo(a));
    for (int i = 0; i < indices.length; i++) {
      await _noteRepository.removeFromBox(indices[i]);
    }
  }
}
