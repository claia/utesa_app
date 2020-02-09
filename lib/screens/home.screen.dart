import 'package:flutter/material.dart';
import 'package:midoriiro/services/push_notifications.service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pushNotificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    _pushNotificationService.initNotification();
    _pushNotificationService.notificationStream.listen((data) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(data.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_alert),
              onPressed: () {
                Navigator.of(context).pushNamed("second");
              })
        ],
      ),
      body: Container(),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: null),
    );
  }
}
