import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final AppBar appBar;
  final List<Widget> widgets;

  final String appbartext;
  final Widget leadingIcon;

  const BaseAppBar(
      {Key key,
      this.backgroundColor,
      this.appBar,
      this.widgets,
      this.appbartext,
      this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: leadingIcon,
      brightness: Brightness.dark,
      backgroundColor: backgroundColor,
      title: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(left: 0),
        onPressed: () {
          Navigator.pop(context, true);
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
                    fontWeight: FontWeight.w500,
                    color: cBlack,
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

class commanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color colorImage;
  final AppBar appBar;
  final List<Widget> widgets;
  final String appbartext;
  final Widget leadingIcon, groupImage, imageIcon;
  final double fontsize;
  final bool imageBack;
  final Function onPressed;

  const commanAppBar(
      {Key key,
      this.appBar,
      this.widgets,
      this.appbartext,
      this.leadingIcon,
      this.colorImage,
      this.fontsize,
      this.imageBack,
      this.groupImage,
      this.imageIcon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      leading: leadingIcon,
      brightness: Brightness.dark,
      backgroundColor: cfooterpurple,
      title: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(left: 0),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*GestureDetector(
              onTap: imageBack ? () {
                Navigator.pop(context);
              }:null,
              child: Visibility(
                visible: imageBack,
                child: Image.asset(
                  "Assets/Icons/back.png",
                  height: 15.sp,
                  color: colorImage,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  groupImage,
                  Text(
                    appbartext,
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w600,
                        color: cwhite,
                        fontSize: fontsize),
                  ),
                  imageIcon
                ],
              ),
            ),*/
            Visibility(
              visible: imageBack,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                icon: Image.asset(
                  "Assets/Icons/back.png",
                  color: colorImage,
                ),
                onPressed: imageBack
                    ? () {
                        Navigator.pop(context);
                      }
                    : null,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                iconSize: 14.sp,
              ),
            ),
            Row(
              children: [
                groupImage,
                Text(
                  appbartext,
                  style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w600,
                      color: cwhite,
                      fontSize: fontsize),
                ),
                imageIcon
              ],
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
