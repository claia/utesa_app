// To parse this JSON data, do
//
//     final groupCommentsModel = groupCommentsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GroupCommentsModel> groupCommentsModelFromJson(String str) =>
    List<GroupCommentsModel>.from(
        json.decode(str).map((x) => GroupCommentsModel.fromMap(x)));

String groupCommentsModelToJson(List<GroupCommentsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GroupCommentsModel {
  final String student;
  final String comment;

  GroupCommentsModel({
    @required this.student,
    @required this.comment,
  });

  factory GroupCommentsModel.fromMap(Map<String, dynamic> json) =>
      GroupCommentsModel(
        student: json["student"],
        comment: json["comment"],
      );

  Map<String, dynamic> toMap() => {
        "student": student,
        "comment": comment,
      };
}
