
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthUtil {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  authenticate() async {
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

    if (isAuthenticated) {
    } else {
      this.authenticate();
    }
  }
}