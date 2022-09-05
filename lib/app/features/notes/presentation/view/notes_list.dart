import 'package:app_rating/app_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/app/features/notes/bloc/notes_bloc.dart';
import 'package:notekeeper/app/features/notes/presentation/widgets/note_loading_widget.dart';

import '../../../../core/authentication_helper.dart';
import '../../bloc/notes_state.dart';
import '../../models/my_note.dart';
import '../widgets/note_error_widget.dart';

class NotesList extends StatefulWidget {
  final String email;

  const NotesList({Key? key, required this.email}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  var tfAnote = TextEditingController(); // to add or update note
  String selectedItem = ""; // if any item is selected key will be assigned
  List<MyNote> myNotes = [];

  @override
  void initState() {
    super.initState();

    rateApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: const Text("Note Keeper"), actions: [
                IconButton(
                    onPressed: () {
                      AuthenticationHelper()
                          .signOut()
                          .then((value) => {SystemNavigator.pop()});
                    },
                    icon: const Icon(Icons.logout))
              ]),
              body: _stateRouter(context, state));
        },
      ),
    );
  }

  /// Show relevant screen according to given state.
  Widget _stateRouter(BuildContext context, NotesState state) {
    if (state is NotesInitial) {
      context.read<NotesBloc>().add(GetNotesEvent(widget.email));
      return const Center();
    } else if (state is NotesFetching) {
      return const NoteLoadingWidget();
    } else if (state is NotesFetched) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: tfAnote,
                maxLength: 50,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        tfAnote.text = "";
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Write your note",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.myNotes.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedItem = state.myNotes[index].key;
                      tfAnote.text = state.myNotes[index].anote;
                    },
                    onLongPress: () {
                      selectedItem = state.myNotes[index].key;
                      askForDelete(selectedItem);
                      selectedItem = "";
                      tfAnote.text = "";
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.myNotes[index].anote,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.myNotes[index].time,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              saveNote(selectedItem, tfAnote.text.trim());
              selectedItem = "";
              tfAnote.text = "";
            }),
      );
    } else if (state is NotesError) {
      return NoteErrorWidget(errorMessage: state.error);
    } else {
      return const NoteErrorWidget(errorMessage: "Unknown Error");
    }
  }

  /// Add or update note
  void saveNote(String selectedItem, String anote) {
    if (anote != "") {
      if (selectedItem == "") {
        context.read<NotesBloc>().add(AddNoteEvent(widget.email, anote));
      } else {
        context
            .read<NotesBloc>()
            .add(UpdateNoteEvent(widget.email, selectedItem, anote));
      }

      // close keyboard
      FocusScope.of(context).unfocus();
    }
  }

  /// Ask to delete selected item.
  void askForDelete(String selectedItem) {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure to delete?"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              if (selectedItem != "") {
                context.read<NotesBloc>().add(DeleteNoteEvent(selectedItem));
              }
              Navigator.of(context).pop();
            },
            child: const Text("Delete")),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  /// Ask to rate the application
  void rateApp() {
    AppRating appRating = AppRating(context, frequency: 20);
    appRating.initRating();
  }

  @override
  void dispose() {
    tfAnote.dispose();

    super.dispose();
  }
}
