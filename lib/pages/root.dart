import 'package:flutter/material.dart';
import 'package:quatrace/pages/home-page.dart';
import 'package:quatrace/pages/sign-up.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/push-util.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUserRegistered = false;
  bool falseResponse = false;
  @override
  void initState(){
    super.initState();
    this._isItRegistered();
  }

  _isItRegistered() async {
    final String fcmToken = await PushNotifications(context).register();
    final bool result = await APIUtil().getToken(fcmToken);
    setState(() {
      if (result) {
        this._isUserRegistered = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: this._isUserRegistered ? HomePage() : SignUp(),
      ),
    );
  }
}
