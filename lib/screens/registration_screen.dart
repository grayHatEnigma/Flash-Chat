import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/flash_button.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ///variables
  String email;
  String password;
  String passwordV;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kRegisterTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kRegisterTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  passwordV = value;
                },
                decoration: kRegisterTextFieldDecoration.copyWith(
                    hintText: 'Confirm Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              FlashButton(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  if (password != passwordV || password.length < 6) {
                    Fluttertoast.showToast(
                        msg: "Passwords don't match or it's too short.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } catch (e) {
                      String msg = e.toString();
                      String cleanMsg = msg.substring(
                        msg.indexOf(' ') + 1,
                        msg.indexOf('.') + 1,
                      );

                      Fluttertoast.showToast(
                          msg: cleanMsg,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } finally {
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
