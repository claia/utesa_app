import 'package:flutter/material.dart';
import 'package:midoriiro/services/searchGroup.service.dart';

class HoraryDataSearch extends SearchDelegate {
  GroupService _groupService = GroupService();

  @override
  final String searchFieldLabel = 'Buscar Grupos';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return ListView(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.info),
              title: Text(
                  "Aviso: Usted puede buscar por nombre y código del profesor o la materia."
                      .toUpperCase())),
        ],
      );

    return FutureBuilder(
      future: _groupService.searchGroups(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<GroupModel>> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        if (snapshot.data.length <= 0)
          return Center(
              child: Text("No se pudo cargar los datos".toUpperCase()));

        return ListView.separated(
          itemCount: snapshot.data.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) => ListTile(
            title: Text(snapshot.data[index].nombreMateria),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        text: "CICLO: ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                      TextSpan(
                          text: snapshot.data[index].ciclo,
                          style: TextStyle(color: Colors.black87))
                    ])),
                RichText(
                    text: TextSpan(
                        text: "CLAVE: ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                      TextSpan(
                          text: snapshot.data[index].claveMateria,
                          style: TextStyle(color: Colors.black87))
                    ])),
                RichText(
                    text: TextSpan(
                        text: "DOCENTE: ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                      TextSpan(
                          text: snapshot.data[index].profesor,
                          style: TextStyle(color: Colors.black87))
                    ])),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, "group",
                  arguments: snapshot.data[index]);
            },
          ),
        );
      },
    );
  }
}
