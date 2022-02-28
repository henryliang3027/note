part of 'note_bloc.dart';

enum NoteStatus { initial, loading, success, empty }

class NoteState extends Equatable {
  const NoteState({
    this.status = NoteStatus.initial,
    this.notes = const <Note>[],
  });

  final NoteStatus status;
  final List<Note> notes;

  NoteState copyWith({
    NoteStatus? status,
    List<Note>? notes,
  }) {
    return NoteState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [status, notes];
}

// abstract class NoteState {}

// class NoteInitialState extends NoteState {}

// class NoteFetchingState extends NoteState {}

// class NoteFetchingCompleteState extends NoteState {
//   List<Note> notes;

//   NoteFetchingCompleteState(this.notes);
// }
