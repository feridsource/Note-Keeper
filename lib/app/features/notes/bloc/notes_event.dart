part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddNoteEvent extends NotesEvent {
  final String email;
  final String anote;

  AddNoteEvent(this.email, this.anote);
}

class DeleteNoteEvent extends NotesEvent {
  final String selectedItem;

  DeleteNoteEvent(this.selectedItem);
}

class UpdateNoteEvent extends NotesEvent {
  final String email;
  final String selectedItem;
  final String anote;

  UpdateNoteEvent(this.email, this.selectedItem, this.anote);
}

class GetNotesEvent extends NotesEvent {
  final String email;

  GetNotesEvent(this.email);
}

class RefreshNoteEvent extends NotesEvent {
  RefreshNoteEvent();
}