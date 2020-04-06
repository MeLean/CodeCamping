import 'package:flutter/material.dart';
import 'package:quatrace/pages/camera-screen.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/splash-screen-util.dart';
import 'package:quatrace/pages/root.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  // I don't know if this is still needed but i am too scared to remove it
  if (message.containsKey('data')) {
    // Handle data message
  }
  if (message.containsKey('notification')) {
    // Handle notification message
  }
}
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
        titlePadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              ),
          padding: EdgeInsets.all(20.0),
          child: Text(
            message['notification']['title'],
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Text(message['notification']['body']),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CameraScreen(),
                ),
              );
            },
            color: Theme.of(context).accentColor,
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          )
        ],
      );
    },
  );
}
