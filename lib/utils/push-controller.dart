import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class PushNotifications with ChangeNotifier {
  PushNotifications();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  Future<String> register() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      throw (e);
    }
  }

  PushNotifications.initializeListeners(showMessage) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showMessage(message);
      }
    );
  }
}
