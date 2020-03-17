// To parse this JSON data, do
//
//     final subjectRequestModel = subjectRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<SubjectRequestModel> subjectRequestModelFromJson(String str) =>
    List<SubjectRequestModel>.from(
        json.decode(str).map((x) => SubjectRequestModel.fromMap(x)));

String subjectRequestModelToJson(List<SubjectRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class SubjectRequestModel {
  final int studentid;
  final String clave;
  final int newrequestid;
  final String tanda;
  final String asignatura;
  final int requestid;
  final String estudiantes;
  final String estado;
  final int estadoCode;

  SubjectRequestModel({
    @required this.studentid,
    @required this.clave,
    @required this.newrequestid,
    @required this.tanda,
    @required this.asignatura,
    @required this.requestid,
    @required this.estudiantes,
    @required this.estado,
    @required this.estadoCode,
  });

  factory SubjectRequestModel.fromMap(Map<String, dynamic> json) =>
      SubjectRequestModel(
        studentid: json["studentid"],
        clave: json["clave"],
        newrequestid: json["newrequestid"],
        tanda: json["tanda"],
        asignatura: json["asignatura"],
        requestid: json["requestid"],
        estudiantes: json["estudiantes"],
        estado: json["estado"],
        estadoCode: json["estado_code"],
      );

  Map<String, dynamic> toMap() => {
        "studentid": studentid,
        "clave": clave,
        "newrequestid": newrequestid,
        "tanda": tanda,
        "asignatura": asignatura,
        "requestid": requestid,
        "estudiantes": estudiantes,
        "estado": estado,
        "estado_code": estadoCode,
      };
}
