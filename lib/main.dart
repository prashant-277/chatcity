import 'package:chatcity/dashboard_page.dart';
import 'package:chatcity/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
