// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromMap(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GroupModel {
  final int grupoId;
  final String ciclo;
  final String claveMateria;
  final String nombreMateria;
  final String profesor;
  final String horario;
  final String aula;

  GroupModel({
    @required this.grupoId,
    @required this.ciclo,
    @required this.claveMateria,
    @required this.nombreMateria,
    @required this.profesor,
    @required this.horario,
    @required this.aula,
  });

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        grupoId: json["grupo_id"],
        ciclo: json["ciclo"],
        claveMateria: json["clave_materia"],
        nombreMateria: json["nombre_materia"],
        profesor: json["profesor"],
        horario: json["horario"],
        aula: json["aula"],
      );

  Map<String, dynamic> toMap() => {
        "grupo_id": grupoId,
        "ciclo": ciclo,
        "clave_materia": claveMateria,
        "nombre_materia": nombreMateria,
        "profesor": profesor,
        "horario": horario,
        "aula": aula,
      };
}
