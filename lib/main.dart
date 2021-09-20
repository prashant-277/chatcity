import 'package:chatcity/constants.dart';
import 'package:chatcity/credentials.dart';
import 'package:chatcity/dashboard_page.dart';
import 'package:chatcity/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:sizer/sizer.dart';

void main() {
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
