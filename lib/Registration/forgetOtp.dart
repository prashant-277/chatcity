import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Registration/resetPassword.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sizer/sizer.dart';

class forgetOtp extends StatefulWidget {
  var emailotp;

  var otpData;

  forgetOtp(this.emailotp, this.otpData);

  @override
  _forgetOtpState createState() => _forgetOtpState();
}

class _forgetOtpState extends State<forgetOtp> {
  var userotp;
  final url1 = url.basicUrl;

  String otp;

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
  void initState() {
    super.initState();
    otp = widget.otpData["otp"].toString();
  }
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: cwhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: cwhite,
          elevation: 0,
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
                            "We'll sent an Email with 4-digit code to " +
                                widget.emailotp.toString(),
                            style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: medium,
                                color: cBlack,
                                fontWeight: FontWeight.w500,
                                height: 1.5),
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
                      print(userotp);
                      if (otp ==userotp.toString()) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                resetPassword(widget.emailotp),
                          ),
                          (Route route) => false,
                        );
                        displayToast("OTP Verified...");
                      } else {
                        displayToast("Please enter valid OTP");
                      }
                    }, "Confirm", cButtoncolor)),
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
                          map["email"] = widget.emailotp.toString();

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
      ),
    );
  }
}
ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context, isDismissible: false);
}
