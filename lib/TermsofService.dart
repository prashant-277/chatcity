import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsofService extends StatefulWidget {
  @override
  _TermsofServiceState createState() => _TermsofServiceState();
}

class _TermsofServiceState extends State<TermsofService> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: BaseAppBar(
        appBar: AppBar(),
        backgroundColor: cwhite,
        appbartext: "Terms of service",
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: query.height,
          width: query.width,
          child: WebView(
            initialUrl: 'https://chessmafia.com/php/chatcity/terms',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
//4256
//1021
//1021
//2388
