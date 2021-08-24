import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../constants.dart';
import 'package:sizer/sizer.dart';

class requestPage extends StatefulWidget {
  const requestPage({Key key}) : super(key: key);

  @override
  _requestPageState createState() => _requestPageState();
}

class _requestPageState extends State<requestPage> {
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
                        child: Text("My friends",
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
                        child: Text("Join invitation",
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
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {},
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("London boys",
                                      style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontSize: medium,
                                        color: cBlack,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  FlatButton(
                                    height: 23.sp,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: cChatbackground,
                                    onPressed: () {},
                                    child: Text("Unfriend",
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: small,
                                          color: cBlack,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ],
                              ),
                              leading: Image.asset("Assets/Icons/img5.png",
                                  width: 30.sp),
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
                            padding: const EdgeInsets.all(8.0),
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
                                            fontWeight: FontWeight.w400,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                            "Assets/Icons/private.png",
                                            color: cfooterGray,
                                            height: 2.h),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                            "Assets/Icons/reject.png",
                                            width: 20.sp),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                            "Assets/Icons/accept.png",
                                            width: 20.sp),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              leading: Image.asset("Assets/Icons/img5.png",
                                  width: 30.sp),
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