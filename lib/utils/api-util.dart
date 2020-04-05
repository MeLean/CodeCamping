import 'dart:convert';
import 'package:path/path.dart';
import 'package:quatrace/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
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
    'signUp': '/api/auth/signup',
    'notification': '/api/verifications/new',
    'upload': '/api/upload'
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
        Uri.https(this._domain, this._paths['token'], {"fcm_key": fcmKey}),
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

  Future<bool> signUp(payload) async {
    try {
      final response = await http.post(
        Uri.https(this._domain, this._paths['signUp']),
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

  Future upload(File imageFile) async {    
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.https(this._domain, this._paths['upload']);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
}
