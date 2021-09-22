import 'dart:convert';

import 'package:chatcity/Registration/otpSent_successfully.dart';
import 'package:chatcity/TermsofService.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class RegisterwithEmail extends StatefulWidget {
  const RegisterwithEmail({Key key}) : super(key: key);

  @override
  _RegisterwithEmailState createState() => _RegisterwithEmailState();
}

class _RegisterwithEmailState extends State<RegisterwithEmail> {
  final url1 = url.basicUrl;
  final _formKey = GlobalKey<FormState>();
  TextEditingController Email_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      resizeToAvoidBottomInset: false,
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
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: textfield(
                            controller: Email_controller,
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
                            parametersValidate: "Please enter Email",
                            functionValidate: commonValidation,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                          width: 90.w,
                          height: 7.5.h,
                          child: basicButton(cwhite, () async {
                            if (_formKey.currentState.validate()) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              isRegistered(Email_controller.text.toString());
                            }
                          }, "Continue", cButtoncolor)),
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
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: TermsofService()));
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



  Future<bool> isRegistered(String email) async {
    bool isValid = false;
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/verifyEmail";
    var map = new Map<String, dynamic>();
    map["email"] = email.toString();

    final response = await http.post(url, body: map);
    final responseJson = json.decode(response.body);
    print("veryfyEmail -- " + responseJson.toString());
    if (response.statusCode == 200) {
      String status = responseJson["status"].toString();
      if (!status.isEmpty && status == "fail") {

        isValid = true;
        createUser(email.toString());
        print("fail ---- " + responseJson("message").toString());
        pr.hide();
      } else {
        displayToast("The email has already been taken.");
        pr.hide();
        print("not fail ---- " + responseJson("message").toString());

      }
    } else {
      displayToast(response.statusCode.toString());
    }

    return isValid;
  }

  Future<int> createUser(String email) async {
    int userId;
    try {
      QBUser user = await QB.users.createUser(email, USER_PASSWORD);
      userId = user.id;
      registerwithEmail(userId.toString());
    } on PlatformException catch (e) {}
    print("userId " + userId.toString());
    return userId;
  }

  Future<void> registerwithEmail(String qb_Id) async {

    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/registerWithMail";

    var map = new Map<String, dynamic>();
    map["email"] = Email_controller.text.toString();
    map["quickboxid"] = qb_Id.toString();

    final response = await http.post(url, body: map);

    final responseJson = json.decode(response.body);
    print("registerWithMail-- " + responseJson.toString());

    if (responseJson["status"].toString() == "fail") {
      displayToast(responseJson["message"].toString());
      pr.hide();
    } else {
      displayToast("Please check your mailbox");
      pr.hide();

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.bottomCenter,
              child: otpSent_successfully(responseJson)));
    }
  }
}
ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}