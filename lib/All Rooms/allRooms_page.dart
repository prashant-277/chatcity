import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import 'package:sizer/sizer.dart';

class allRooms_page extends StatefulWidget {
  const allRooms_page({Key key}) : super(key: key);

  @override
  _allRooms_pageState createState() => _allRooms_pageState();
}

class _allRooms_pageState extends State<allRooms_page> {
  int current_tab = 0;

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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: 7.h,
              color: cwhite,
              child: TabBar(
                automaticIndicatorColorAdjustment: true,
                labelPadding: EdgeInsets.zero,
                indicatorColor: cfooterpurple,
                indicatorWeight: 1.0,
                onTap: (page) {
                  print(page);
                  setState(() {
                    current_tab = page;
                  });
                },
                tabs: [
                  Container(
                    padding: EdgeInsets.zero,
                    width: query.width,
                    color: cwhite,
                    child: Tab(
                        child: Text("My rooms",
                            style: TextStyle(
                                fontFamily: "SFPro",
                                fontWeight: FontWeight.w600,
                                color: current_tab == 0 ? cBlack : cGray,
                                fontSize: medium))),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    width: query.width,
                    color: cwhite,
                    child: Tab(
                        child: Text("Joined rooms",
                            style: TextStyle(
                                fontFamily: "SFPro",
                                fontWeight: FontWeight.w600,
                                color: current_tab == 1 ? cBlack : cGray,
                                fontSize: medium))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () {},
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("London boys",
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: medium,
                                            color: cBlack,
                                            fontWeight: FontWeight.w600,
                                          )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                            "Assets/Icons/public.png",
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
                              leading: Image.asset("Assets/Icons/img5.png",
                                  width: 50.sp),
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
                  Container(
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () {},
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        child: Image.asset(
                                            "Assets/Icons/public.png",
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
                              leading: Image.asset("Assets/Icons/img5.png",
                                  width: 50.sp),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
