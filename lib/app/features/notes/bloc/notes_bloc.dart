import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utility.dart';
import '../models/my_note.dart';
import 'notes_state.dart';

part 'notes_event.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<GetNotesEvent>(getNotes);
    on<AddNoteEvent>(addNote);
    on<RefreshNoteEvent>(refreshNotes);
    on<UpdateNoteEvent>(updateNote);
    on<DeleteNoteEvent>(deleteNote);
  }

  DatabaseReference fbDb = FirebaseDatabase.instance.ref("mynotes");
  List<MyNote> myNotesList = [];

  /// Get list of notes.
  void getNotes(GetNotesEvent event, Emitter<NotesState> emit) {
    emit(NotesFetching());
    var stream = fbDb.orderByChild("email").equalTo(event.email).onValue;
    emit.forEach(
      stream,
      onData: (DatabaseEvent event) {
        List<MyNote> list = [];
        if (event.snapshot.value != null) {
          var myNotes = event.snapshot.value as Map<dynamic, dynamic>;

          myNotes.forEach((key, object) {
            var myNote = MyNote.fromJson(key, object);
            list.add(myNote);
          });
        }

        return NotesFetched(list);
      },
    );
  }

  /// Refresh notes list after snapshot.
  void refreshNotes(RefreshNoteEvent event, Emitter<NotesState> emit) {
    emit(NotesFetched(myNotesList));
  }

  /// Delete note from the cloud.
  void deleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) {
    fbDb.child(event.selectedItem).remove();
  }

  /// Add note to the cloud.
  void addNote(AddNoteEvent event, Emitter<NotesState> emit) {
    var myNote = HashMap<String, dynamic>();
    myNote["email"] = event.email;
    myNote["anote"] = event.anote;
    myNote["time"] = Utility.getNow();
    fbDb.push().set(myNote);
  }

  /// Update note in the cloud.
  void updateNote(UpdateNoteEvent event, Emitter<NotesState> emit) {
    var myNote = HashMap<String, dynamic>();
    myNote["email"] = event.email;
    myNote["anote"] = event.anote;
    myNote["time"] = Utility.getNow();
    fbDb.child(event.selectedItem).update(myNote);
  }
}