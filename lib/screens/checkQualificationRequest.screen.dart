import 'package:flutter/material.dart';
import 'package:midoriiro/models/checkQualificationRequest.model.dart';
import 'package:midoriiro/models/groupCheckQualification.model.dart';
import 'package:midoriiro/models/payload.model.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/checkQualificationRequest.service.dart';

class CheckQualificationRequestScreen extends StatefulWidget {
  @override
  _CheckQualificationRequestScreenState createState() =>
      _CheckQualificationRequestScreenState();
}

class _CheckQualificationRequestScreenState
    extends State<CheckQualificationRequestScreen> {
  final _checkQualificationRequestService = CheckQualificationRequestService();

  final _decodeToken = DecodeToken();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List _colors = [
    Colors.teal,
    Colors.blue,
    Colors.red,
    Colors.red,
    Colors.green,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: ListTile(
              title: Text("Servicios".toUpperCase(),
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                  "Solicitud de revisión de calificaciones".toUpperCase(),
                  style: TextStyle(color: Colors.white))),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.info_outline), onPressed: () {})
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(context));
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _decodeToken.getTokenPayload(),
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return RefreshIndicator(
          onRefresh: () async {
            await _decodeToken.getTokenPayload();
            setState(() {});
          },
          child: FutureBuilder(
            future: _checkQualificationRequestService
                .getDocumentsRequest(snapshot.data.userid),
            builder: (BuildContext context,
                AsyncSnapshot<List<CheckQualificationRequestModel>> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => ListTile(
                  onLongPress: () =>
                      showDeleteForm(context, snapshot.data[index]),
                  title: Text(snapshot.data[index].grupo),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text: "DOCENTE: ",
                              style: TextStyle(color: Colors.black54),
                              children: [
                            TextSpan(
                                text: snapshot.data[index].profesor,
                                style: TextStyle(color: Colors.black87))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: "ASIGNATURA: ",
                              style: TextStyle(color: Colors.black54),
                              children: [
                            TextSpan(
                                text: snapshot.data[index].asignatura,
                                style: TextStyle(color: Colors.black87))
                          ])),
                      RichText(
                          text: TextSpan(
                              text: "ESTADO: ",
                              style: TextStyle(color: Colors.black54),
                              children: [
                            TextSpan(
                                text: snapshot.data[index].estado,
                                style: TextStyle(
                                    color: _colors[
                                        snapshot.data[index].estadoCode - 1]))
                          ])),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return _bottomSheetMenu();
              });
        });
  }

  Widget _bottomSheetMenu() {
    return FutureBuilder(
      future: _decodeToken.getTokenPayload(),
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final payload = snapshot.data;

        return FutureBuilder(
          future:
              _checkQualificationRequestService.getGroups(payload.studentid),
          builder: (BuildContext context,
              AsyncSnapshot<List<GroupsCheckQualificationModel>> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data[index].grupo),
                subtitle: Text(snapshot.data[index].name),
                trailing: Icon(Icons.add),
                onTap: () => showForm(context, payload, snapshot.data[index]),
              ),
            );
          },
        );
      },
    );
  }

  void showForm(BuildContext context, Payload payload,
      GroupsCheckQualificationModel data) {
    final formKey = GlobalKey<FormState>();
    final inpuController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Revisión de calificaciones"),
            content: Form(
                key: formKey,
                child: TextFormField(
                  controller: inpuController,
                  decoration: InputDecoration(
                    labelText: "Razón",
                    helperText:
                        "Digite una razon de su solicitud".toUpperCase(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value.isEmpty)
                      return "campo requerido".toUpperCase();
                    else
                      return null;
                  },
                )),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text("Cancelar".toUpperCase()),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child: Text("solicitar".toUpperCase()),
                onPressed: () {
                  setState(() {
                    if (formKey.currentState.validate()) {
                      _checkQualificationRequestService.addRequest(
                          payload.userid, data.groupid, inpuController.text);
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  void showDeleteForm(
      BuildContext context, CheckQualificationRequestModel data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("¿CANCELAR SOLICITUD?"),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text("CANCELAR"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("ACEPTAR"),
                onPressed: () {
                  _checkQualificationRequestService
                      .cancelRequest(data.requestid);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              )
            ],
          );
        });
  }
}
