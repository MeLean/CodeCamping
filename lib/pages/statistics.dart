import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quatrace/models/user.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:quatrace/utils/widget-utils.dart';

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
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Validations",
                style: Theme.of(context).textTheme.title,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: _showQuarantines(context, _currentUser),
                )
              ],
            ),
          );
        } else {
          return WidgetUtils().generateLoader(context, "Fetching your data...");
        }
      },
    );
  }
}

showInfoDialog(information, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              ),
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Validation infromation",
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Status: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
                  Text(information['status'],
                      style: TextStyle(
                          color: colorBasedOnStatus(information['status'])))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Send at: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
                  Text(parseDate(information['created_at']))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Difference: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
                  Text(calculateDifference(information['distance']))
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
            color: Theme.of(context).accentColor,
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
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

String calculateDifference(uncalculatedDistance) {
  double distance = double.parse(uncalculatedDistance) * 1000;
  return "${distance.toStringAsFixed(0)}m";
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
