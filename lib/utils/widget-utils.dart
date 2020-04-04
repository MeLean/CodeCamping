import 'package:flutter/material.dart';

class WidgetUtils {
  Widget generateLoader(context, message) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Container(
        height: 200.0,
        width: 200.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

}