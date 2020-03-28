import 'package:flutter/material.dart';
import 'package:quatrace/pages/home-page.dart';
import 'package:quatrace/pages/sign-up.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    print('Should fire');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
  }

  debugPrint('Damnnnn');
  // Or do other work.
}

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MaterialApp(
      title: 'Quatrace',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotifications.initializeListeners(
        showMessage, myBackgroundMessageHandler);
    LocationUtil().enableService();
    LocationUtil().getPermission();
    _isItRegistered();
  }

  _isItRegistered() async {
    final String fcmToken = await PushNotifications(context).register();
    final bool isRegistered = await APIUtil().getToken(fcmToken);
    if (isRegistered) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SignUp()));
    }
  }

  showMessage(message) {
    final currentContext = navigatorKey.currentState.overlay.context;
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message['notification']['title']),
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
              child: Text("Verify"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quatrace"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Container(
                  height: 220.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
