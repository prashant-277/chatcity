import 'dart:io';
import 'package:chatcity/Explore/Explore_page.dart';
import 'package:chatcity/Request/requestPage.dart';
import 'package:chatcity/Settings/settings.dart';
import 'package:chatcity/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/push/constants.dart';
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
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var device_token;
  int _id;

  @override
  void initState() {
    super.initState();
    init();

    firebaseCloudMessaging_Listeners();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: selectNotification);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
      login();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userEmail").toString());
    print(int.parse(prefs.getString("quickboxid")));
    print(USER_PASSWORD);

    try {
      QBLoginResult result = await QB.auth
          .login(prefs.getString("userEmail").toString(), USER_PASSWORD);


      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      print("user id login " + qbUser.id.toString());
      connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await QB.chat
          .connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);
      print("+++++ " + int.parse(prefs.getString("quickboxid")).toString());
      createPushSubscription();
    } on PlatformException catch (e) {
      print("=== " + e.toString());
      createPushSubscription();
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
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(enabled: index == 2, child: requestPage()),
          ),
          new Offstage(
            offstage: index != 3,
            child: new TickerMode(enabled: index == 3, child: settings_page()),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
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
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Platform.isIOS) iOS_Permission();

    //if (Platform.isAndroid) Android_Permission();

    _firebaseMessaging.getToken().then((token) {
      setState(() {
        device_token = token;
        print("fcm token  " + device_token);
        prefs.setString("fcmToken", device_token.toString());
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message ==== $message');
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  /* void Android_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }*/

  Future<void> createPushSubscription() async {
    try {
      List<QBSubscription> subscriptions =
          await QB.subscriptions.create(device_token, QBPushChannelNames.GCM);

      int length = subscriptions.length;

      if (length > 0) {
        _id = subscriptions[0].id;
      }
      print("Subscription ------- ");
    } on PlatformException catch (e) {
      print("Subscription error ---- " + e.toString());
    }
  }

  void showNotification(Map<String, dynamic> msg) async {
    //{notification: {title: title, body: test}, data: {notification_type: Welcome, body: body, badge: 1, sound: , title: farhana mam, click_action: FLUTTER_NOTIFICATION_CLICK, message: H R U, category_id: 2, product_id: 1, img_url: }}
    print(msg);
    print(msg['notification']);
    var title = msg['notification']['title'];
    var msge = msg['notification']['body'];

    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, msge, platform,
        payload: msge);
  }

  Future selectNotification(String payload) async {
    debugPrint("payload : $payload");
    if (payload != null) {
      debugPrint('notification payload:------ ${payload}');
      await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => dashboard_page()),
      ).then((value) {});
    }
  }
}
