import 'package:flutter/material.dart';

class HoraryDataSearch extends SearchDelegate {
  @override
  final String searchFieldLabel = 'Buscar Horarios';

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

    return Container();
  }
}
