import 'package:flutter/material.dart';
import 'package:quatrace/pages/auth.dart';
import 'package:quatrace/pages/sign-up.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/push-util.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUserRegistered = false;
  Future _isItRegisteredWrapper;
  @override
  void initState() { 
    _isItRegisteredWrapper = _isItRegistered();
    super.initState();
  }
  Future _isItRegistered() async {
    final String fcmToken = await PushNotifications(context).register();
    final bool result = await APIUtil().getToken(fcmToken);
    setState(() {
      if (result) {
        this._isUserRegistered = true;
      }
    });
  }

  Widget _whichPage() {
    if (this._isUserRegistered) {
      return AuthPage();
    }
    return SignUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isItRegisteredWrapper,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Quatrace',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0xff0c314d),
            ),
            body: SafeArea(
              child: snapshot.connectionState == ConnectionState.done
                  ? _whichPage()
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }
}
