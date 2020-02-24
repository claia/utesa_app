import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midoriiro/models/token.model.dart';
import 'package:midoriiro/services/login.services.dart';
import 'package:midoriiro/services/push_notifications.service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PushNotificationService _pushNotificationService;
  LoginService _loginService;

  @override
  void initState() {
    super.initState();
    _pushNotificationService = PushNotificationService();
    _pushNotificationService.initNotification();
    _loginService = LoginService();
  }

  @override
  Widget build(BuildContext context) {
    return Banner(
      location: BannerLocation.topEnd,
      color: Colors.red,
      message: "BETA",
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: ListTile(
                title: Text(
                  "UTESA MOBILE",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "VERSIÓN PARA ESTUDIANTES",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              centerTitle: true,
              bottom: TabBar(tabs: [
                Tab(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                      Icon(Icons.portrait),
                      Text("Estudiante".toUpperCase())
                    ])),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(Icons.content_paste),
                      Text("servicios".toUpperCase())
                    ],
                  ),
                )
              ]),
            ),
            body: TabBarView(
                children: <Widget>[_estudiante(), _servicios(context)]),
          )),
    );
  }

  Widget _estudiante() {
    return StreamBuilder<Token>(
        stream: _loginService.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Container(
            child: Column(
              children: <Widget>[
                Text(snapshot.data.firsname),
                Text(_loginService.token)
              ],
            ),
          );
        });
  }

  Widget _servicios(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10.0),
      crossAxisCount: 2,
      children: <Widget>[
        _serviceBox(context, "assets/documento.png", "Solicitud de Documentos",
            "requestDocuments"),
        _serviceBox(context, "assets/archivos-y-carpetas.png",
            "Solicitud de Revisión de Calificación", ""),
        _serviceBox(context, "assets/buscar.png", "Buscar Horarios", ""),
        _serviceBox(context, "assets/presentacion.png", "Rentar Aulas", ""),
        _serviceBox(context, "assets/proyector.png", "Rentar Proyectores", ""),
      ],
    );
  }

  Widget _serviceBox(
      BuildContext context, String image, String name, String route) {
    final screenSize = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(screenSize * 0.02),
      child: Material(
        color: Colors.white,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(screenSize * 0.02),
        child: InkWell(
          onTap: () {
            if (route.isNotEmpty) Navigator.of(context).pushNamed(route);
          },
          child: Container(
              padding: EdgeInsets.all(screenSize * 0.03),
              child: Column(
                children: <Widget>[
                  Expanded(flex: 2, child: Image.asset(image)),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        name.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize * 0.028,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
  //
}
