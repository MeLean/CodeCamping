import 'package:flutter/material.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/splash-screen-util.dart';
import 'package:quatrace/pages/home-page.dart';
import 'package:quatrace/pages/root.dart';
import 'package:quatrace/pages/sign-up.dart';
import 'package:quatrace/pages/statistics.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  // I don't know if this is still needed but i am too scared to remove it

  if (message.containsKey('data')) {
    // Handle data message
  }

  if (message.containsKey('notification')) {
    // Handle notification message
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotifications.initializeListeners(showMessage, myBackgroundMessageHandler);
  await LocationUtil().enableService();
  await LocationUtil().getPermission();
  runApp(
    MaterialApp(
      title: 'Quatrace',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/sign-up': (context) => SignUp(),
        '/statistics': (context) => Statistics(),
        '/home-page': (context) => HomePage()
      },
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColor: Colors.greenAccent),
      home: AnimatedSplash(
        backgroundColor: Color(0xff2573d5),
        title: 'Quatrace',
        subTitle: 'Stay at home, save a life',
        home: MyApp(),
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
                  builder: (BuildContext context) => HomePage(),
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
