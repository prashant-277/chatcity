import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Explore/filter_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class Explore_page extends StatefulWidget {
  const Explore_page({Key key}) : super(key: key);

  @override
  _Explore_pageState createState() => _Explore_pageState();
}

class _Explore_pageState extends State<Explore_page> {
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
        body: Scaffold(
          backgroundColor: cwhite,
          appBar: AppBar(
            backgroundColor: cwhite,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore rooms",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: medium,
                    color: cBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: cButtoncolor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 300),
                              child: filter_page()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Filter",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: medium,
                            color: cwhite,
                            fontWeight: FontWeight.w400,
                          )),
                    ))
              ],
            ),
          ),
          body: Container(
            height: query.height,
            width: query.width,
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: chat_page()));
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("London boys",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: medium,
                                    color: cBlack,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("Assets/Icons/public.png",
                                    height: 2.h),
                              ),
                            ],
                          ),
                          Text("Time",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: small,
                                color: cGray,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      leading: Image.asset("Assets/Icons/img5.png", width: 50.sp),
                      subtitle: Text("Hi, Julian! see you after work?",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: small,
                            color: cGray,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  );
                }),
          ),
        ));
  }
}
