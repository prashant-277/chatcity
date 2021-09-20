import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/credentials.dart';
import 'package:chatcity/dashboard_page.dart';
import 'package:chatcity/data_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'forgotPassword.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class login_Screen extends StatefulWidget {
  const login_Screen({Key key}) : super(key: key);

  @override
  _login_ScreenState createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  bool show = true;
  final _formKey = GlobalKey<FormState>();
  final url1 = url.basicUrl;
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  void onTap() {
    show = !show;
    setState(() {});
  }

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
        body: SingleChildScrollView(
          child: Container(
            height: query.height / 1.16,
            width: query.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: 1,
                              fontFamily: "SFPro",
                              fontSize: header)),
                    ),
                    SizedBox(height: 20.sp),
                    textfield(
                      controller: username_controller,
                      obscureText: false,
                      hintText: "User name or Email",
                      functionValidate: commonValidation,
                      textcapitalization: TextCapitalization.none,
                      suffixIcon: null,
                      prefixIcon: new IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/user.png',
                          width: 15.sp,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter Email/User Name",
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10.sp),
                    textfield(
                      controller: password_controller,
                      obscureText: show,
                      hintText: "Password",
                      functionValidate: commonValidation,
                      textcapitalization: TextCapitalization.none,
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
                      prefixIcon: IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/password.png',
                          width: 15.sp,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter Password",
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: 25.sp),
                    Container(
                        width: 90.w,
                        height: 7.5.h,
                        child: basicButton(cwhite, () async {
                          if (_formKey.currentState.validate()) {

                            final ProgressDialog pr = _getProgress(context);
                            pr.show();

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var url = "$url1/login";

                            var map = new Map<String, dynamic>();
                            map["username"] =
                                username_controller.text.toString();
                            map["password"] =
                                password_controller.text.toString();

                            final response = await http.post(url, body: map);

                            final responseJson = json.decode(response.body);
                            print("login-- " +
                                responseJson.toString());

                            if (responseJson["status"].toString() == "success") {
                              login();
                              prefs.setString("api_token",
                                  responseJson["data"]["api_token"].toString());
                              prefs.setString("username",
                                  responseJson["data"]["username"].toString());
                              prefs.setString("userId",
                                  responseJson["data"]["id"].toString());
                              prefs.setString("userEmail",
                                  responseJson["data"]["email"].toString());
                              prefs.setString("quickboxid",
                                  responseJson["data"]["quickboxid"].toString());
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      alignment: Alignment.bottomCenter,
                                      duration: Duration(milliseconds: 300),
                                      child: dashboard_page()));

                              displayToast(responseJson["message"].toString());

                            } else {
                              pr.hide();
                              displayToast(responseJson["message"].toString());
                            }
                          } else {
                            displayToast("Enter valid data");
                          }
                        }, "Login", cButtoncolor)),
                    SizedBox(height: 10.sp),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: forgotPassword()));
                      },
                      child: Text("Forgot password?",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 2,
                              color: cBlack,
                              fontFamily: "SFPro",
                              fontSize: medium)),
                    ),
                    SizedBox(height: 40.sp),
                    Container(
                      height: query.height * 0.16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Image.asset(
                              "Assets/Icons/loginwith.png",
                              height: 15.sp,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("Assets/Icons/google.png",
                                    height: 50.sp),
                                SizedBox(width: 10.sp),
                                Image.asset("Assets/Icons/fb.png",
                                    height: 50.sp),
                                SizedBox(width: 10.sp),
                                Image.asset("Assets/Icons/apple.png",
                                    height: 50.sp),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text("")
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> login() async {
    try {
      QBLoginResult result = await QB.auth
          .login(username_controller.text.toString(), USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      print(qbUser.id.toString());
      connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void connect() async {
    final ProgressDialog pr = _getProgress(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat.connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);

      pr.hide();
      print(int.parse(prefs.getString("quickboxid")));

    } on PlatformException catch (e) {
      print(e.message);
    }
  }

}
ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}