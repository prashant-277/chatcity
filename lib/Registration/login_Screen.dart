import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'forgotPassword.dart';

class login_Screen extends StatefulWidget {
  const login_Screen({Key key}) : super(key: key);

  @override
  _login_ScreenState createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  bool show = true;

  void onTap() {
    show = !show;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: cwhite,
        resizeToAvoidBottomInset:false,
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
                      child: basicButton(
                          cwhite, () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: dashboard_page()));
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
                    height: query.height * 0.13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              Image.asset("Assets/Icons/google.png",
                                  height: 50.sp),
                              SizedBox(width: 10.sp),
                              Image.asset("Assets/Icons/fb.png", height: 50.sp),
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
        ));
  }
}
