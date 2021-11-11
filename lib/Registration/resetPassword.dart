import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class resetPassword extends StatefulWidget {
  var emailotp;

  resetPassword(this.emailotp);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pswdCtrl = TextEditingController();
  TextEditingController _confirmpswdCtrl = TextEditingController();

  final url1 = url.basicUrl;

  String password = '';
  String conffirmpassword = '';

  bool show = true;
  bool confirmshow = true;

  void onTap() {
    show = !show;
    setState(() {});
  }

  void onTap1() {
    confirmshow = !confirmshow;
    setState(() {});
  }

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: cwhite,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text("Reset password",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "SFPro",
                              height: 1,
                              fontSize: header)),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 260.sp,
                          child: TextFormField(
                            controller: _pswdCtrl,
                            textAlign: TextAlign.start,
                            obscureText: show,
                            validator: (value) => value.isEmpty
                                ? 'Please enter new password'
                                : null,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                            style:
                                TextStyle(fontFamily: "SFPro", color: cBlack),
                            maxLines: 1,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                icon: !show
                                    ? Image.asset(
                                        'Assets/Icons/visible.png',
                                        width: 18.sp,
                                      )
                                    : Image.asset(
                                        'Assets/Icons/invisible.png',
                                        width: 18.sp,
                                      ),
                                onPressed: () {
                                  onTap();
                                },
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 20.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: cChatbackground, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: cChatbackground, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: gray,
                                  width: 1.0,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "SFPro",
                                  fontSize: medium),
                              filled: true,
                              fillColor: cwhite,
                              hintText: 'New password',
                              prefixIcon: new IconButton(
                                icon: new Image.asset(
                                  'Assets/Icons/password.png',
                                  width: 15.sp,
                                  color: cBlack,
                                ),
                                onPressed: null,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 260.sp,
                          child: TextFormField(
                            controller: _confirmpswdCtrl,
                            textAlign: TextAlign.start,
                            obscureText: confirmshow,
                            validator: (value) => value.isEmpty
                                ? 'Please enter confirm password'
                                : null,
                            onChanged: (value) {
                              setState(() => conffirmpassword = value);
                            },
                            style:
                                TextStyle(fontFamily: "SFPro", color: cBlack),
                            maxLines: 1,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                color: Colors.grey,
                                icon: !confirmshow
                                    ? Image.asset(
                                        'Assets/Icons/visible.png',
                                        width: 18.sp,
                                      )
                                    : Image.asset(
                                        'Assets/Icons/invisible.png',
                                        width: 18.sp,
                                      ),
                                onPressed: () {
                                  onTap1();
                                },
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 20.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: cChatbackground, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: cChatbackground, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: gray,
                                  width: 1.0,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "SFPro",
                                  fontSize: medium),
                              filled: true,
                              fillColor: cwhite,
                              hintText: 'Confirm password',
                              prefixIcon: new IconButton(
                                icon: new Image.asset(
                                  'Assets/Icons/password.png',
                                  width: 15.sp,
                                  color: cBlack,
                                ),
                                onPressed: null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 25),
                Container(
                    width: 90.w,
                    height: 7.5.h,
                    child: basicButton(cwhite, () async {
                      if (_formKey.currentState.validate()) {
                        if (_pswdCtrl.text.toString() ==
                            _confirmpswdCtrl.text.toString()) {
                          final ProgressDialog pr = _getProgress(context);
                          pr.show();

                          var url = "$url1/changepassword";

                          var map = new Map<String, dynamic>();
                          map["email"] = widget.emailotp.toString();
                          map["password"] = _confirmpswdCtrl.text.toString();

                          final response = await http.post(url, body: map);

                          final responseJson = json.decode(response.body);
                          print("forgotPassword-- " + responseJson.toString());

                          if (responseJson["status"].toString() == "success") {
                            displayToast(responseJson["message"].toString());
                            pr.hide();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    login_Screen("close"),
                              ),
                              (Route route) => false,
                            );
                          } else {
                            displayToast(responseJson["message"].toString());
                            pr.hide();
                          }
                        } else {
                          displayToast("Password does not matched");
                        }
                      }
                    }, "Reset", cButtoncolor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}
