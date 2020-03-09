// To parse this JSON data, do
//
//     final checkQualificationRequestModel = checkQualificationRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CheckQualificationRequestModel> checkQualificationRequestModelFromJson(
        String str) =>
    List<CheckQualificationRequestModel>.from(
        json.decode(str).map((x) => CheckQualificationRequestModel.fromMap(x)));

String checkQualificationRequestModelToJson(
        List<CheckQualificationRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CheckQualificationRequestModel {
  final int requestid;
  final String grupo;
  final String asignatura;
  final int estadoCode;
  final String profesor;
  final String ciclo;
  final String estado;

  CheckQualificationRequestModel({
    @required this.requestid,
    @required this.grupo,
    @required this.asignatura,
    @required this.estadoCode,
    @required this.profesor,
    @required this.ciclo,
    @required this.estado,
  });

  factory CheckQualificationRequestModel.fromMap(Map<String, dynamic> json) =>
      CheckQualificationRequestModel(
        requestid: json["requestid"],
        grupo: json["grupo"],
        asignatura: json["asignatura"],
        estadoCode: json["estado_code"],
        profesor: json["profesor"],
        ciclo: json["ciclo"],
        estado: json["estado"],
      );

  Map<String, dynamic> toMap() => {
        "requestid": requestid,
        "grupo": grupo,
        "asignatura": asignatura,
        "estado_code": estadoCode,
        "profesor": profesor,
        "ciclo": ciclo,
        "estado": estado,
      };
}
