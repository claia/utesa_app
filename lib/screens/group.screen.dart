import 'package:flutter/material.dart';
import 'package:midoriiro/models/groupComments.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/searchGroup.service.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    final GroupModel _groupModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(_groupModel.claveMateria,
              style: TextStyle(color: Colors.white)),
          subtitle: Text(_groupModel.nombreMateria,
              style: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () => showForm(_groupModel))
        ],
      ),
      body: _buildBody(_groupModel),
    );
  }

  Widget _buildBody(GroupModel data) {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_circle, color: Colors.black54),
            SizedBox(width: 10.0),
            Text("DOCENTE")
          ],
        ),
        Divider(),
        Text(data.profesor),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.timer, color: Colors.black54),
            SizedBox(width: 10.0),
            Text("HORARIOS")
          ],
        ),
        Divider(),
        Text(data.horario + " " + data.aula),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.comment, color: Colors.black54),
            SizedBox(width: 10.0),
            Text("COMENTARIOS")
          ],
        ),
        Divider(),
        FutureBuilder(
          future: _groupService.getComments(data.grupoId),
          builder: (BuildContext context,
              AsyncSnapshot<List<GroupCommentsModel>> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return Expanded(
              child: ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.assignment_ind),
                    title: Text(snapshot.data[index].student),
                    subtitle: Text(snapshot.data[index].comment)),
              ),
            );
          },
        ),
      ],
    );
  }

  void showForm(GroupModel data) {
    final formKey = GlobalKey<FormState>();
    final inpuController = TextEditingController();
    final decodeToken = DecodeToken();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: decodeToken.getTokenPayload(),
            builder: (BuildContext context, AsyncSnapshot<Payload> snapshot) {
              return AlertDialog(
                title: Text("AGREGAR COMENTARIO"),
                content: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: inpuController,
                      decoration: InputDecoration(
                        labelText: "Comentario",
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
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Agregar".toUpperCase()),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await _groupService.addComment(data.grupoId,
                            inpuController.text, snapshot.data.studentid);
                        setState(() {
                          inpuController.clear();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
