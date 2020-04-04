import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quatrace/pages/camera-screen.dart';
import 'package:quatrace/utils/widget-utils.dart';

class TokenAuth extends StatefulWidget {
  TokenAuth({Key key}) : super(key: key);

  @override
  _TokenAuthState createState() => _TokenAuthState();
}

class _TokenAuthState extends State<TokenAuth> {
  @override
  final _tokenController = TextEditingController();
  bool _isTokenValid = true;
  bool _isLoading = false;
  _sendToken() async {
    setState(() {
      this._isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 5000));
    setState(() {
      this._isTokenValid = true;
      if (this._isTokenValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CameraScreen(),
          ),
        );
      }
    });
  }

  Widget _tokenUi() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 140.0,
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    suffixIcon: Tooltip(
                        message: "Please, enter the token send to you by email",
                        child: Icon(Icons.info_outline, size: 30.0)),
                    labelText: "Token",
                    fillColor: Colors.white,
                    errorStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(),
                    ),
                    errorText: _isTokenValid ? null : 'Invalid token',
                  ),
                  controller: _tokenController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Text(
              "Submit",
              style: TextStyle(
                  fontSize: 18.0, fontFamily: "Poppins", color: Colors.white),
            ),
            color: Theme.of(context).accentColor,
            onPressed: _sendToken,
            splashColor: Colors.indigo,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return _isLoading
        ? WidgetUtils().generateLoader(context, "Processing token...")
        : Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: _tokenUi(),
            ),
          );
  }
}
