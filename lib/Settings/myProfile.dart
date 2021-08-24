import 'package:chatcity/Settings/edit_Profile.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class myProfile extends StatefulWidget {
  const myProfile({Key key}) : super(key: key);

  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commanAppBar(
        appBar: AppBar(),
        groupImage: Container(),
        imageIcon: Container(),
        colorImage: cwhite,
        imageBack: true,
        appbartext: "My Profile",
        fontsize: medium,
      ),
      backgroundColor: cwhite,
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "Assets/Icons/img5.png",
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("London Boys",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w600,
                        color: cBlack,
                        fontSize: header)),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text("Personal info",
                      style: TextStyle(
                          fontFamily: "SFPro",
                          fontWeight: FontWeight.w600,
                          color: cBlack,
                          fontSize: medium)),
                ],
              ),
              SizedBox(height: 1.5.h),
              Container(
                height: 45.sp,
                width: query.width,
                decoration: BoxDecoration(
                    color: cChatbackground,
                    border: Border.all(color: gray, width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Image.asset(
                        "Assets/Icons/email.png",
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text("prashan@gmail.com",
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 45.sp,
                width: query.width,
                decoration: BoxDecoration(
                    color: cChatbackground,
                    border: Border.all(color: gray, width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Image.asset(
                        "Assets/Icons/phone.png",
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text("+1 01234567890",
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 45.sp,
                width: query.width,
                decoration: BoxDecoration(
                    color: cChatbackground,
                    border: Border.all(color: gray, width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Image.asset(
                        "Assets/Icons/dob.png",
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text("20-05-1989",
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
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
                            child: edit_Profile()));
                  }, "Edit Profile", cButtoncolor)),
            ],
          ),
        ),
      ),
    );
  }
}
