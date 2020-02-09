import 'package:flutter/material.dart';

/* pantallas */
import 'package:midoriiro/screens/home.screen.dart';
import 'package:midoriiro/screens/login.screen.dart';
import 'package:midoriiro/screens/second.screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: "home",
      routes: <String, WidgetBuilder>{
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(),
        "second": (context) => SecondScreen()
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: Colors.green[900],
        accentColor: Colors.yellowAccent[400],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.green[900],
            textTheme: ButtonTextTheme.primary));
  }

  ThemeData _darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.black45,
            actionTextColor: Colors.yellowAccent,
            contentTextStyle: TextStyle(color: Colors.green)));
  }
}
