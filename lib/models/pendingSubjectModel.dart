// To parse this JSON data, do
//
//     final pendingSubjectModel = pendingSubjectModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<PendingSubjectModel> pendingSubjectModelFromJson(String str) =>
    List<PendingSubjectModel>.from(
        json.decode(str).map((x) => PendingSubjectModel.fromMap(x)));

String pendingSubjectModelToJson(List<PendingSubjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class PendingSubjectModel {
  final int id;
  final String asignatura;

  PendingSubjectModel({
    @required this.id,
    @required this.asignatura,
  });

  factory PendingSubjectModel.fromMap(Map<String, dynamic> json) =>
      PendingSubjectModel(
        id: json["id"],
        asignatura: json["asignatura"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "asignatura": asignatura,
      };
}
