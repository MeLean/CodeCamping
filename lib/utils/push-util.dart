import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quatrace/pages/statistics.dart';
import 'package:quatrace/utils/api-util.dart';

class PushNotifications with ChangeNotifier {
  BuildContext _context;
  PushNotifications(this._context);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  Future<String> register() async {
    try {
      print(await _firebaseMessaging.getToken());
      return await _firebaseMessaging.getToken();
    } catch (e) {
      throw (e);
    }
  }

  PushNotifications.initializeListeners(showMessage, backgrounHandler) {
    _firebaseMessaging.configure(
      onBackgroundMessage: backgrounHandler,
      onMessage: (Map<String, dynamic> message) async {
        print('TEst $message');
        if(message.containsKey('data')) {
          APIUtil().setNotificationToken(message['data']['token']);
        }
        showMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('Should be seen from onLaunch $message');
        if(message.containsKey('data')) {
          APIUtil().setNotificationToken(message['data']['token']);
        }
        Navigator.push(
              this._context,
              MaterialPageRoute(builder: (context) => Statistics()));
      },
      onResume: (Map<String, dynamic> message) async {
        print('Should be seen from onResume $message');
        if(message.containsKey('data')) {
          APIUtil().setNotificationToken(message['data']['token']);
        }
        Navigator.push(
              this._context,
              MaterialPageRoute(builder: (context) => Statistics()));
      }
    );
  }
}
