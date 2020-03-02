import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midoriiro/searchs/horaryExplore.search.dart';
import 'package:midoriiro/services/push_notifications.service.dart';
import 'package:midoriiro/states/home.state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pushNotificationService = PushNotificationService();
  // final _loginService = LoginService();
  HomeState _homeState;

  @override
  void initState() {
    super.initState();
    _pushNotificationService.initNotification();
    _homeState = HomeState();
  }

  @override
  void dispose() {
    super.dispose();
    _homeState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return DefaultTabController(
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
        ));
  }

  Widget _estudiante() {
    return StreamBuilder<Payload>(
      stream: _homeState.tokenStream,
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildInformationTitle(snapshot.data),
                  SizedBox(height: 10.0),
                  _buildInformationBody(snapshot.data)
                ],
              ),
            ),
            _buildQualification(snapshot.data)
          ],
        );
      },
    );
  }

  Widget _servicios(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10.0),
      crossAxisCount: 2,
      children: <Widget>[
        _serviceBox(context, "assets/documento.png", "Solicitud de Documentos",
            () {
          Navigator.pushNamed(context, "requestDocuments");
        }),
        _serviceBox(context, "assets/archivos-y-carpetas.png",
            "Solicitud de Revisión de Calificación", () {}),
        _serviceBox(context, "assets/buscar.png", "Buscar Horarios", () {
          showSearch(context: context, delegate: HoraryDataSearch());
        }),
        _serviceBox(
            context, "assets/presentacion.png", "Reservar Aulas", () {}),
        _serviceBox(
            context, "assets/proyector.png", "Reservar Proyectores", () {}),
        _serviceBox(context, "assets/grupo.png", "Solicitar grupo", () {}),
      ],
    );
  }

  Widget _serviceBox(
      BuildContext context, String image, String name, Function route) {
    final screenSize = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(screenSize * 0.02),
      child: Material(
        color: Colors.white,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(screenSize * 0.02),
        child: InkWell(
          onTap: () => route(),
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

  Widget _buildInformationTitle(Payload userData) {
    final boldText = TextStyle(fontWeight: FontWeight.bold);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("UNIVERSIDAD TECNOLOGICA DE SANTIAGO"),
          SizedBox(height: 5.0),
          Text("(UTESA)"),
          SizedBox(height: 5.0),
          Text(userData.enclosureName.toUpperCase(), style: boldText),
          SizedBox(height: 5.0),
          Text(userData.pensumTitle.toUpperCase()),
          SizedBox(height: 15.0),
          Text(userData.firstname + " " + userData.lastname, style: boldText),
        ],
      ),
    );
  }

  Widget _buildInformationBody(Payload userData) {
    final boldText = TextStyle(fontWeight: FontWeight.bold);

    return Container(
      child: Column(
        children: <Widget>[
          Text("DURACIÓN", style: boldText),
          LinearProgressIndicator(
            value: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("PERIODOS", style: boldText),
                  Text("12"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("TEORIA (HT)", style: boldText),
                  Text("196"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("PRACTICA (HP)", style: boldText),
                  Text("86"),
                ],
              )
            ],
          ),
          SizedBox(height: 10.0),
          Text("CREDITOS (50 PENDIENTES)", style: boldText),
          LinearProgressIndicator(
            value: 0.7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("REQUERIDOS", style: boldText),
                  Text("227"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("CURSADOS", style: boldText),
                  Text("177 DE 227"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("ELECTIVAS", style: boldText),
                  Text("0"),
                ],
              )
            ],
          ),
          SizedBox(height: 10.0),
          Text("MATERIAS (15 PENDIENTES)", style: boldText),
          LinearProgressIndicator(
            value: 0.8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("OFRECIDAS", style: boldText),
                  Text("90"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("CURSADAS", style: boldText),
                  Text("38 DE 84"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("ELECTIVAS", style: boldText),
                  Text("1 DE 5"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualification(Payload userData) {
    return Material(
      color: Colors.white,
      elevation: 1.0,
      child: Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text("PROYECTO 1"),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("1P"),
                Text("2P"),
                Text("3P"),
                Text("10P"),
                Text("NF"),
                Text("EQ"),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("20"),
                Text("20"),
                Text("20"),
                Text("10"),
                Text("70"),
                Text("C"),
              ])
        ]),
      ),
    );
  }
}
