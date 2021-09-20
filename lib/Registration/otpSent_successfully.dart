import 'package:chatcity/Registration/confirmAccount.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
class otpSent_successfully extends StatefulWidget {
  var responseJson;

  otpSent_successfully(this.responseJson);



//9824067738
//9824249792
//
  @override
  _otpSent_successfullyState createState() => _otpSent_successfullyState();
}

class _otpSent_successfullyState extends State<otpSent_successfully> {
  @override
  void initState() {
    super.initState();
    print(widget.responseJson.toString());
  }
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
            Text("OTP sent",
              style: TextStyle(
                color: cBlack,
                fontSize: header,
                fontFamily: "SFPro",
                fontWeight: FontWeight.w600,
                height: 1.3.sp,
              )),

            Container(
              width: 250.sp,
              child: Text("Check your inbox we will sent 4 digit otp number.",
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
                          child: confirmAccount(widget.responseJson)));
                }, "Continue", cButtoncolor)),

          ],
        ),
      ),
    );
  }
}
