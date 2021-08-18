import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RegisterwithEmail extends StatefulWidget {
  const RegisterwithEmail({Key key}) : super(key: key);

  @override
  _RegisterwithEmailState createState() => _RegisterwithEmailState();
}

class _RegisterwithEmailState extends State<RegisterwithEmail> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: BaseAppBar(
        appBar: AppBar(),
        backgroundColor: cwhite,
        appbartext: "",
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "Assets/Images/logo.png",
              height: 100.sp,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: cChatbackground,
                ),
                height: 170.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Enter your email address",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cBlack,
                              fontSize: medium,
                              fontFamily: "SFPro",
                              height: 1.3.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: cwhite,
                        ),
                        child: textfield(
                          textcapitalization: TextCapitalization.none,
                          textInputType: TextInputType.emailAddress,
                          hintText: "Email",
                          obscureText: false,
                          prefixIcon: new IconButton(
                            icon: new Image.asset(
                              'Assets/Icons/email.png',
                              width: 20.sp,
                              color: cBlack,
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                          width: query.width,
                          height: query.height * 0.082,
                          child: basicButton(
                              cwhite, () {}, "Continue", cButtoncolor)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Image.asset(
                "Assets/Icons/loginwith.png",
                height: 15.sp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("Assets/Icons/google.png", height: 50.sp),
                  SizedBox(width: 10.sp),
                  Image.asset("Assets/Icons/fb.png", height: 50.sp),
                  SizedBox(width: 10.sp),
                  Image.asset("Assets/Icons/apple.png", height: 50.sp),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    style: TextStyle(
                        color: cBlack, fontSize: small, fontFamily: "SFPro"),
                    text: "By creating an account, I accept the",
                  ),
                  WidgetSpan(child: SizedBox(width: 5)),
                  TextSpan(
                    style: TextStyle(
                        color: cBlack,
                        fontSize: small,
                        decoration: TextDecoration.underline,
                        fontFamily: "SFPro"),
                    text: "Terms of Service",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {

                      },
                  ),
                ],
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
