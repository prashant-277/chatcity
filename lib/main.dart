import 'dart:io';

import 'package:chatcity/constants.dart';
import 'package:chatcity/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:sizer/sizer.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
// Future<void> firebaseMessagingBackgroundHandler(message) async {
//   print(message);
// }

Future<void> main() async {
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  HttpOverrides.global=new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChatCity',
          theme: ThemeData(
            primaryColor: Color(0xff382177),
          ),
          home: splashScreen(),
        );
      },
    );
  }

  void init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
    } on PlatformException catch (e) {
      // Some error occurred, look at the exception message for more details
      print(e);
    }
  }
}
