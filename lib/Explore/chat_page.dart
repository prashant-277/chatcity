import 'dart:async';
import 'dart:convert';
import 'package:chatcity/Explore/roomInfo_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class chat_page extends StatefulWidget {
  var roomData;

  chat_page(this.roomData);

  @override
  _chat_pageState createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  TextEditingController chat_controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    setState(() {
      count = 1;
    });
  }

  final url1 = url.basicUrl;
  int count = 0;

  List message = [];
  List userList = [];
  var occupantsId = [];
  String chatmessage, imgUrl = "";
  String userId, _messageId;
  bool _isLoading = true;
  int _id;
  int _id1;
  DateTime now = DateTime.now();
  Timer mytimer;

  @override
  void initState() {
    super.initState();
    print("hhhh ----- " + widget.roomData.toString());
    mytimer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      getRoomInfo();
    });
    getuserId();
    getDialogMessages();
    //createPushSubscription();
  }

  @override
  void dispose() {
    if (mytimer != null) {
      mytimer.cancel();
      mytimer = null;
    }
    super.dispose();
  }

  getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("quickboxid").toString();
    });
  }

  Future<List> getDialogMessages() async {
    QBSort sort = QBSort();
    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
    sort.ascending = true;

    try {
      List<QBMessage> messages = await QB.chat
          .getDialogMessages(widget.roomData["dialogId"].toString());
      int countMessages = messages.length;

      if (countMessages > 0) {
        _messageId = messages[0].id;
      }
      setState(() {
        _isLoading = false;
      });

      return messages;
    } on PlatformException catch (e) {}
  }

  Future<void> getRoomInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "$url1/showRoomDetails";
    if (userList == []) {
      print(prefs.getString("userId").toString());
      var map = new Map<String, dynamic>();
      map["userid"] = prefs.getString("userId").toString();
      map["room_id"] = widget.roomData["id"].toString();

      Map<String, String> headers = {
        "API-token": prefs.getString("api_token").toString()
      };

      final response = await http.post(Uri.parse(url), body: map, headers: headers);
      final responseJson = json.decode(response.body);
      print("res showRoomDetails  " + responseJson.toString());
      print("res showRoomDetails occupantsId " +
          responseJson["data"]["occupantsId"][0]);

      setState(() {
        userList = responseJson["data"]["users"];
        occupantsId = responseJson["data"]["occupantsId"];
        _isLoading = false;
      });
    }
    /*else{
      if(userList.length==occupantsId.length+1){
        print("DOne---");
        print("DOne---" + occupantsId.length.toString());
      }*/
    else {
      var map = new Map<String, dynamic>();
      map["userid"] = prefs.getString("userId").toString();
      map["room_id"] = widget.roomData["id"].toString();

      Map<String, String> headers = {
        "API-token": prefs.getString("api_token").toString()
      };

      final response = await http.post(Uri.parse(url), body: map, headers: headers);
      final responseJson = json.decode(response.body);
      print("res showRoomDetails  " + responseJson.toString());

      setState(() {
        userList = responseJson["data"]["users"];
        occupantsId = responseJson["data"]["occupantsId"];
        _isLoading = false;
      });
      print("DOne---else " + occupantsId.length.toString());
    }
  }

  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cChatbackground,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageBack: true,
        colorImage: cwhite,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 300),
                  child: roomInfo_page(
                      widget.roomData["id"], widget.roomData["dialogId"])));
        },
        appbartext: widget.roomData["name"].toString().length <= 15
            ? widget.roomData["name"].toString()
            : widget.roomData["name"].toString().substring(0, 15) + "...",
        groupImage: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  image: NetworkImage(widget.roomData["image"].toString()),
                  fit: BoxFit.cover,
                  width: 20.sp,
                  height: 20.sp,
                  placeholder: AssetImage("Assets/Images/giphy.gif"))),
        ),
        imageIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            widget.roomData["type"].toString() == "0"
                ? "Assets/Icons/public.png"
                : "Assets/Icons/private.png",
            height: 2.h,
            color: cwhite,
          ),
        ),
        fontsize: medium,
        widgets: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: roomInfo_page(widget.roomData["id"],
                                widget.roomData["dialogId"])));
                  },
                  icon: Image.asset("Assets/Icons/info.png", width: 6.w))),
        ],
      ),
      body: Container(
          child: _isLoading == true
              ? SpinKitRipple(color: cfooterpurple)
              : StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1))
                      .asyncMap((i) => getDialogMessages()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (count == 0) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length,
                        padding: EdgeInsets.only(top: 5, bottom: 75),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 13, right: 13, top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment:
                                  snapshot.data[index].senderId.toString() ==
                                          userId.toString()
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.data[index].senderId.toString() ==
                                        userId.toString()
                                    ? Text("")
                                    : get_Image(snapshot.data[index].senderId
                                        .toString()),
                                /*ClipRRect(
                            borderRadius:
                            BorderRadius.circular(100.0),
                            child: FadeInImage(
                                image: NetworkImage(imgUrl),
                                fit: BoxFit.fill,
                                width: 18.sp,
                                height: 18.sp,
                                placeholder: AssetImage(
                                    "Assets/Images/giphy.gif"))),*/

                                SizedBox(
                                  width: 2.w,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: snapshot.data[index].senderId
                                                .toString() ==
                                            userId.toString()
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(1))
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topLeft: Radius.circular(1),
                                            topRight: Radius.circular(15)),
                                    gradient: snapshot.data[index].senderId
                                                .toString() ==
                                            userId.toString()
                                        ? LinearGradient(colors: [
                                            Color(0xff382177),
                                            Color(0xff9760A4)
                                          ])
                                        : LinearGradient(colors: [gray, gray]),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    snapshot.data[index].body.toString(),
                                    style: TextStyle(
                                        fontSize: small,
                                        color: snapshot.data[index].senderId
                                                    .toString() ==
                                                userId.toString()
                                            ? cwhite
                                            : cBlack),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                        child: Text(
                      "No messages...",
                      style: TextStyle(
                          color: cBlack, fontFamily: "SFPro", fontSize: medium),
                    ));
                  })),
      bottomSheet: Container(
          color: cwhite,
          height: 55.sp,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.25,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
                  height: 35.sp,
                  child: TextField(
                    controller: chat_controller,
                    onChanged: (value) {
                      setState(() {
                        chatmessage = value;
                      });
                    },
                    style: TextStyle(
                        fontFamily: "SFPro", color: cBlack, fontSize: medium),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:
                              BorderSide(color: cChatbackground, width: 1)),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide:
                              BorderSide(color: cChatbackground, width: 1)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: cChatbackground,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                          color: cGray, fontFamily: "SFPro", fontSize: medium),
                      hintText: "Type a Message...",
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: chat_controller.text.length == 0
                      ? () {}
                      : () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          setState(() {
                            chat_controller.clear();
                          });
                          isConnected();
                        },
                  child: Image.asset(
                    "Assets/Icons/send.png",
                    height: 5.0.h,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map<String, String> properties = Map();
      properties["testProperty1"] = "testPropertyValue1";
      properties["testProperty2"] = "testPropertyValue2";
      properties["testProperty3"] = "testPropertyValue3";
      print(prefs.getString("_dialogId").toString());

      await QB.chat.sendMessage(widget.roomData["dialogId"],
          body: chatmessage, saveToHistory: true, properties: properties);
      print("rec -------------");
      count = 0;
      //createNotification();
      saveLastMessage();
    } on PlatformException catch (e) {
      print("send " + e.toString());
      displayToast("Message not sent, Try after sometime");
    }
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      connected == true ? sendMessage() : connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat
          .connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);
      sendMessage();
      print("id ---- " + int.parse(prefs.getString("quickboxid")).toString());
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  /*Future<void> createNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = QBNotificationEventTypes.ONE_SHOT;
    String notificationEventType = QBNotificationTypes.PUSH;
    int pushType = QBNotificationPushTypes.GCM;
    int senderId = int.parse(prefs.getString("quickboxid"));

    Map<String, Object> payload = Map();
    payload["message"] = chatmessage.toString();
    payload["body"] = widget.roomData["name"].toString();
    payload["user_id"] = widget.roomData["name"].toString();

    try {
      List<QBEvent> qbEventsList = await QB.events
          .create(type, notificationEventType, senderId, payload);

      for (int i = 0; i < qbEventsList.length; i++) {
        QBEvent event = qbEventsList[i];
        int notificationId = event.id;
        _id = event.id;
      }
      print("Noti");
      getNotifications();
    } on PlatformException catch (e) {
      print("notification sent == " + e.toString());
    }
  }

  Future<void> getNotifications() async {
    try {
      List<QBEvent> qbEventsList = await QB.events.get();
      int count = qbEventsList.length;
    } on PlatformException catch (e) {
      print("count error === " + e.toString());
    }
  }*/

  Widget get_Image(String senderId) {
    var url;
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]["quickboxid"].toString() == senderId.toString()) {
        url = userList[i]["image"].toString();

        print("image ---- " + userList.toString());

        break;
      }
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FadeInImage(
            image: NetworkImage(url.toString() == "null"
                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                : url.toString()),
            fit: BoxFit.fill,
            width: 18.sp,
            height: 18.sp,
            placeholder: AssetImage("Assets/Images/giphy.gif")));
  }

  Future<void> saveLastMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/sendMessage";

    print(prefs.getString("userId").toString());
    print(widget.roomData["id"].toString());
    print(chatmessage.toString());
    print("sendMessage ---- " + now.toString());

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["room_id"] = widget.roomData["id"].toString();
    map["message"] = chatmessage.toString();
    map["createdTime"] = now.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(Uri.parse(url), body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res sendMessage  " + responseJson.toString());
  }

/*Future<void> createPushSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      print("device_token ==== "+ prefs.getString("fcmToken"));
      List<QBSubscription> subscriptions =
      await QB.subscriptions.create(prefs.getString("fcmToken"), QBPushChannelNames.GCM);
      int length = subscriptions.length;

      if (length > 0) {
        _id1 = subscriptions[0].id;
        prefs.setString("pushId", _id1.toString());
      }

      print("Subscription ------- " + _id1.toString());

    } on PlatformException catch (e) {
      print("Subscription error ---- " + e.toString());
    }
  }*/
}
