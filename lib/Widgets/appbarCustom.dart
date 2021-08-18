import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final AppBar appBar;
  final List<Widget> widgets;

  final String appbartext;
  final Widget leadingIcon;

  const BaseAppBar({Key key, this.backgroundColor, this.appBar, this.widgets, this.appbartext, this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: leadingIcon,
      backgroundColor: backgroundColor,
      title: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(left: 0),
        onPressed: () {
          Navigator.pop(context,true);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "Assets/Icons/back.png",
              height: 12.sp,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                appbartext,
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w600,
                    color: cwhite,
                    fontSize: medium),
              ),
            ),
          ],
        ),
      ),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

