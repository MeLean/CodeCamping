import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quatrace/models/user.dart';
import 'package:quatrace/utils/api-util.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  User _currentUser;
  bool _isLoading = true;

  _fetchUser() async {
    _currentUser = await APIUtil().getUserDetails();
    setState(() {
      this._isLoading = false;
    });
    print(_currentUser.quarantineEntries);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quatrace',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _isLoading == true
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.greenAccent)))
                : Expanded(
                    child: _showQuarantines(context, _currentUser),
                  )
          ],
        ),
      ),
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
                    ? parseDateFromString(entries[index]['expires_at'])
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
