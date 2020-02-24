import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({@required this.name, @required this.icon, @required this.action});

  final String name;
  final String icon;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white,
          shadowColor: Colors.black54,
          elevation: 6.0,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: action,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(icon),
                SizedBox(height: 5.0),
                Text(name),
              ],
            ),
          ),
        ));
  }
}
