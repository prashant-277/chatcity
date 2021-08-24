import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class friend_invitePage extends StatefulWidget {
  const friend_invitePage({Key key}) : super(key: key);

  @override
  _friend_invitePageState createState() => _friend_invitePageState();
}

class _friend_invitePageState extends State<friend_invitePage> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: cwhite,
        floatingActionButton: FloatingActionButton(
          child: Image.asset("Assets/Icons/create1.png"),
          elevation: 0,
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    alignment: Alignment.bottomCenter,
                    duration: Duration(milliseconds: 300),
                    child: chat_page()));
          },
        ),
        appBar: commanAppBar(
          appBar: AppBar(),
          fontsize: medium,
          appbartext: "Invite your friend",
          imageBack: true,
          colorImage: cwhite,
          groupImage: Container(),
          imageIcon: Container(),
          widgets: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "Assets/Icons/search.png",
                    width: 5.w,
                  )),
            )
          ],
        ),
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: cwhite,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                Text("2 of 147 selected",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 12.sp,
                      color: cBlack,
                      fontWeight: FontWeight.w400,
                    )),
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
                return ListTile(
                  selected: select,
                  selectedTileColor: Color(0xFFD1C4E9),
                  tileColor: cwhite,
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    setState(() {
                      if (select == false) {
                        select = true;
                      } else {
                        select = false;
                      }
                    });
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("London boys",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: medium,
                              color: cBlack,
                              fontWeight: FontWeight.w400,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: select
                              ? Image.asset("Assets/Icons/selected.png",
                                  width: 16.sp)
                              : Container(),
                        )
                      ],
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Image.asset("Assets/Icons/img5.png", width: 10.w),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
