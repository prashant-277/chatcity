import 'package:chatcity/Explore/Explore_page.dart';
import 'package:chatcity/Request/requestPage.dart';
import 'package:chatcity/Settings/settings.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'All Rooms/allRooms_page.dart';
import 'CreateRooms/createRoom_Dialog.dart';
import 'data_holder.dart';

class dashboard_page extends StatefulWidget {
  const dashboard_page({Key key}) : super(key: key);

  @override
  _dashboard_pageState createState() => _dashboard_pageState();
}

class _dashboard_pageState extends State<dashboard_page> {
  int index = 0;


  @override
  void initState() {
    super.initState();
    init();


  }

  void init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
      login();
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }
  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      QBLoginResult result = await QB.auth
          .login(prefs.getString("userEmail").toString(), USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      print("user id login"+qbUser.id.toString());
      connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat.connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);

      print(int.parse(prefs.getString("quickboxid")));
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cwhite,
      floatingActionButton: Container(
        height: 55.sp,
        width: 55.sp,
        decoration: BoxDecoration(
            color: cwhite,
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: new RawMaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    actionsPadding: EdgeInsets.zero,
                    insetPadding: EdgeInsets.all(30.0),
                    contentPadding: EdgeInsets.all(0),
                    backgroundColor: cwhite,
                    content: createRoom_Dialog()));
          },
          shape: new CircleBorder(),
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              index == 2
                  ? 'Assets/Icons/create.png'
                  : "Assets/Icons/create.png",
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        index: index,
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(enabled: index == 0, child: Explore_page()),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(enabled: index == 1, child: allRooms_page()),
          ),
          /*new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 2,
              child: Container(
                color: cFacebook,
              ),
            ),
          ),*/
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 2,
              child: requestPage()
            ),
          ),
          new Offstage(
            offstage: index != 3,
            child: new TickerMode(
              enabled: index == 3,
              child: settings_page()
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        //enableFeedback: false,
        backgroundColor: cwhite,
        selectedFontSize: 15.sp,
        unselectedFontSize: 15.sp,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            this.index = i;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Container(
                child: new Image.asset(
                  index == 0
                      ? 'Assets/Icons/explore_act.png'
                      : "Assets/Icons/explore.png",
                  width: 8.w,
                ),
              ),
              onPressed: null,
            ),
            title: Text(
              "Explore",
              style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: small,
                  fontWeight: FontWeight.w500,
                  color: index == 0 ? cfooterpurple : cGray),
            ),
          ),
          new BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: IconButton(
                icon: Container(
                  child: new Image.asset(
                    index == 1
                        ? 'Assets/Icons/all_rooms_act.png'
                        : "Assets/Icons/all_rooms.png",
                    width: 8.w,
                  ),
                ),
                onPressed: null,
              ),
            ),
            title: Row(
              children: [
                Text(
                  "All Rooms",
                  style: TextStyle(
                      fontSize: small,
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w500,
                      color: index == 1 ? cfooterpurple : cGray),
                ),
              ],
            ),
          ),
          /*new BottomNavigationBarItem(
            icon: IconButton(
              icon: Container(),
              onPressed: null,
            ),
            title: Text(
              "Create",
              style: TextStyle(
                  fontSize: small,
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.w500,
                  color: index == 2 ? cfooterpurple : cGray),
            ),
          ),*/
          new BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: IconButton(
                icon: Container(
                  child: new Image.asset(
                    index == 2
                        ? 'Assets/Icons/requests_Act.png'
                        : "Assets/Icons/requests.png",
                    width: 8.w,
                  ),
                ),
                onPressed: null,
              ),
            ),
            title: Text(
              "Request",
              style: TextStyle(
                  fontSize: small,
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.w500,
                  color: index == 2 ? cfooterpurple : cGray),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: IconButton(
                icon: Container(
                  child: new Image.asset(
                    index == 3
                        ? 'Assets/Icons/settings_act.png'
                        : "Assets/Icons/settings.png",
                    width: 8.w,
                  ),
                ),
                onPressed: null,
              ),
            ),
            title: Text(
              "Settings",
              style: TextStyle(
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.w500,
                  fontSize: small,
                  color: index == 3 ? cfooterpurple : cGray),
            ),
          ),
        ],
      ),
    );
    /*Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Container(
                    height: 55.sp,
                    width: 55.sp,
                    decoration: BoxDecoration(
                        color: cwhite,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: new RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          index = 2;
                        });
                      },
                      shape: new CircleBorder(),
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          index == 2
                              ? 'Assets/Icons/create1.png'
                              : "Assets/Icons/create1.png",
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: Text(
                      "Create",
                      style: TextStyle(
                          fontSize: small,
                          fontFamily: "SFPro",
                          fontWeight: FontWeight.w500,
                          color: index == 2 ? cfooterpurple : cGray),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            )),*/
  }
}
