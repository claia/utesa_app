import 'package:flutter/material.dart';
import 'package:midoriiro/models/daysModel.dart';
import 'package:midoriiro/models/payload.model.dart';
import 'package:midoriiro/models/pendingSubjectModel.dart';
import 'package:midoriiro/models/studentJoinedModel.dart';
import 'package:midoriiro/models/subjectRequestModel.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/newGroupRequest.service.dart';

class NewGroupRequest extends StatefulWidget {
  @override
  _NewGroupRequestState createState() => _NewGroupRequestState();
}

class _NewGroupRequestState extends State<NewGroupRequest> {
  final _newgroupRequestService = NewGroupRequestService();

  final _decodeToken = DecodeToken();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
            title: Text("Servicios".toUpperCase(),
                style: TextStyle(color: Colors.white)),
            subtitle: Text("Solicitud de grupo para asignatura".toUpperCase(),
                style: TextStyle(color: Colors.white))),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await _decodeToken.getTokenPayload();
                setState(() {});
              })
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showButtomSheet(context),
      ),
    );
  }

  Widget _buildBody() {
    final List _colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    return FutureBuilder(
      future: _decodeToken.getTokenPayload(),
      builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final data = snapshot.data;

        return FutureBuilder(
          future: _newgroupRequestService.getAllSubjectsRequest(data.studentid),
          builder: (BuildContext context,
              AsyncSnapshot<List<SubjectRequestModel>> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("ESTADO")),
                    DataColumn(label: Text("CLAVE")),
                    DataColumn(label: Text("ASINGNATURA")),
                    DataColumn(label: Text("ESTUDIANTES")),
                    DataColumn(label: Text("TANDA")),
                    DataColumn(label: Text("ACCIONES")),
                  ],
                  rows: snapshot.data.map((request) {
                    return DataRow(cells: [
                      DataCell(FlatButton(
                        textColor: _colors[request.estadoCode - 1],
                        child: Text(request.estado),
                        onPressed: () {},
                      )),
                      DataCell(Text(request.clave)),
                      DataCell(Text(request.asignatura)),
                      DataCell(Text(request.estudiantes)),
                      DataCell(Text(request.tanda)),
                      DataCell(
                        request.studentid == data.studentid
                            ? FlatButton(
                                textColor: Colors.red,
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "¿Desea salir de la solicitud?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              textColor: Colors.red,
                                              child: Text("Sí"),
                                              onPressed: () {
                                                _newgroupRequestService
                                                    .cancelRequest(
                                                        request.requestid)
                                                    .then((value) {
                                                  setState(() {});
                                                });

                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Text("CANCELAR"),
                              )
                            : FutureBuilder(
                                future: _newgroupRequestService
                                    .getAllStudentJoined(request.requestid),
                                builder: (context,
                                    AsyncSnapshot<List<StudentJoinedModel>>
                                        snapshot) {
                                  if (!snapshot.hasData)
                                    return CircularProgressIndicator();

                                  bool isJoined = false;

                                  snapshot.data.forEach((item) {
                                    if (item.studentid == data.studentid) {
                                      isJoined = true;
                                    }
                                  });

                                  if (isJoined) {
                                    return FlatButton(
                                      textColor: Colors.amber,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "¿Desea salir de la solicitud?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  FlatButton(
                                                    textColor: Colors.red,
                                                    child: Text("Sí"),
                                                    onPressed: () {
                                                      _newgroupRequestService
                                                          .exitGroupRequest(
                                                              data.studentid)
                                                          .then((value) {
                                                        setState(() {});
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Text("SALIR"),
                                    );
                                  } else {
                                    return FlatButton(
                                      textColor: Colors.amber,
                                      onPressed: () => showActionForm(
                                          request.requestid,
                                          request.tanda,
                                          request.newrequestid,
                                          data.studentid),
                                      child: Text("UNIRSE"),
                                    );
                                  }
                                }),
                      ),
                    ]);
                  }).toList()),
            );
          },
        );
      },
    );
  }

  void showActionForm(
      int requestid, String tanda, int newRequestid, int studentid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: _newgroupRequestService.getAllDaysFromRequest(requestid),
            builder:
                (BuildContext context, AsyncSnapshot<List<DayModel>> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              List<Widget> content = [
                Divider(),
                Text("TANDA"),
                Divider(),
                Text(tanda, style: TextStyle(color: Colors.amber)),
                Divider(),
                Text("DIAS REQUERIDOS"),
                Divider(),
              ];

              snapshot.data.forEach((item) {
                content.add(ListTile(title: Text(item.dias.toUpperCase())));
              });

              return AlertDialog(
                content: Container(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: content),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("CANCELAR"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("UNIRSE"),
                    textColor: Colors.amber,
                    onPressed: () async {
                      await _newgroupRequestService.jointToRequest(
                          newRequestid, studentid);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  void showForm(BuildContext context, Payload payload,
      PendingSubjectModel pendingSubjectModel) {
    List<bool> dias = List.generate(6, (index) => false);
    List tandas = ["MATUTINA", "VESPETINA", "NOCTURNA"];
    int currentTanda = 1;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("SOLICITAR ABRIR GRUPO"),
            content: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(),
                    Text("tandas".toUpperCase()),
                    Divider(),
                    DropdownButton(
                        value: currentTanda,
                        items: [
                          DropdownMenuItem(value: 1, child: Text(tandas[0])),
                          DropdownMenuItem(value: 2, child: Text(tandas[1])),
                          DropdownMenuItem(value: 3, child: Text(tandas[2])),
                        ],
                        onChanged: (value) {
                          setState(() {
                            currentTanda = value;
                          });
                        }),
                    Divider(),
                    Text("Dias Disponibles".toUpperCase()),
                    Divider(),
                    CheckboxListTile(
                        title: Text("Lunes"),
                        value: dias[0],
                        onChanged: (value) => setState(() {
                              dias[0] = value;
                            })),
                    CheckboxListTile(
                        title: Text("Martes"),
                        value: dias[1],
                        onChanged: (value) => setState(() {
                              dias[1] = value;
                            })),
                    CheckboxListTile(
                        title: Text("Miercoles"),
                        value: dias[2],
                        onChanged: (value) => setState(() {
                              dias[2] = value;
                            })),
                    CheckboxListTile(
                        title: Text("Jueves"),
                        value: dias[3],
                        onChanged: (value) => setState(() {
                              dias[3] = value;
                            })),
                    CheckboxListTile(
                        title: Text("Viernes"),
                        value: dias[4],
                        onChanged: (value) => setState(() {
                              dias[4] = value;
                            })),
                    CheckboxListTile(
                        title: Text("Sábado"),
                        value: dias[5],
                        onChanged: (value) => setState(() {
                              dias[5] = value;
                            })),
                    Divider(),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                textColor: Colors.amber,
                child: Text("SOLICITAR"),
                onPressed: () async {
                  int index = 1;
                  final diasint = List();

                  dias.forEach((dia) {
                    if (dia) diasint.add(index);
                    index++;
                  });

                  if (diasint.length <= 0) return;

                  await _newgroupRequestService.addGroupsRequest(
                      payload.userid,
                      pendingSubjectModel.id,
                      tandas[currentTanda - 1],
                      diasint.toString());
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  void _showButtomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Divider(),
              Text("ASIGNATURAS PENDIENTES"),
              Divider(),
              FutureBuilder(
                future: _decodeToken.getTokenPayload(),
                builder:
                    (BuildContext context, AsyncSnapshot<Payload> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: LinearProgressIndicator());

                  final payload = snapshot.data;

                  return FutureBuilder(
                    future: _newgroupRequestService.searchSubjects(
                        snapshot.data.studentid, snapshot.data.pensumId),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PendingSubjectModel>> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: LinearProgressIndicator());

                      return Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) => ListTile(
                            title: Text(snapshot.data[index].asignatura),
                            trailing: Icon(Icons.add),
                            onTap: () => showForm(
                                context, payload, snapshot.data[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
