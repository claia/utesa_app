// To parse this JSON data, do
//
//     final documentsRequestModel = documentsRequestModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<DocumentsRequestModel> documentsRequestModelFromJson(String str) =>
    List<DocumentsRequestModel>.from(
        json.decode(str).map((x) => DocumentsRequestModel.fromMap(x)));

String documentsRequestModelToJson(List<DocumentsRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DocumentsRequestModel {
  final int requestid;
  final DateTime emissionDate;
  final int estadoCode;
  final String estado;
  final String description;
  final String tipo;
  final dynamic image;

  DocumentsRequestModel({
    @required this.requestid,
    @required this.emissionDate,
    @required this.estadoCode,
    @required this.estado,
    @required this.description,
    @required this.tipo,
    @required this.image,
  });

  factory DocumentsRequestModel.fromMap(Map<String, dynamic> json) =>
      DocumentsRequestModel(
        requestid: json["requestid"],
        emissionDate: DateTime.parse(json["emissionDate"]),
        estadoCode: json["estado_code"],
        estado: json["estado"],
        description: json["description"],
        tipo: json["tipo"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "requestid": requestid,
        "emissionDate": emissionDate.toIso8601String(),
        "estado_code": estadoCode,
        "estado": estado,
        "description": description,
        "tipo": tipo,
        "image": image,
      };
}
