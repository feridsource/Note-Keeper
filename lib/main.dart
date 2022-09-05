import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/app/core/theme.dart';
import 'package:notekeeper/app/features/login/presentation/login.dart';
import 'package:notekeeper/app/features/notes/bloc/notes_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => NotesBloc(),
      child: MaterialApp(
        title: 'Note Keeper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: blueGrey,
          scaffoldBackgroundColor: bgColor,
        ),
        home: const Login(),
      ),
    );
  }
}