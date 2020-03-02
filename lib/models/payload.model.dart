// To parse this JSON data, do
//
//     final payload = payloadFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Payload payloadFromJson(String str) => Payload.fromMap(json.decode(str));

String payloadToJson(Payload data) => json.encode(data.toMap());

class Payload {
  final int userid;
  final int studentid;
  final int matricula;
  final String firstname;
  final String lastname;
  final String pensumTitle;
  final String enclosureName;
  final int iat;
  final int exp;

  Payload({
    @required this.userid,
    @required this.studentid,
    @required this.matricula,
    @required this.firstname,
    @required this.lastname,
    @required this.pensumTitle,
    @required this.enclosureName,
    @required this.iat,
    @required this.exp,
  });

  factory Payload.fromMap(Map<String, dynamic> json) => Payload(
        userid: json["userid"],
        studentid: json["studentid"],
        matricula: json["matricula"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        pensumTitle: json["pensum_title"],
        enclosureName: json["enclosure_name"],
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "studentid": studentid,
        "matricula": matricula,
        "firstname": firstname,
        "lastname": lastname,
        "pensum_title": pensumTitle,
        "enclosure_name": enclosureName,
        "iat": iat,
        "exp": exp,
      };
}
