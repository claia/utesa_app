import 'package:flutter/material.dart';
import 'package:midoriiro/models/documents.model.dart';
import 'package:midoriiro/states/documentsRequest.state.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class RequestDocumentScreen extends StatefulWidget {
  @override
  _RequestDocumentScreenState createState() => _RequestDocumentScreenState();
}

class _RequestDocumentScreenState extends State<RequestDocumentScreen> {
  final _documentsRequestState = DocumentsRequestState();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Payload>(
        stream: _documentsRequestState.payloadStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TerminosCondiciones()));
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
    return _documentsRequestList(payload);
  }

  Widget _documentsRequestList(Payload payload) {
    List colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.red,
      Colors.green,
      Colors.orange
    ];

    return StreamBuilder<List<DocumentsRequestModel>>(
        stream: _documentsRequestState.documentRequestStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerRight,
                      child: Text("CANCELAR",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                    ),
                    key: UniqueKey(),
                    confirmDismiss: (value) {
                      final requestStatus = snapshot.data[index].estadoCode;

                      return Future.delayed(Duration(milliseconds: 30), () {
                        if (requestStatus == 6)
                          return true;
                        else
                          return false;
                      });
                    },
                    onDismissed: (value) {
                      final requestid = snapshot.data[index].requestid;
                      _documentsRequestState.cancelRequest(requestid);
                      Future.delayed(Duration(seconds: 1), () {
                        _documentsRequestState.emitDataLoad();
                      });
                    },
                    child: ListTile(
                      onTap: snapshot.data[index].estadoCode != 6
                          ? null
                          : () async {
                              String result = await scanner.scan();
                              final int data = int.parse(result.split(",")[2]);
                              if (data == 3) {
                                final requestid =
                                    snapshot.data[index].requestid;
                                _documentsRequestState.updateRequest(requestid);
                                Future.delayed(Duration(seconds: 1), () {
                                  _documentsRequestState.emitDataLoad();
                                });
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("CÓDIGO QR NO VÁLIDO")));
                              }
                            },
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
                                            snapshot.data[index].estadoCode -
                                                1]))
                              ])),
                        ],
                      ),
                      trailing: snapshot.data[index].estadoCode == 6
                          ? Icon(Icons.camera_alt)
                          : Icon(Icons.check),
                    ),
                  ));
        });
  }

  void documentsRequestList(BuildContext context, Payload payload) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StreamBuilder(
            stream: _documentsRequestState.documentStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentsModel>> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => ListTile(
                        title: Text(snapshot.data[index].description),
                        trailing: Icon(Icons.add),
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: _formKey,
                                  child: AlertDialog(
                                    title:
                                        Text(snapshot.data[index].description),
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
                                          labelText: "Razón de la Solicitud"
                                              .toUpperCase()),
                                      maxLines: 4,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          textColor: Colors.red,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("CANCELAR")),
                                      FlatButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _documentsRequestState.addRequest(
                                                  payload.userid,
                                                  snapshot.data[index].id,
                                                  _inputController.value.text);
                                              Future.delayed(
                                                  Duration(seconds: 1), () {
                                                _documentsRequestState
                                                    .emitDataLoad();
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
                      ));
            },
          );
        });
  }
}

class TerminosCondiciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Informaciones".toUpperCase())),
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}
