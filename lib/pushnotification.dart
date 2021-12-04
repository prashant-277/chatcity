import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Explore/Explore_page.dart';


class Pushnotification {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Pushnotification(this._fcm, this.flutterLocalNotificationsPlugin);

  Future initialise() async {

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message);
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  void showNotification(Map<String, dynamic> msg) async {
    print(msg);
    var msge = msg['notification']["body"];
    var title = msg['notification']["title"];

    final android = new AndroidNotificationDetails(
      'fcm_default_channel',
      'channel NAME',
      'CHANNEL DESCRIPTION',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      channelShowBadge: true,
    );
    final iOS = new IOSNotificationDetails(
        presentAlert: true, presentSound: true, presentBadge: true);
    final platform = new NotificationDetails(android: android, iOS: iOS);
  }

  /*Future selectNotification(String payload) async {
    debugPrint("payload : $payload");
    if (payload != null) {
      debugPrint('notification payload:------ ${payload}');
      await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Explore_page()),
      ).then((value) {});
    }
  }*/
}
