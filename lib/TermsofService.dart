import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';
import 'package:html2md/html2md.dart' as html2md;

class TermsofService extends StatefulWidget {
  const TermsofService({Key key}) : super(key: key);

  @override
  _TermsofServiceState createState() => _TermsofServiceState();
}

class _TermsofServiceState extends State<TermsofService> {
  bool _isLoading = true;
  final url1 = url.basicUrl;

  List data = [];

  @override
  void initState() {
    super.initState();
    termsofservice();
  }

  Future<void> termsofservice() async {
    var url = "$url1/getPage";

    var map = new Map<String, dynamic>();
    map["pageid"] = "1";

    final response = await http.post(url, body: map);
    final responseJson = json.decode(response.body);
    print("res getPage  " + responseJson.toString());

    setState(() {
      data = responseJson["data"];
      _isLoading = false;
    });
  }

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
        child: _isLoading == true
            ? SpinKitRipple(color: cfooterpurple)
            : ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    html2md.convert(data[0]["page_body"].toString()),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: cBlack,
                      fontSize: medium,
                      fontFamily: "SFPro",
                      height: 1.0.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
