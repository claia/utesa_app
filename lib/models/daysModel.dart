// To parse this JSON data, do
//
//     final dayModel = dayModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DayModel> dayModelFromJson(String str) =>
    List<DayModel>.from(json.decode(str).map((x) => DayModel.fromMap(x)));

String dayModelToJson(List<DayModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DayModel {
  final String dias;

  DayModel({
    @required this.dias,
  });

  factory DayModel.fromMap(Map<String, dynamic> json) => DayModel(
        dias: json["dias"],
      );

  Map<String, dynamic> toMap() => {
        "dias": dias,
      };
}
