import 'dart:convert';

import 'package:quatrace/models/user.dart';
import 'package:http/http.dart' as http;

class APIUtil {
  APIUtil();
  String _domain = '89568f1c.ngrok.io';
  Map<String, String> _paths = {
    'token': '/api/auth/token',
    'userDetails': '/api/me',
    'signUp': '/api/auth/signup',
    'notification': '/api/notify'
  };
  String _token;
  String _notificationToken;

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

  Future<void> getToken(fcmKey) async {
    try {
      final response = await http.get(
        Uri.http(this._domain, this._paths['token'], {"fcm_key": fcmKey}),
        headers: this.getHeaders(false),
      );
      this._token = jsonDecode(response.body)['access_token'];
      print(this._token);
    } catch (e) {
      throw(e);
    }
  }

  Future<User> getUserDetails() async {
    try {
      final response = await http.get(
          Uri.http(this._domain, this._paths['userDetails']),
          headers: this.getHeaders(true));
      print(User.fromJson(jsonDecode(response.body)));
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw (e);
    }
  }

  Future<User> signUp(payload) async {
    try {
      final response = await http.post(
        Uri.http(this._domain, this._paths['signUp']),
        headers: this.getHeaders(true),
        body: payload,
      );
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> sentLocation(Map<String, dynamic> payload) async {
    if (this._notificationToken.length > 0) {
      payload['notification-token'] = this._notificationToken;
    }

    try {
      final response = await http.post(
        Uri.http(this._domain, this._paths['notification']),
        headers: this.getHeaders(true),
        body: payload,
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw (e);
    }
  }
}
