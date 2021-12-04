import 'dart:convert';
import 'dart:io';
import 'package:chatcity/Explore/Explore_page.dart';
import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Registration/emailRegistration_signUp.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/dashboard_page.dart';
import 'package:chatcity/data_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

import 'forgotPassword.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class login_Screen extends StatefulWidget {
  var close;

  login_Screen(this.close);

  @override
  _login_ScreenState createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var device_token;
  var device_id;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool show = true;
  final _formKey = GlobalKey<FormState>();
  final url1 = url.basicUrl;
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  void onTap() {
    show = !show;
    setState(() {});
  }

  bool isLoggedIn = false;
  var profileData;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings(
      '@mipmap/chatcity',
    );
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
      onSelectNotification: selectNotification,
    );
    firebaseCloudMessaging_Listeners();
    //getDeviceId();
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      setState(() {
        device_token = token;
        print("fcm token  " + device_token);
        prefs.setString("fcmToken", device_token.toString());
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        showNotification(message);
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        showNotification(message);
        print('on launch $message');
      },
      onBackgroundMessage: (Map<String, dynamic> message) async {
        print('on Background $message');
        showNotification(message);
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


  void showNotification(Map<String, dynamic> msg) async {
    print(msg);
    var title = msg['title'];
    var msge = msg['body'];

    var android = new AndroidNotificationDetails(
      'fcm_default_channel',
      'channel NAME',
      'CHANNEL DESCRIPTION',
      playSound: true,
      channelShowBadge: true,
    );
    var iOS = new IOSNotificationDetails(
        presentAlert: true, presentSound: true, presentBadge: true);
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, msge, platform, payload: msge);
  }

  Future selectNotification(String payload) async {
    debugPrint("payload : $payload");
    if (payload != null) {
      debugPrint('notification payload:------ ${payload}');
      await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Explore_page()),
      ).then((value) {});
    }
  }

  /*Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      print("Device id---------" + iosDeviceInfo.identifierForVendor);
      setState(() {
        device_id = iosDeviceInfo.identifierForVendor;
        prefs.setString("deviceId", device_id);
      });
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      print("Device id---------" + androidDeviceInfo.androidId.toString());
      setState(() {
        device_id = androidDeviceInfo.androidId;
        prefs.setString("deviceId", device_id);
      });
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }*/
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: cwhite,
        resizeToAvoidBottomInset: false,
        /*appBar: BaseAppBar(
          appBar: AppBar(),
          backgroundColor: cwhite,
          appbartext: "",
          //leadingIcon: Container()
        ),*/

        appBar: widget.close == "close"
            ? AppBar(
                backgroundColor: cwhite,
                elevation: 0,
                automaticallyImplyLeading: false,
              )
            : BaseAppBar(
                appBar: AppBar(), backgroundColor: cwhite, appbartext: ""),
        body: SingleChildScrollView(
          child: Container(
            height: query.height / 1.16,
            width: query.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: 1,
                              fontFamily: "SFPro",
                              fontSize: header)),
                    ),
                    SizedBox(height: 20.sp),
                    textfield(
                      controller: username_controller,
                      obscureText: false,
                      hintText: "User name or Email",
                      functionValidate: commonValidation,
                      textcapitalization: TextCapitalization.none,
                      suffixIcon: null,
                      prefixIcon: new IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/user.png',
                          width: 15.sp,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter Email/User Name",
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10.sp),
                    textfield(
                      controller: password_controller,
                      obscureText: show,
                      hintText: "Password",
                      functionValidate: commonValidation,
                      textcapitalization: TextCapitalization.none,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: !show
                            ? Image.asset(
                                'Assets/Icons/visible.png',
                                width: 18.sp,
                              )
                            : Image.asset(
                                'Assets/Icons/invisible.png',
                                width: 18.sp,
                              ),
                        onPressed: () {
                          onTap();
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/password.png',
                          width: 15.sp,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter Password",
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: 25.sp),
                    Container(
                        width: 90.w,
                        height: 7.5.h,
                        child: basicButton(cwhite, () async {
                          if (_formKey.currentState.validate()) {
                            final ProgressDialog pr = _getProgress(context);
                            pr.show();

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var url = "$url1/login";

                            var map = new Map<String, dynamic>();
                            map["username"] =
                                username_controller.text.toString();
                            map["password"] =
                                password_controller.text.toString();
                            map["fcm_token"] = device_token.toString();
                            map["device_type"] =
                                Platform.isAndroid ? "android" : "ios";

                            final response = await http.post(Uri.parse(url), body: map);

                            final responseJson = json.decode(response.body);
                            print("login-- " + responseJson.toString());

                            if (responseJson["status"].toString() ==
                                "success") {
                              login();
                              prefs.setString("api_token",
                                  responseJson["data"]["api_token"].toString());
                              prefs.setString("username",
                                  responseJson["data"]["username"].toString());
                              prefs.setString("userId",
                                  responseJson["data"]["id"].toString());
                              prefs.setString("userEmail",
                                  responseJson["data"]["email"].toString());
                              prefs.setString(
                                  "quickboxid",
                                  responseJson["data"]["quickboxid"]
                                      .toString());
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      alignment: Alignment.bottomCenter,
                                      duration: Duration(milliseconds: 300),
                                      child: dashboard_page()));

                              displayToast(responseJson["message"].toString());
                            } else {
                              pr.hide();
                              displayToast(responseJson["message"].toString());
                            }
                          } else {
                            displayToast("Enter valid data");
                          }
                        }, "Login", cButtoncolor)),
                    SizedBox(height: 10.sp),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: forgotPassword()));
                      },
                      child: Text("Forgot password?",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 2,
                              color: cBlack,
                              fontFamily: "SFPro",
                              fontSize: medium)),
                    ),
                    SizedBox(height: 40.sp),
                    Container(
                      height: query.height * 0.16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Image.asset(
                              "Assets/Icons/loginwith.png",
                              height: 15.sp,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Image.asset("Assets/Icons/google.png",
                                      height: 50.sp),
                                  onTap: () {
                                    _handleSignIn()
                                        .then((FirebaseUser user) async {
                                      createUser(user.email, user.photoUrl,
                                          user.uid, user.displayName, "google");
                                    });
                                  },
                                ),
                                SizedBox(width: 10.sp),
                                InkWell(
                                  child: Image.asset("Assets/Icons/fb.png",
                                      height: 50.sp),
                                  onTap: () {
                                    initiateFacebookLogin();
                                  },
                                ),
                                SizedBox(width: 10.sp),
                                InkWell(
                                    child: Image.asset("Assets/Icons/apple.png",
                                        height: 50.sp),
                                    onTap: () async {
                                      print("Click");
                                      {
                                        if (Platform.isAndroid) {
                                          var redirectURL = "";
                                          var clientID =
                                              "com.appideas.chatcity";
                                          final appleIdCredential =
                                              await SignInWithApple
                                                  .getAppleIDCredential(
                                                      scopes: [
                                                AppleIDAuthorizationScopes
                                                    .email,
                                                AppleIDAuthorizationScopes
                                                    .fullName,
                                              ],
                                                      webAuthenticationOptions:
                                                          WebAuthenticationOptions(
                                                              clientId:
                                                                  clientID,
                                                              redirectUri:
                                                                  Uri.parse(
                                                                      redirectURL)));
                                          final oAuthProvider = OAuthProvider(
                                              providerId: 'apple.com');
                                          final credential =
                                              oAuthProvider.getCredential(
                                            idToken:
                                                appleIdCredential.identityToken,
                                            accessToken: appleIdCredential
                                                .authorizationCode,
                                          );
                                          print(credential);
                                        } else {
                                          final credential =
                                              await SignInWithApple
                                                  .getAppleIDCredential(
                                            scopes: [
                                              AppleIDAuthorizationScopes.email,
                                              AppleIDAuthorizationScopes
                                                  .fullName,
                                            ],
                                            webAuthenticationOptions:
                                                WebAuthenticationOptions(
                                              clientId:
                                                  'com.aboutyou.dart_packages.sign_in_with_apple.example',
                                              redirectUri: Uri.parse(
                                                'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                              ),
                                            ),
                                            nonce: 'example-nonce',
                                            state: 'example-state',
                                          );

                                          print(credential);

                                          final ProgressDialog pr =
                                              _getProgress(context);
                                          pr.show();

                                          createUser(
                                              credential.email.toString(),
                                              "",
                                              credential.userIdentifier
                                                  .toString(),
                                              credential.givenName.toString(),
                                              "apple");

                                          final signInWithAppleEndpoint = Uri(
                                            scheme: 'https',
                                            host:
                                                'flutter-sign-in-with-apple-example.glitch.me',
                                            path: '/sign_in_with_apple',
                                            queryParameters: <String, String>{
                                              'code':
                                                  credential.authorizationCode,
                                              if (credential.givenName != null)
                                                'firstName':
                                                    credential.givenName,
                                              if (credential.familyName != null)
                                                'lastName':
                                                    credential.familyName,
                                              'useBundleId': Platform.isIOS ||
                                                      Platform.isMacOS
                                                  ? 'true'
                                                  : 'false',
                                              if (credential.state != null)
                                                'state': credential.state,
                                            },
                                          );

                                          final session =
                                              await http.Client().post(
                                            signInWithAppleEndpoint,
                                          );
                                          print(session);
                                        }
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text("")
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> login() async {
    try {
      QBLoginResult result = await QB.auth
          .login(username_controller.text.toString(), USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      print(qbUser.id.toString());
      connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void connect() async {
    final ProgressDialog pr = _getProgress(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat
          .connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);

      pr.hide();
      print(int.parse(prefs.getString("quickboxid")));
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    _auth.app.options.catchError((error) {
      print("error---->$error");
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    print(user.email);
    print("signed in " + user.displayName + user.email.toString());
    return user;
  }

  Future<void> initiateFacebookLogin() async {
    final facebookLoginResult =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        print(facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);

        print("profile******* " + profile.toString());
        print("user Id +++++ " + profile["id"].toString());
        onLoginStatusChanged(true, profileData: profile);

        createUser(
            profile["email"].toString(),
            profile["picture"]["data"]["url"].toString(),
            profile["id"].toString(),
            profile["name"].toString(),
            "facebook");
        break;
    }
  }

  Future<int> createUser(String email, String photoUrl, String uid,
      String displayName, String type) async {
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    int userId;
    try {
      QBUser user = await QB.users.createUser(email, USER_PASSWORD);
      userId = user.id;
      registerwithEmail(
          userId.toString(), email, photoUrl, uid, displayName, type);
      pr.hide();
    } on PlatformException catch (e) {
      registerwithEmail(
          userId.toString(), email, photoUrl, uid, displayName, type);
      pr.hide();
    }
    print("userId " + userId.toString());
    return userId;
  }

  Future<void> registerwithEmail(String qb_Id, String email, String photoUrl,
      String uid, String displayName, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/registerWithMail";

    print("entered data " +
        " " +
        email.toString() +
        " " +
        qb_Id.toString() +
        " " +
        uid.toString() +
        " " +
        displayName.toString() +
        " " +
        photoUrl.toString() +
        " " +
        type.toString());
    var map = new Map<String, dynamic>();
    print(email.toString());
    print(qb_Id.toString());
    print(displayName.toString());
    print(type.toString());
    print(device_token.toString());
    print(uid.toString());
    map["email"] = email.toString() == "null" ? "" : email.toString();
    map["quickboxid"] = qb_Id.toString() == "null" ? "" : qb_Id.toString();
    map["google_id"] = type == "google" ? uid.toString() : "";
    map["facebook_id"] = type == "facebook" ? uid.toString() : "";
    map["facebook_id"] = type == "facebook" ? uid.toString() : "";
    map["apple_id"] = type == "apple" ? uid.toString() : "";
    map["username"] =
        displayName.toString() == "null" ? "" : displayName.toString();
    map['type'] = type.toString() == "null" ? "" : type.toString();
    map["fcm_token"] =
        device_token.toString() == "null" ? "" : device_token.toString();
    map["device_type"] = Platform.isAndroid ? "android" : "ios";

    final response = await http.post(Uri.parse(url), body: map);

    final responseJson = json.decode(response.body);
    print("registerWithMail-- " + responseJson.toString());

    if (responseJson["status"].toString() == "fail") {
      displayToast(responseJson["message"].toString());
      pr.hide();
    } else {
      pr.hide();
      prefs.setString(
          "api_token", responseJson["data"]["api_token"].toString());
      prefs.setString("userEmail", responseJson["data"]["email"].toString());
      prefs.setString("userId", responseJson["data"]["id"].toString());
      prefs.setString("username", responseJson["data"]["username"].toString());
      prefs.setString(
          "quickboxid", responseJson["data"]["quickboxid"].toString());

      if (responseJson["data"]["is_profile"].toString() == "1") {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                child: dashboard_page()));
      } else {
        prefs.setString("userEmail", email.toString());
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                child:
                    emailRegistration_signUp(responseJson["data"], "social")));
      }
    }
  }
}

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context, isDismissible: false);
}
