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
    Colors.orange,
    Colors.purple
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
            PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 2:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [4];
                      });

                      break;
                    case 3:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [7];
                      });

                      break;
                    case 4:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [6];
                      });

                      break;
                    case 5:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [1];
                      });

                      break;
                    case 6:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [5];
                      });

                      break;
                    default:
                      setState(() {
                        _checkQualificationRequestService.statusRequest = [
                          1,
                          2,
                          3,
                          4,
                          5,
                          6,
                          7
                        ];
                      });
                  }
                },
                icon: Icon(Icons.filter_list),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: 1, child: Text("Ver Todas")),
                    PopupMenuItem(value: 2, child: Text("Ver Canceladas")),
                    PopupMenuItem(value: 3, child: Text("Ver En Espera")),
                    PopupMenuItem(
                        value: 4, child: Text("Ver Pendientes De Pago")),
                    PopupMenuItem(value: 5, child: Text("Ver En Proceso")),
                    PopupMenuItem(value: 6, child: Text("Ver Completadas")),
                  ];
                })
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(context));
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _decodeToken.getTokenPayload(),
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

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
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => ListTile(
                  onTap: () {},
                  trailing: showStatusIcon(snapshot.data[index].estadoCode),
                  onLongPress: snapshot.data[index].estadoCode == 4
                      ? null
                      : () => showDeleteForm(context, snapshot.data[index]),
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

  Widget showStatusIcon(int status) {
    switch (status) {
      case 7:
        return Icon(Icons.timer);
        break;
      case 4:
        return Icon(Icons.clear);
        break;
      default:
        return Icon(Icons.check);
    }
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
    return Column(
      children: <Widget>[
        Divider(),
        Text("ASIGNATURAS DISPONIBLES"),
        Divider(),
        FutureBuilder(
          future: _decodeToken.getTokenPayload(),
          builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            final payload = snapshot.data;

            return FutureBuilder(
              future: _checkQualificationRequestService
                  .getGroups(payload.studentid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<GroupsCheckQualificationModel>> snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return Expanded(
                  child: ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data[index].grupo),
                      subtitle: Text(snapshot.data[index].name),
                      trailing: Icon(Icons.add),
                      onTap: () =>
                          showForm(context, payload, snapshot.data[index]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
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
                child: Text("Cancelar".toUpperCase()),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                textColor: Colors.amber,
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
                child: Text("CANCELAR"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                textColor: Colors.red,
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
