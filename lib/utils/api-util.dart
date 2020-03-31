import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quatrace/models/user.dart';
import 'package:http/http.dart' as http;

class APIUtil {
  static final APIUtil _apiUrl = APIUtil._internal();

  factory APIUtil() {
    return _apiUrl;
  }

  APIUtil._internal();
  String _domain = 'dfd5d6d2.ngrok.io';
  Map<String, String> _paths = {
    'token': '/api/auth/token',
    'userDetails': '/api/me',
    'signUp': '/api/auth/signup',
    'notification': '/api/verifications/new'
  };
  String _token = '';
  String _notificationToken = '';

  get notificationTokenLength => _notificationToken.length;

  Map<String, String> getHeaders(bool authorized) {
    if (authorized) {
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    }
    return {
      'Authorization': "Bearer ${this._token}",
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  void setNotificationToken(String notificationToken) {
    this._notificationToken = notificationToken;
  }

  Future<bool> getToken(fcmKey) async {
    try {
      final response = await http.get(
        Uri.http(this._domain, this._paths['token'], {"fcm_key": fcmKey}),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      );
      this._token = jsonDecode(response.body)['access_token'];
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<User> getUserDetails() async {
    try {
      final response = await http.get(
        Uri.http(this._domain, this._paths['userDetails']),
        headers: {
          'Authorization': "Bearer ${this._token}",
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> signUp(payload) async {
    try {
      final response = await http.post(
        Uri.http(this._domain, this._paths['signUp']),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(payload),
      );
      if(response.statusCode != 201) {
        return false;
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> sentLocation(Map<String, dynamic> payload) async {
    if (this._notificationToken.length > 0) {
      payload['token'] = this._notificationToken;
    }

    try {
      final response = await http.post(
        Uri.http(this._domain, this._paths['notification']),
        headers: {
          'Authorization': "Bearer ${this._token}",
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      throw (e);
    }
  }
}
