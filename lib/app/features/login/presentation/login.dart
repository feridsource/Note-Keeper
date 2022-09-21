import 'package:flutter/material.dart';

import '../../../core/authentication_helper.dart';
import '../../../core/utility.dart';
import '../../notes/presentation/view/notes_list.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  // whether signing in is needed or not.
  var isSignNeeded = false;

  var tfEmail = TextEditingController();
  var tfPassword = TextEditingController();

  // animation
  late AnimationController animationController;
  late Animation<Offset> animationOffset;

  var snackBar = const SnackBar(
    content: Text('Wrong email or password!'),
  );

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animationOffset = Tween<Offset>(
        begin: const Offset(0.0, 50.0), end: const Offset(0.0, 0.0))
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    checkSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.event_note,
                color: Colors.white,
                size: 128,
              ),
              const Text(
                "Note Keeper",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: tfEmail,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mail),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixText: "@gmail.com",
                    hintText: "Email",
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
              TextField(
                controller: tfPassword,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.password),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
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
              SlideTransition(
                position: animationOffset,
                child: Visibility(
                  visible: isSignNeeded,
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        animationController.reverse();

                        String mail = tfEmail.text;
                        // if only username is written, add gmail.
                        if (!mail.contains("@")) {
                          mail += "@gmail.com";
                        }
                        String pwd = tfPassword.text;

                        tfEmail.text = "";
                        tfPassword.text = "";

                        AuthenticationHelper()
                            .signIn(mail, pwd)
                            .then((value) => {
                          if (value != null)
                            {goToNoteList(mail)}
                          else
                            {
                              AuthenticationHelper()
                                  .signUp(mail, pwd)
                                  .then((value) {
                                if (value != null) {
                                  goToNoteList(mail);
                                } else {
                                  animationController.forward();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              })
                            }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                      ),
                      child: const Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check if signed in. If so, go to note list.
  Future<void> checkSignIn() async {
    bool isConnected = await Utility().isConnected();
    var userMail = AuthenticationHelper().userMail;

    if (userMail != null && isConnected) {
      goToNoteList(userMail);
    } else {
      isSignNeeded = true;
      setState(() {
        animationController.forward();
      });
    }
  }

  /// Go to note list.
  void goToNoteList(String email) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NotesList(email: email)),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    tfEmail.dispose();
    tfPassword.dispose();

    super.dispose();
  }
}
