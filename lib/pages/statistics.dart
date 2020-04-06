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
  bool _isLoading = true;
  @override
  void initState() {
    _fetchUser();
    super.initState();
  }

  Future<void> _fetchUser() async {
    setState(() {
     _isLoading = true;
    });
    _currentUser = await APIUtil().getUserDetails();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? WidgetUtils().generateLoader(context, "Fetching your data...")
        : RefreshIndicator(
            child: Scaffold(
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
            ),
            onRefresh: _fetchUser,
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
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
                  Text(
                    "Status: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Text(information['status'],
                      style: TextStyle(
                          color: colorBasedOnStatus(information['status'])))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Verified at: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Text(parseDate(information['updated_at']))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Difference: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Text(calculateDifference(information['distance']))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Image equality: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Text(information['confidence'] == null
                      ? '0%'
                      : "${information['confidence']}%")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Image verification: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  setVerificationICon(information['is_identical'])
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

Icon setVerificationICon(isIdentical) {
  if (isIdentical == null || isIdentical == false || isIdentical == 0) {
    return Icon(
      Icons.clear,
      color: Colors.red,
      size: 28.0,
    );
  }
  return Icon(
    Icons.done,
    color: Colors.green,
    size: 28.0,
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
  if (uncalculatedDistance == null) {
    return '0m';
  }
  double distance = double.parse(uncalculatedDistance);
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
