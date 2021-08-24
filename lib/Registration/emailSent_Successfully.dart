import 'package:chatcity/Registration/resetPassword.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class emailSent_Successfully extends StatefulWidget {
  const emailSent_Successfully({Key key}) : super(key: key);

  @override
  _emailSent_SuccessfullyState createState() => _emailSent_SuccessfullyState();
}

class _emailSent_SuccessfullyState extends State<emailSent_Successfully> {
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
          children: [
            Image.asset(
              "Assets/Icons/sent.png",
              height: 120.sp,
            ),
            SizedBox(height: 10.sp),
            Text("Email sent",
                style: TextStyle(
                  color: cBlack,
                  fontSize: header,
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.w600,
                  height: 1.3.sp,
                )),

            Container(
              width: 250.sp,
              child: Text("Check your inbox we will sent you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cBlack,
                    fontSize: medium,
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w400,
                    height: 1.2.sp,
                  )),
            ),
            SizedBox(height: 25.sp),
            Container(
                width: 90.w,
                height: 7.5.h,
                child: basicButton(
                    cwhite, () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          alignment: Alignment.bottomCenter,
                          duration: Duration(milliseconds: 300),
                          child: resetPassword()));
                }, "Continue", cButtoncolor)),

          ],
        ),
      ),
    );
  }
}
