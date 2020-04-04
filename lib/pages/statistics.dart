import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quatrace/models/user.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/auth-util.dart';
import 'package:quatrace/utils/location-util.dart';
import 'package:quatrace/utils/push-util.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  User _currentUser;
  Future _fetchUserWrapper;
  @override
  void initState() { 
    _fetchUserWrapper = _fetchUser();
    super.initState(); 
  }

  _fetchUser() async {
    _currentUser = await APIUtil().getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserWrapper,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            snapshot.connectionState == ConnectionState.done
                ? Expanded(
                    child: _showQuarantines(context, _currentUser),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.greenAccent)))
          ],
        );
      },
    );
  }
}

showInfoDialog(information, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          "Validation infromation",
          style: TextStyle(color: Colors.green),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Status: "),
                  Text(information['status'],
                      style: TextStyle(
                          color: colorBasedOnStatus(information['status'])))
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Send at: "),
                  Text(parseDate(information['created_at']))
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Difference in meters: "),
                  Text(calculateDifference(information['distance'])
                      .toStringAsFixed(2))
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
            ),
          )
        ],
      );
    },
  );
}

String parseDate(date) {
  DateTime _convertedDate = DateTime.fromMillisecondsSinceEpoch(date * 1000);
  return DateFormat('dd-MMM-yyyy HH:mm').format(_convertedDate).toString();
}

String parseDateFromString(date) {
  DateTime _convertedDate = DateTime.parse(date);
  return DateFormat('dd-MMM-yyyy HH:mm').format(_convertedDate).toString();
}

double calculateDifference(uncalculatedDistance) {
  return double.parse(uncalculatedDistance) * 1000;
}

Color colorBasedOnStatus(String status) {
  if (status == 'APPROVED') {
    return Colors.green;
  }
  if (status == 'REJECTED') {
    return Colors.red;
  }
  return Colors.blueAccent;
}

_showQuarantines(BuildContext context, User currentUser) {
  if (currentUser.quarantineEntries.length == 0) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          "No entries yet",
          style: TextStyle(fontSize: 22.00, color: Colors.green),
        ),
      ),
    );
  }
  final List entries = currentUser.quarantineEntries;
  return Container(
    color: Colors.grey.shade200,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(5.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(
              entries[index]['status'],
              style: TextStyle(
                  color: colorBasedOnStatus(entries[index]['status']),
                  fontSize: 18.0),
            ),
            subtitle: Row(
              children: <Widget>[
                Text("Expires at "),
                Text(entries[index]['expires_at'] != null
                    ? parseDate(entries[index]['expires_at'])
                    : '')
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  showInfoDialog(entries[index], context);
                }),
          ),
        );
      },
    ),
  );
}
