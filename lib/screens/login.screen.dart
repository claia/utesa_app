import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midoriiro/models/enclosure.model.dart';
import 'package:midoriiro/services/login.service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginService _loginService = LoginService();

  final List<EnclosureModel> _enclosures = [
    EnclosureModel(addressesId: 1, name: 'RECINTO SANTIAGO'),
    EnclosureModel(addressesId: 2, name: 'RECINTO MOCA'),
    EnclosureModel(addressesId: 3, name: 'RECINTO MAO'),
    EnclosureModel(addressesId: 4, name: 'RECINTO PUERTO PLATA'),
    EnclosureModel(addressesId: 5, name: 'RECINTO SANTO DOMINGO DE GUZMAN'),
    EnclosureModel(addressesId: 6, name: 'RECINTO GASPAR HERNANDEZ'),
    EnclosureModel(addressesId: 7, name: 'RECINTO SANTO DOMINGO ORIENTAL'),
    EnclosureModel(addressesId: 8, name: 'RECINTO DAJABON'),
  ];

  final _formKey = GlobalKey<FormState>();
  final _matritulaKey = TextEditingController();
  final _passwordKey = TextEditingController();

  int _currentLocation = 1;
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          _background(context),
          SafeArea(
              child: Center(
                  child: SingleChildScrollView(child: _formBox(context))))
        ],
      ),
    );
  }

  Widget _background(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final sizeReference = screenSize.width;
    final background = Container(
        height: double.infinity,
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

    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        shadowColor: Colors.black45,
        child: Container(
            padding: EdgeInsets.all(20.0),
            height: screenSize.height * 0.80,
            width: screenSize.width * 0.90,
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset("assets/logo.png",
                          width: screenSize.width * 0.5,
                          height: screenSize.width * 0.5),
                      TextFormField(
                        controller: _matritulaKey,
                        decoration: InputDecoration(
                            icon: Icon(Icons.portrait),
                            labelText: "Matricula".toUpperCase()),
                        validator: (value) {
                          if (value.length > 0) {
                            return null;
                          } else {
                            return "Ingrese Matricula".toUpperCase();
                          }
                        },
                      ),
                      TextFormField(
                        controller: _passwordKey,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock_outline),
                            labelText: "Contraseña".toUpperCase()),
                        validator: (value) {
                          if (value.length > 0) {
                            return null;
                          } else {
                            return "Ingrese Contraseña".toUpperCase();
                          }
                        },
                      ),
                      DropdownButton(
                        isExpanded: true,
                        value: _currentLocation,
                        items: _enclosures
                            .map((enclosure) => DropdownMenuItem(
                                value: enclosure.addressesId,
                                child: Text(
                                  enclosure.name,
                                  overflow: TextOverflow.ellipsis,
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _currentLocation = value;
                          });
                        },
                      ),
                      Container(
                        width: screenSize.width * 0.7,
                        height: screenSize.width * 0.13,
                        child: RaisedButton(
                          onPressed: _isloading ? null : _login,
                          child: _isloading
                              ? CircularProgressIndicator()
                              : Text("INICIAR SESIÓN"),
                        ),
                      )
                    ]))));
  }

  void _login() async {
    if (!_formKey.currentState.validate()) return;

    setState(() {
      _isloading = true;
    });

    final int status = await _loginService.submit(
        _matritulaKey.text, _passwordKey.text, _currentLocation);

    switch (status) {
      case 200:
        Navigator.of(context).pushReplacementNamed("home");
        break;
      case 401:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title:
                    Text("Matricula y/o Contraseña invalida".toUpperCase())));
        break;
      default:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("No hay conexión a internet".toUpperCase())));
    }

    setState(() {
      _isloading = false;
    });
  }
}
