import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/flash_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation logoAnimation;
  Animation colorAnimation;

  void animationsSetter() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    logoAnimation = CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn);
    colorAnimation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    animationsSetter();
    print('welcome screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: logoAnimation.value * 120,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  duration: Duration(seconds: 7),
                  text: ['Flash Chat'],
                  isRepeatingAnimation: true,
                  textStyle: kTitleTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            FlashButton(
              text: 'Log in',
              color: Colors.lightBlue,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            FlashButton(
              text: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
