// To parse this JSON data, do
//
//     final groupsCheckQualificationModel = groupsCheckQualificationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GroupsCheckQualificationModel> groupsCheckQualificationModelFromJson(
        String str) =>
    List<GroupsCheckQualificationModel>.from(
        json.decode(str).map((x) => GroupsCheckQualificationModel.fromMap(x)));

String groupsCheckQualificationModelToJson(
        List<GroupsCheckQualificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GroupsCheckQualificationModel {
  final int groupid;
  final String grupo;
  final String name;

  GroupsCheckQualificationModel({
    @required this.groupid,
    @required this.grupo,
    @required this.name,
  });

  factory GroupsCheckQualificationModel.fromMap(Map<String, dynamic> json) =>
      GroupsCheckQualificationModel(
        groupid: json["groupid"],
        grupo: json["grupo"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "groupid": groupid,
        "grupo": grupo,
        "name": name,
      };
}
