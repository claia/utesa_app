import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/searchs/horaryExplore.search.dart';
import 'package:midoriiro/services/push_notifications.service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pushNotificationService = PushNotificationService();
  final _decodeToken = DecodeToken();

  @override
  void initState() {
    super.initState();
    _pushNotificationService.initNotification();
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
                    Icon(Icons.assignment_ind),
                    Text("Estudiante".toUpperCase())
                  ])),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.apps),
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
    return FutureBuilder<Payload>(
      future: _decodeToken.getTokenPayload(),
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  InkWell(
                      onTap: () {},
                      child: _buildInformationTitle(snapshot.data)),
                  SizedBox(height: 10.0),
                  Divider(),
                  Text("PENSUM (84%)", textAlign: TextAlign.center),
                  Divider(),
                  _buildInformationBody(snapshot.data)
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Divider(),
            Text("CALIFICACIONES", textAlign: TextAlign.center),
            Divider(),
            _buildQualification(snapshot.data),
            SizedBox(height: 20.0)
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
            () => Navigator.pushNamed(context, "requestDocuments")),
        _serviceBox(
            context,
            "assets/archivos-y-carpetas.png",
            "Solicitud de Revisión de Calificación",
            () => Navigator.pushNamed(context, "checkQualificationRequests")),
        _serviceBox(
            context,
            "assets/buscar.png",
            "Buscar informaciones de grupos",
            () => showSearch(context: context, delegate: HoraryDataSearch())),
        _serviceBox(context, "assets/presentacion.png",
            "Reservar aula de Audiovisuales", () {}),
        _serviceBox(
            context, "assets/proyector.png", "Reservar Proyectores", () {}),
        _serviceBox(context, "assets/grupo.png",
            "Solicitar grupo para asignatura", () {}),
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
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: "RECINTO: ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                TextSpan(
                    text: userData.enclosureName.toUpperCase(),
                    style: TextStyle(color: Colors.black87))
              ])),
          SizedBox(height: 5.0),
          RichText(
              text: TextSpan(
                  text: "CARRERA: ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                TextSpan(
                    text: userData.pensumTitle.toUpperCase(),
                    style: TextStyle(color: Colors.black87))
              ])),
          SizedBox(height: 5.0),
          RichText(
              text: TextSpan(
                  text: "MATRICULA: ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                TextSpan(
                    text: userData.matricula.toString(),
                    style: TextStyle(color: Colors.black87))
              ])),
          SizedBox(height: 5.0),
          RichText(
              text: TextSpan(
                  text: "ESTUDIANTE: ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                TextSpan(
                    text: userData.firstname + " " + userData.lastname,
                    style: TextStyle(color: Colors.black87))
              ])),
        ],
      ),
    );
  }

  Widget _buildInformationBody(Payload userData) {
    final boldText = TextStyle();

    return Container(
      child: Column(
        children: <Widget>[
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: [
            DataColumn(label: Text("CLAVE")),
            DataColumn(label: Text("ASIGNATURA")),
            DataColumn(label: Text("1P")),
            DataColumn(label: Text("2P")),
            DataColumn(label: Text("3P")),
            DataColumn(label: Text("NF")),
            DataColumn(label: Text("EQ")),
          ],
          rows: userData.qualification.map((nota) {
            return DataRow(cells: [
              DataCell(Text(nota.grupo)),
              DataCell(Text(nota.materia)),
              DataCell(Text(nota.the1P == null ? '' : nota.the1P.toString())),
              DataCell(Text(nota.the2P == null ? '' : nota.the1P.toString())),
              DataCell(Text(nota.the3P == null ? '' : nota.the1P.toString())),
              DataCell(Text(nota.nf == null ? '' : nota.nf.toString())),
              DataCell(Text(nota.eq == null ? '' : nota.eq.toString()))
            ]);
          }).toList()),
    );
  }
}
