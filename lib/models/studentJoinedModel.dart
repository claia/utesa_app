// To parse this JSON data, do
//
//     final studentJoinedModel = studentJoinedModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<StudentJoinedModel> studentJoinedModelFromJson(String str) =>
    List<StudentJoinedModel>.from(
        json.decode(str).map((x) => StudentJoinedModel.fromMap(x)));

String studentJoinedModelToJson(List<StudentJoinedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class StudentJoinedModel {
  final int studentid;

  StudentJoinedModel({
    @required this.studentid,
  });

  factory StudentJoinedModel.fromMap(Map<String, dynamic> json) =>
      StudentJoinedModel(
        studentid: json["studentid"],
      );

  Map<String, dynamic> toMap() => {
        "studentid": studentid,
      };
}
