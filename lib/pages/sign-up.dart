import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quatrace/models/user.dart';
import 'package:quatrace/pages/home-page.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';

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
  final _locationUtils = LocationUtil();

  DateTime _initialDate = DateTime.now();
  String _parsedDate =
      DateFormat('dd MMM yyyy').format(DateTime.now()).toString();
  DateTime _actualDate;

  void showPicker(_context) async {
    final DateTime picked = await showDatePicker(
        context: _context,
        initialDate: _initialDate,
        firstDate: _initialDate,
        lastDate: DateTime(2030));
    if (picked != null) {
      setState(() {
        _parsedDate = DateFormat('dd MMM yyyy').format(picked).toString();
        _actualDate = picked;
      });
    }
  }

  void _submitFormData() async {
    final _location = await _locationUtils.getLocation();
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_parsedDate),
                          FlatButton(
                            onPressed: () => showPicker(context),
                            child: Text("Set Date"),
                            color: Colors.greenAccent,
                          )
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
                            child: Text("Submit"),
                            color: Colors.lightBlue,
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
    );
  }
}
