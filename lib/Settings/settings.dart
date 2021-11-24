import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Settings/shareApp.dart';
import 'package:chatcity/TermsofService.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'changePassword.dart';
import 'myProfile.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class settings_page extends StatefulWidget {
  const settings_page({Key key}) : super(key: key);

  @override
  _settings_pageState createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> {
  bool noti_switch = true;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final url1 = url.basicUrl;

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
        appBar: commanAppBar(
          appBar: AppBar(),
          colorImage: cwhite,
          fontsize: header,
          imageBack: false,
          appbartext: "ChatCity",
          imageIcon: Container(),
          groupImage: Container(),
          leadingIcon: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Image.asset("Assets/Icons/logo2.png"),
          ),
          widgets: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset(
                "Assets/Icons/search.png",
                width: 5.w,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: Container(
          height: query.height,
          width: query.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: query.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: gray, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Push notifications",
                            style: TextStyle(
                                fontFamily: "SFPro",
                                fontWeight: FontWeight.w600,
                                color: cBlack,
                                fontSize: medium),
                          ),
                          CupertinoSwitch(
                              value: noti_switch,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                setState(() {
                                  noti_switch = value;
                                  if (value == true) {
                                    _firebaseMessaging.subscribeToTopic("chat");
                                    displayToast("Enable Push notifications");
                                  } else {
                                    _firebaseMessaging
                                        .unsubscribeFromTopic("chat");
                                    displayToast("Disable Push notifications");
                                  }
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: myProfile()));
                    },
                    child: Container(
                      width: query.width,
                      height: query.height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: gray, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "My Profile",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: cBlack,
                                  fontSize: medium),
                            ),
                            Image.asset(
                              "Assets/Icons/right.png",
                              height: 2.0.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: shareApp()));
                    },
                    child: Container(
                      width: query.width,
                      height: query.height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: gray, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Share App",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: cBlack,
                                  fontSize: medium),
                            ),
                            Image.asset(
                              "Assets/Icons/right.png",
                              height: 2.0.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: changePassword()));
                    },
                    child: Container(
                      width: query.width,
                      height: query.height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: gray, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Change password",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: cBlack,
                                  fontSize: medium),
                            ),
                            Image.asset(
                              "Assets/Icons/right.png",
                              height: 2.0.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: TermsofService()));
                    },
                    child: Container(
                      width: query.width,
                      height: query.height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(color: gray, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Terms & conditions",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: cBlack,
                                  fontSize: medium),
                            ),
                            Image.asset(
                              "Assets/Icons/right.png",
                              height: 2.0.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: query.height * 0.07,
                    width: query.width,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: cRed,
                        onPressed: () async {
                          logout();
                        },
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cwhite,
                              fontSize: medium),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/logout";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res logout  " + responseJson.toString());

    if (responseJson["message"].toString() == "Logged Out") {
      try {
        await QB.auth.logout();
        print("logout");
      } on PlatformException catch (e) {
        print("fail");
      }

      facebookSignIn.logOut();

      _googleSignIn.signOut();
      _googleSignIn.disconnect();
      _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("api_token");
      prefs.remove("quickboxid");
      prefs.remove("userId");
      prefs.remove("userEmail");
      prefs.remove("username");
      // prefs.setString("api_token", "");
      pr.hide();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => login_Screen("close"),
        ),
        (Route route) => false,
      );
    }
  }
}

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}
