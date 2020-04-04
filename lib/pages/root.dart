import 'package:flutter/material.dart';
import 'package:quatrace/pages/camera-screen.dart';
import 'package:quatrace/pages/token.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/widget-utils.dart';

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
      return CameraScreen();
    }
    return TokenAuth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isItRegisteredWrapper,
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: snapshot.connectionState == ConnectionState.done
                ? _whichPage()
                : WidgetUtils().generateLoader(context, "Loading..."),
          ),
        );
      },
    );
  }
}
