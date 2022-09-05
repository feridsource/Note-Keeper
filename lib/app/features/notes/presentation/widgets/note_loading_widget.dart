import 'package:flutter/material.dart';

class NoteLoadingWidget extends StatelessWidget {
  const NoteLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
      CircularProgressIndicator.adaptive(
          backgroundColor: Colors.indigoAccent
      ),
    );
  }
}
