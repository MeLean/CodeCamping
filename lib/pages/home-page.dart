import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:quatrace/pages/statistics.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

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
      final fcmToken = await PushNotifications(context).register();
      await APIUtil().getToken(fcmToken);
      if (APIUtil().notificationTokenLength > 0) {
        Map<String, dynamic> _location = await LocationUtil().getLocation();
        await APIUtil().sentLocation(_location);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Statistics(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quatrace'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
