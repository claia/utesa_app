import 'package:flutter/material.dart';
import 'package:midoriiro/services/searchGroup.service.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GroupModel _groupModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(_groupModel.claveMateria,
              style: TextStyle(color: Colors.white)),
          subtitle: Text(_groupModel.nombreMateria,
              style: TextStyle(color: Colors.white) ),
        ),
      ),
    );
  }
}
