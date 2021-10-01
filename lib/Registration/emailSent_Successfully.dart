import 'dart:io';

import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Registration/resetPassword.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class emailSent_Successfully extends StatefulWidget {
  const emailSent_Successfully({Key key}) : super(key: key);

  @override
  _emailSent_SuccessfullyState createState() => _emailSent_SuccessfullyState();
}

class _emailSent_SuccessfullyState extends State<emailSent_Successfully> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Do you want to exit an app?',
            style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w600,
                color: cBlack,
                fontSize: 14.sp)),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No',
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w600,
                    color: cBlack,
                    fontSize: 14.sp)),
          ),
          FlatButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text('Yes',
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w600,
                    color: cBlack,
                    fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                            child: login_Screen()));
                  }, "Continue", cButtoncolor)),

            ],
          ),
        ),
      ),
    );
  }
}
