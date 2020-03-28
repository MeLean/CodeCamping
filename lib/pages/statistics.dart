import 'package:flutter/material.dart';
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
        title: Text('Quatrace'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _isLoading == true
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator())
                : Expanded(
                    child: _showQuarantines(context, _currentUser),
                  )
          ],
        ),
      ),
    );
  }
}

_showQuarantines(BuildContext context, User currentUser) {
  if (currentUser.quarantineEntries.length == 0) {
    return Center(
        child: Text(
      "No entries yet",
      style: TextStyle(fontSize: 22.00, color: Theme.of(context).primaryColor),
    ));
  }
  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: currentUser.quarantineEntries.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(currentUser.quarantineEntries[index]['status']),
        subtitle: Text(
            currentUser.quarantineEntries[index]['pn_send_at'] != null
                ? currentUser.quarantineEntries[index]['pn_send_at']
                : ''),
        trailing: IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            print(currentUser.quarantineEntries[index]);
          },
        ),
      );
    },
  );
}
