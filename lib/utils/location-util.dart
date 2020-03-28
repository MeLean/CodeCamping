import 'package:location/location.dart';
import 'dart:async';

class LocationUtil {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  enableService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  getPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //Posibility to inform that the user denied location permissions.
        return;
      }
    }
  }

  Future<Map<String, dynamic>> getLocation() async {
    _locationData = await location.getLocation();
    Map<String, dynamic> parsedLocation = {
      'lat': _locationData.latitude,
      'lng': _locationData.longitude
    };
    return parsedLocation;
  }
}
