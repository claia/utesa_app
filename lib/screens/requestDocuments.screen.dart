import 'package:flutter/material.dart';
import 'package:midoriiro/models/documents.model.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/documentsRequest.service.dart';

class RequestDocumentScreen extends StatefulWidget {
  @override
  _RequestDocumentScreenState createState() => _RequestDocumentScreenState();
}

class _RequestDocumentScreenState extends State<RequestDocumentScreen> {
  final _documentsRequestService = DocumentsRequestService();

  final _formKey = GlobalKey<FormState>();

  final _decodeToken = DecodeToken();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Payload>(
        future: _decodeToken.getTokenPayload(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                actions: <Widget>[
                  PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 2:
                            setState(() {
                              _documentsRequestService.statusRequest = [4];
                            });

                            break;
                          case 3:
                            setState(() {
                              _documentsRequestService.statusRequest = [7];
                            });

                            break;
                          case 4:
                            setState(() {
                              _documentsRequestService.statusRequest = [6];
                            });

                            break;
                          case 5:
                            setState(() {
                              _documentsRequestService.statusRequest = [1];
                            });

                            break;
                          case 6:
                            setState(() {
                              _documentsRequestService.statusRequest = [5];
                            });

                            break;
                          default:
                            setState(() {
                              _documentsRequestService.statusRequest = [
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
                          PopupMenuItem(
                              value: 2, child: Text("Ver Canceladas")),
                          PopupMenuItem(value: 3, child: Text("Ver En Espera")),
                          PopupMenuItem(
                              value: 4, child: Text("Ver Pendientes De Pago")),
                          PopupMenuItem(
                              value: 5, child: Text("Ver En Proceso")),
                          PopupMenuItem(
                              value: 6, child: Text("Ver Completadas")),
                        ];
                      })
                ],
                title: ListTile(
                    title: Text("Servicios".toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text("Solicitud de documentos".toUpperCase(),
                        style: TextStyle(color: Colors.white)))),
            body: _buildBody(snapshot.data),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.note_add),
                onPressed: () => documentsRequestList(context, snapshot.data)),
          );
        });
  }

  _buildBody(Payload payload) {
    return RefreshIndicator(
        onRefresh: () async {
          await _decodeToken.getTokenPayload();
          setState(() {});
        },
        child: _documentsRequestList(payload));
  }

  Widget _documentsRequestList(Payload payload) {
    List colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    return FutureBuilder<List<DocumentsRequestModel>>(
        future: _documentsRequestService.getDocumentsRequest(payload.userid),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => ListTile(
                  onTap: () {},
                  onLongPress: snapshot.data[index].estadoCode != 6
                      ? null
                      : () => showDeleteForm(context, snapshot.data[index]),
                  title: Text(snapshot.data[index].description),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text: "TIPO DE SOLICITUD: ",
                              style: TextStyle(color: Colors.black54),
                              children: [
                            TextSpan(
                                text: snapshot.data[index].tipo,
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
                                    color: colors[
                                        snapshot.data[index].estadoCode - 1]))
                          ])),
                    ],
                  ),
                  trailing: showStatusIcon(snapshot.data[index].estadoCode)));
        });
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

  void documentsRequestList(BuildContext context, Payload payload) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Divider(),
              Text("DOCUMENTOS DISPONIBLES"),
              Divider(),
              FutureBuilder(
                future: _documentsRequestService.getDocuments(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentsModel>> snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return Expanded(
                    child: ListView.separated(
                        itemCount: snapshot.data.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) => ListTile(
                              title: Text(snapshot.data[index].description),
                              subtitle: Text("RD\$" +
                                  snapshot.data[index].price.toString()),
                              trailing: Icon(Icons.add),
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Form(
                                        key: _formKey,
                                        child: AlertDialog(
                                          title: Text(
                                              snapshot.data[index].description),
                                          content: TextFormField(
                                            controller: _inputController,
                                            validator: (value) {
                                              if (value.length > 0) {
                                                return null;
                                              } else {
                                                return "CAMPO REQUERIDO";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Razón de la Solicitud"
                                                        .toUpperCase()),
                                            maxLines: 4,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("CANCELAR")),
                                            FlatButton(
                                                textColor: Colors.amber,
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      _documentsRequestService
                                                          .addDocumentsRequest(
                                                              payload.userid,
                                                              snapshot
                                                                  .data[index]
                                                                  .id,
                                                              _inputController
                                                                  .value.text);
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text("SOLICITAR"))
                                          ],
                                        ),
                                      );
                                    });
                              },
                            )),
                  );
                },
              ),
            ],
          );
        });
  }

  void showDeleteForm(BuildContext context, DocumentsRequestModel data) {
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
                  _documentsRequestService.cancelRequest(data.requestid);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              )
            ],
          );
        });
  }
}
