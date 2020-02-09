import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget loginIcon = Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[Icon(Icons.send), Text('INICIAR SESION')],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[_background(context), _formBox(context)],
    );
  }

  Widget _background(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final sizeReference = screenSize.width;
    final background = Container(
        height: screenSize.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[Colors.green[700], Colors.green[800]])));
    final cicle = Container(
      width: sizeReference * 0.3,
      height: sizeReference * 0.3,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.07),
          borderRadius: BorderRadius.circular(sizeReference * 0.2)),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(
            top: sizeReference * 0.18,
            left: sizeReference * 0.02,
            child: cicle),
        Positioned(
            top: sizeReference * -0.1,
            right: sizeReference * 0.1,
            child: cicle),
        Positioned(
            bottom: sizeReference * -0.1,
            right: sizeReference * -0.1,
            child: cicle),
      ],
    );
  }

  Widget _formBox(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          alignment: AlignmentDirectional.center,
          child: Container(
            height: screenSize.height * 0.82,
            width: screenSize.width * 0.85,
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      offset: Offset(0.0, 5.0))
                ]),
            child: Form(
              child: Column(
                children: <Widget>[
                  Image(
                      height: screenSize.width * 0.35,
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.cover),
                  _buildMatriculaTextField(context),
                  _buildPasswordTextField(context),
                  _buildOptButtonBox(context),
                  _buildSubmitButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatriculaTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: TextFormField(
          decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
                color: Theme.of(context).accentColor,
              ),
              labelText: 'Matricula'),
        ));
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: TextFormField(
          decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).accentColor,
              ),
              labelText: 'Contraseña'),
        ));
  }

  Widget _buildOptButtonBox(BuildContext context) {
    return Container(
        child: DropdownButtonFormField(
      decoration: InputDecoration(
          icon: Icon(
        Icons.location_on,
        color: Theme.of(context).accentColor,
      )),
      onChanged: (opt) {},
      items: [
        DropdownMenuItem(
          child: Text('Santiago'),
        )
      ],
    ));
  }

  Widget _buildSubmitButton(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: screenSize.width * 0.6,
      height: 70.0,
      child: RaisedButton(
        child: loginIcon,
        onPressed: () {
          setState(() {
            loginIcon = CircularProgressIndicator();
          });
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacementNamed('home');
          });
        },
      ),
    );
  }
}
