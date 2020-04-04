import 'package:flutter/material.dart';
import 'package:quatrace/pages/auth.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/splash-screen-util.dart';
import 'package:quatrace/pages/root.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotifications.initializeListeners(showMessage);
  await LocationUtil().enableService();
  await LocationUtil().getPermission();
  runApp(
    MaterialApp(
      title: 'Quatrace',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff1c3050),
        accentColor: Color(0xff0288d1),
        textTheme: TextTheme(
          display1: TextStyle(fontSize: 18.0, color: Colors.grey.shade700, decoration: TextDecoration.none),
          title: TextStyle(fontSize: 22.0, color: Colors.white, decoration: TextDecoration.none)
        ),
      ),
      home: AnimatedSplash(
        backgroundColor: Color(0xff0288d1),
        title: 'Quatrace',
        subTitle: 'Stay at home, save a life',
        home: SafeArea(child: MyApp()),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration,
      ),
    ),
  );
}

showMessage(message) {
  final currentContext = navigatorKey.currentState.overlay.context;
  showDialog(
    context: currentContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          message['notification']['title'],
          style: TextStyle(color: Colors.red.shade900),
        ),
        content: Text(message['notification']['body']),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AuthPage(),
                ),
              );
            },
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.greenAccent, fontSize: 18.0),
            ),
          )
        ],
      );
    },
  );
}
