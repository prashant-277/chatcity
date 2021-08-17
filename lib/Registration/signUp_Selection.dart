import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class signUp_Selection extends StatefulWidget {
  const signUp_Selection({Key key}) : super(key: key);

  @override
  _signUp_SelectionState createState() => _signUp_SelectionState();
}

class _signUp_SelectionState extends State<signUp_Selection> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      body: Container(
        height: query.height,
        width: query.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset(
              "Assets/Images/logo.png",
              height: 130.sp,
            ),
            SizedBox(height: 20.sp),
            Container(
              width: query.width * 0.8,
              child: Text(
                "Get one of the best chat apps loaded onto your phone, and you never have to worry about staying in touch. And staying in touch with friends and family is exactly what you'll want to do.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cBlack,
                  fontSize: small,
                  fontFamily: "SFPro",
                  height: 1.3.sp,
                ),
              ),
            ),
            SizedBox(height: 20.sp),
            Container(
                width: query.width * 0.8,
                height: query.height * 0.085,
                child: basicButton(
                    cwhite, () {}, "Register with Email", cButtoncolor)),
            SizedBox(height: 10.sp),
            Container(
                width: query.width * 0.8,
                height: query.height * 0.085,
                child: basicButton(cwhite, () {}, "Login", cOrange)),
          ],
        ),
      ),
    );
  }
}
