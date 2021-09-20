import 'package:chatcity/Explore/roomInfo_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
  }

  List message = [];

  @override
  void initState() {
    super.initState();
    print("hhhh ----- " + widget.roomData.toString());
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: cChatbackground,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageBack: true,
        colorImage: cwhite,
        appbartext: widget.roomData["name"].toString(),
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
                            child: roomInfo_page(widget.roomData["id"])));
                  },
                  icon: Image.asset("Assets/Icons/info.png", width: 6.w))),
        ],
      ),
      body: Container(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: message.length,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            return Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              child: Align(
                alignment: (message[index]["receiver"] == "1"
                    ? Alignment.topRight
                    : Alignment.topLeft),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    gradient: message[index]["receiver"] == "1"
                        ? LinearGradient(
                            colors: [Color(0xff382177), Color(0xff9760A4)])
                        : LinearGradient(colors: [cfooterGray, cfooterGray]),
//                    color: message[index]["receiver"]=="1"? Colors.red:Colors.cyan
                    //0xff382177 (Dark) to 0xff9760A4 (Light)
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    message[index]["message"].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
          color: cwhite,
          height: 60.sp,
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
                    style: TextStyle(
                        fontFamily: "SFPro", color: cBlack, fontSize: medium),
                    textCapitalization: TextCapitalization.words,
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
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    setState(() {
                      message.add({
                        "message": chat_controller.text.toString(),
                        "receiver": 1
                      });
                      print(message);
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

    String messageBody =
        "Hello from flutter prashant" + "\n From user: " + LOGGED_USER_ID.toString();
    await QB.chat.joinDialog(prefs.getString("_dialogId").toString());

    try {
      Map<String, String> properties = Map();
      properties["testProperty1"] = "testPropertyValue1";
      properties["testProperty2"] = "testPropertyValue2";
      properties["testProperty3"] = "testPropertyValue3";
      print(prefs.getString("_dialogId").toString());
      await QB.chat.sendMessage(prefs.getString("_dialogId").toString(),
          body: chat_controller.text.toString(), saveToHistory: true, properties: properties);
    } on PlatformException catch (e) {
      print("e");
    }
  }
  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      connected==true? sendMessage(): connect();
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat.connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);
      sendMessage();
      print("id ---- "+  int.parse(prefs.getString("quickboxid")).toString());
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
