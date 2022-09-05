import 'package:flutter/material.dart';

class NoteErrorWidget extends StatelessWidget {
  final String errorMessage;

  const NoteErrorWidget({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(fontSize: 22, color: Colors.indigo),
      ),
    );
  }
}
