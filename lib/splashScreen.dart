import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/Registration/signUp_Selection.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cwhite,
      body: AnimatedSplashScreen(
        splashIconSize: 180.sp,
        splash: Image.asset(
          "Assets/Images/logo.png",
        ),
        nextScreen: signUp_Selection(),
        duration: 1000,
        pageTransitionType: PageTransitionType.fade,
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
