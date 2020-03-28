import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quatrace/utils/api-util.dart';

class PushNotifications with ChangeNotifier {
  PushNotifications();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  Future<String> register() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      throw (e);
    }
  }

  PushNotifications.initializeListeners(showMessage, backgrounHandler) {
    _firebaseMessaging.configure(
      onBackgroundMessage: backgrounHandler,
      onMessage: (Map<String, dynamic> message) async {
        if(message.containsKey('data')) {
          APIUtil().setNotificationToken(message['data']['token']);
        }
        showMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('Should be seen $message');
        if(message.containsKey('data')) {
          APIUtil().setNotificationToken(message['data']['token']);
        }
        showMessage(message);
      }
    );
  }
}
