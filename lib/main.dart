import 'package:flutter/material.dart';
import 'package:midoriiro/screens/checkQualificationRequest.screen.dart';
import 'package:midoriiro/screens/group.screen.dart';

/* pantallas */
import 'package:midoriiro/screens/home.screen.dart';
import 'package:midoriiro/screens/login.screen.dart';
import 'package:midoriiro/screens/requestDocuments.screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UTESA APP",
      theme: _lightTheme(),
      initialRoute: "login",
      routes: <String, WidgetBuilder>{
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(),
        "requestDocuments": (context) => RequestDocumentScreen(),
        "checkQualificationRequests": (context) =>
            CheckQualificationRequestScreen(),
        "group": (context) => GroupScreen()
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: Colors.green[900],
        accentColor: Colors.yellowAccent[700],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.green[900],
            textTheme: ButtonTextTheme.primary));
  }
}
