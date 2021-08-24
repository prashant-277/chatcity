import 'package:chatcity/Settings/shareApp.dart';
import 'package:chatcity/TermsofService.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'changePassword.dart';
import 'myProfile.dart';

class settings_page extends StatefulWidget {
  const settings_page({Key key}) : super(key: key);

  @override
  _settings_pageState createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> {
  bool noti_switch = false;

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
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
            ),
          ),
        ],
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: query.width,
                decoration: BoxDecoration(
                    border: Border.all(color: gray, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Push notification",
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
                onTap: (){
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
                onTap: (){
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
                onTap: (){
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
                onTap: (){
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
                          "Terms & condition",
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
                    onPressed: () {},
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
    );
  }
}
