part of 'note_bloc.dart';

abstract class NoteEvent {}

class GetNotesEvent extends NoteEvent {}

class UpdateNoteEvent extends NoteEvent {
  int index;
  Note note;

  UpdateNoteEvent(this.index, this.note);
}

class AddNoteEvent extends NoteEvent {
  Note note;

  AddNoteEvent(this.note);
}

class RemoveMultiNotesEvent extends NoteEvent {
  RemoveMultiNotesEvent();
}

class RemoveNoteEvent extends NoteEvent {
  List<int> indices;
  RemoveNoteEvent(this.indices);
}
