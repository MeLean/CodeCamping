import 'dart:convert';
import 'package:quatrace/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class APIUtil {
  static final APIUtil _apiUrl = APIUtil._internal();
  factory APIUtil() {
    return _apiUrl;
  }

  APIUtil._internal();
  String _domain = 'quatrace.com';
  Map<String, String> _paths = {
    'token': '/api/auth/token',
    'userDetails': '/api/me',
    'notification': '/api/verifications',
    'upload': '/api/users',
    'verifyToken': '/api/tokens/verify'
  };
  String _token = '';
  String _notificationToken = '';
  String _oneTimeOnlyToken = '';
  String _imageBase64 = '';

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
      final response = await http.post(
        Uri.https(this._domain, this._paths['token']),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({"fcm_key": fcmKey})
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
        Uri.https(this._domain, this._paths['userDetails']),
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

  Future<bool> sentLocation(Map<String, dynamic> payload) async {
    if (this._notificationToken.length > 0) {
      payload['token'] = this._notificationToken;
      payload['image'] = this._imageBase64;

    }

    try {
      final response = await http.post(
        Uri.https(this._domain, this._paths['notification']),
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

  Future<bool> authenticateToken(String token) async {
    try {
      final response = await http.post(
        Uri.https(this._domain, this._paths['verifyToken']),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({'token': token}),
      );
      bool result = jsonDecode(response.body)['result'];
      if (result) {
        this._oneTimeOnlyToken = token;
      }
      return result;
    } catch (e) {
      throw (e);
    }
  }

  Future upload(File imageFile, String fcmKey) async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);
    Map payload = {
      'token': this._oneTimeOnlyToken,
      'fcm_key': fcmKey,
      'image': base64Image
    };
    if(this._oneTimeOnlyToken.length == 0) {
      this._imageBase64 = base64Image;
      return;
    }
    try {
      final response = await http.put(
        Uri.https(this._domain, this._paths['upload']),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        this._token = jsonDecode(response.body)['access_token'];
      }
    } catch (e) {
      throw (e);
    }
  }
}
