import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:quatrace/pages/statistics.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/widget-utils.dart';

class AuthPage extends StatefulWidget {
  const AuthPage();
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future _authenticateUserWrapper;
  @override
  void initState() {
    _authenticateUserWrapper = _authenticateUser();
    super.initState();
  }

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
          localizedReason:
              "Please authenticate to view your transaction overview",
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (isAuthenticated) {
      final fcmToken = await PushNotifications(context).register();
      //await APIUtil().getToken(fcmToken);
      if (APIUtil().notificationTokenLength > 0) {
        Map<String, dynamic> _location = await LocationUtil().getLocation();
        //await APIUtil().sentLocation(_location);
      }
    } else {
      setState(() {
        _authenticateUserWrapper = _authenticateUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _authenticateUserWrapper,
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment.center,
            child: snapshot.connectionState == ConnectionState.done
                ? Statistics()
                : WidgetUtils().generateLoader(context, "Waiting for input..."),
          );
        });
  }
}
