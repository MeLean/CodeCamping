import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:quatrace/pages/send-location.dart';
import 'package:flutter/services.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/push-controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
            "Please authenticate to view your transaction overview",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (isAuthenticated) {
      // final String fcmToken = await PushNotifications().register();
      await APIUtil().getToken('test-key');
      await APIUtil().getUserDetails();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SendLocation(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: RaisedButton(
          onPressed: () async {
            await _authenticateUser();
          },
          color: Colors.greenAccent,
          child: Text("Authenticate"),
        ),
      ),
    );
  }
}
