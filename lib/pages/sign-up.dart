import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quatrace/pages/root.dart';
import 'package:quatrace/models/user.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:async';

const kGoogleApiKey = "AIzaSyAIGEt7nOqKiC-zM7cZzLf6gh_7I-bVcbo";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final Map<String, double> _location = {};
  bool _isLoading = false;

  DateTime _initialDate = DateTime.now();
  String _parsedDate =
      DateFormat('dd MMM yyyy').format(DateTime.now()).toString();
  DateTime _actualDate = DateTime.now();
  String _parsedLocation = 'Location';

  void showPicker(_context) async {
    final DateTime picked = await showDatePicker(
      context: _context,
      initialDate: _initialDate,
      firstDate: _initialDate,
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            buttonColor: Color(0xff29304d),
            primaryColor: Color(0xff29304d), //Head background
            accentColor: Color(0xff29304d), //selection color
            colorScheme: ColorScheme.light(primary: Color(0xff29304d)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _parsedDate = DateFormat('dd MMM yyyy').format(picked).toString();
        _actualDate = picked;
      });
    }
  }

  void showPlacesInput() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay,
        language: "bg",
        components: [new Component(Component.country, "bg")]);
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      setState(() {
        _parsedLocation = detail.result.name;
        _location['lat'] = detail.result.geometry.location.lat;
        _location['lng'] = detail.result.geometry.location.lng;
      });
    }
  }

  void _submitFormData() async {
    setState(() {
      this._isLoading = true;
    });
    final _pushController = PushNotifications(context);
    final _fcmKey = await _pushController.register();
    double _unixTimestamp = _actualDate.millisecondsSinceEpoch / 1000;
    User _user = new User(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _fcmKey,
      _location['lat'],
      _location['lng'],
      _phoneController.text.trim(),
      _unixTimestamp.toInt(),
    );
    await APIUtil().signUp(_user.toJson());
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    setState(() {
      this._isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.greenAccent))
                : Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Quarantine end date",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade600),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "$_parsedDate",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                        onPressed: () => showPicker(context),
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Color(0xff29304d),
                                        ),
                                        color: Colors.greenAccent,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade600),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "$_parsedLocation",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                        onPressed: showPlacesInput,
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Color(0xff29304d),
                                        ),
                                        color: Colors.greenAccent,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: _submitFormData,
                                    child: Text('Submit'),
                                    color: Color(0xff2573d5),
                                    textColor: Colors.white,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
