import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quatrace/pages/home-page.dart';
import 'package:quatrace/utils/push-controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotifications.initializeListeners(showMessage);
  }

  showMessage(message) {
    final currentContext = widget.navigatorKey.currentState.overlay.context;
    showDialog(
      context: currentContext,
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
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
