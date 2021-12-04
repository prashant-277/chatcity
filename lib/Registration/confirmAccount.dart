import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'emailRegistration_signUp.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;
class confirmAccount extends StatefulWidget {
  var userData;

  confirmAccount(this.userData);




  @override
  _confirmAccountState createState() => _confirmAccountState();
}

class _confirmAccountState extends State<confirmAccount> {
  var userotp;
  final url1 = url.basicUrl;
  String otp;

  @override
  void initState() {
    super.initState();
    otp = widget.userData["data"]["otp"].toString();
  }

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
      body: SingleChildScrollView(
        child: Container(
          width: query.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text("Confirm Number",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            fontFamily: "SFPro",
                            fontSize: header)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                        width: query.width * 0.8,
                        child: Text(
                          "We'll sent an Email with 4-digit code to "+ widget.userData["data"]["email"].toString(),
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: medium,
                              color: cBlack,
                              fontWeight: FontWeight.w500,
                            height: 1.5
                          ),
                          textAlign: TextAlign.start,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: query.width / 1.75,
                height: query.height / 13,
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w500),
                  textFieldAlignment: MainAxisAlignment.spaceBetween,
                  fieldStyle: FieldStyle.box,
                  keyboardType: TextInputType.number,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                    setState(() {
                      userotp = pin;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () async {
                    print(widget.userData.toString());
                    print(userotp);
                    if(otp == userotp.toString()){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString("api_token", widget.userData["data"]["api_token"].toString());
                      prefs.setString("userEmail", widget.userData["data"]["email"].toString());
                      prefs.setString("userId", widget.userData["data"]["id"].toString());
                      prefs.setString("role_id", widget.userData["data"]["role_id"].toString());
                      prefs.setString("quickboxid", widget.userData["data"]["quickboxid"].toString());

                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: emailRegistration_signUp("","")));

                      displayToast(widget.userData["message"].toString());

                    }else{
                      displayToast("Please enter valid OTP");
                    }

                  }, "Confirm",cButtoncolor)),
              SizedBox(
                height: 25,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: TextStyle(
                          color: cBlack,
                          fontFamily: "SFPro",
                          fontSize: medium,
                          fontWeight: FontWeight.w400),
                      text: "Don't get code?",
                    ),
                    WidgetSpan(child: SizedBox(width: 5)),
                    TextSpan(
                      style: TextStyle(
                          color: cOrange,
                          fontFamily: "SFPro",
                          fontSize: medium,
                          fontWeight: FontWeight.w600),
                      text: "Resend",
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final ProgressDialog pr = _getProgress(context);
                        pr.show();

                        var url = "$url1/forgotPassword";

                        var map = new Map<String, dynamic>();
                        map["email"] = widget.userData["data"]["email"].toString();

                        final response = await http.post(Uri.parse(url), body: map);

                        final responseJson = json.decode(response.body);
                        print("forgotPassword-- " + responseJson.toString());

                        if (responseJson["status"].toString() == "success") {
                          displayToast(responseJson["data"].toString());
                          pr.hide();
                          setState(() {
                            otp = responseJson["otp"].toString();
                          });
                        } else {
                          displayToast(responseJson["data"].toString());
                          pr.hide();
                        }

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context, isDismissible: false);
}
