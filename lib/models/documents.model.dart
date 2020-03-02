// To parse this JSON data, do
//
//     final documentsModel = documentsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DocumentsModel> documentsModelFromJson(String str) =>
    List<DocumentsModel>.from(
        json.decode(str).map((x) => DocumentsModel.fromMap(x)));

String documentsModelToJson(List<DocumentsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DocumentsModel {
  final int id;
  final String description;
  final bool status;
  final int documentTypeId;

  DocumentsModel({
    @required this.id,
    @required this.description,
    @required this.status,
    @required this.documentTypeId,
  });

  factory DocumentsModel.fromMap(Map<String, dynamic> json) => DocumentsModel(
        id: json["id"],
        description: json["description"],
        status: json["status"],
        documentTypeId: json["documentTypeId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "status": status,
        "documentTypeId": documentTypeId,
      };
}
