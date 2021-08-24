import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class shareApp extends StatefulWidget {
  const shareApp({Key key}) : super(key: key);

  @override
  _shareAppState createState() => _shareAppState();
}

class _shareAppState extends State<shareApp> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: commanAppBar(
        appBar: AppBar(),
        fontsize: medium,
        appbartext: "Share App",
        imageBack: true,
        colorImage: cwhite,
        imageIcon: Container(),
        groupImage: Container(),
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Image.asset(
                "Assets/Icons/illustrator.png",
                height: 30.h,
              ),
              SizedBox(height: 5.h),
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(10.0)),
                width: query.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Text(
                        "Share App with friends",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.w600,
                            color: cBlack,
                            fontSize: medium),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Want to share your applications with friends ? Application Share makes it easy to share application links and apks",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.w400,
                            color: cBlack,
                            fontSize: 12.sp,
                            height: 1.0.sp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          width: 90.w,
                          height: 7.5.h,
                          child: basicButton(cwhite, () {
                            Share.share(
                                'check share',
                                subject: 'Sharing on Email');
                          }, "Share", cButtoncolor)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
