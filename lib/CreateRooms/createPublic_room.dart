import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class createPublic_room extends StatefulWidget {
  const createPublic_room({Key key}) : super(key: key);

  @override
  _createPublic_roomState createState() => _createPublic_roomState();
}

class _createPublic_roomState extends State<createPublic_room> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commanAppBar(
        appBar: AppBar(),
        imageIcon: Container(),
        groupImage: Container(),
        imageBack: true,
        colorImage: cwhite,
        appbartext: "Create public room",
        fontsize: medium,
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "Assets/Icons/placeholder.png",
                    height: 15.h,
                  ),

                  SizedBox(height: 3.h),
                  Column(
                    children: [
                      textfield(
                        obscureText: false,
                        hintText: "Group name",
                        textInputType: TextInputType.text,
                        textcapitalization: TextCapitalization.words,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 15),
                        child: Row(
                          children: [
                            Text("Provide a room subject and room icon.",
                                style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontWeight: FontWeight.w500,
                                    color: cBlack,
                                    fontSize: small)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
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
                                child: chat_page()));
                      }, "Create", cButtoncolor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
