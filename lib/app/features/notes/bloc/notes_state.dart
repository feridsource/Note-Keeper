import '../models/my_note.dart';

abstract class NotesState {
  const NotesState();
}

class NotesInitial extends NotesState {
}

class NotesFetching extends NotesState {
}

class NotesFetched extends NotesState {
  final List<MyNote> myNotes;

  const NotesFetched(this.myNotes);
}

class NotesError extends NotesState {
  final String error;

  const NotesError(this.error);
}