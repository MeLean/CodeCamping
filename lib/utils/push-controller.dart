import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/material.dart';

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

  PushNotifications.initializeListeners(showMessage) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        showMessage(message);
      }
    );
  }
}
