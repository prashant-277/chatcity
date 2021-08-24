import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class TermsofService extends StatefulWidget {
  const TermsofService({Key key}) : super(key: key);

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
          child: Text(
              "Generate your terms of service template for your website, app or e-commerce. \nKeep your business safe from any legal issue. \nTypes: Generate Terms Of Service For Third Party Services, Generate Terms Of Service For Websites. Search Results",
              textAlign: TextAlign.start,
              style: TextStyle(
              color: cBlack,
              fontSize: medium,
              fontFamily: "SFPro",
          height: 1.0.sp,
          ),),
        ),
      ),
    );
  }
}
