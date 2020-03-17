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
  final int pensumId;
  final String enclosureName;
  final List<Qualification> qualification;
  final int iat;
  final int exp;

  Payload({
    @required this.userid,
    @required this.studentid,
    @required this.matricula,
    @required this.firstname,
    @required this.lastname,
    @required this.pensumTitle,
    @required this.pensumId,
    @required this.enclosureName,
    @required this.qualification,
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
        pensumId: json["pensum_id"],
        enclosureName: json["enclosure_name"],
        qualification: List<Qualification>.from(
            json["qualification"].map((x) => Qualification.fromMap(x))),
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
        "pensum_id": pensumId,
        "enclosure_name": enclosureName,
        "qualification":
            List<dynamic>.from(qualification.map((x) => x.toMap())),
        "iat": iat,
        "exp": exp,
      };
}

class Qualification {
  final String grupo;
  final String materia;
  final int the1P;
  final dynamic the2P;
  final dynamic the3P;
  final dynamic nf;
  final dynamic eq;

  Qualification({
    @required this.grupo,
    @required this.materia,
    @required this.the1P,
    @required this.the2P,
    @required this.the3P,
    @required this.nf,
    @required this.eq,
  });

  factory Qualification.fromMap(Map<String, dynamic> json) => Qualification(
        grupo: json["grupo"],
        materia: json["materia"],
        the1P: json["1P"] == null ? null : json["1P"],
        the2P: json["2P"],
        the3P: json["3p"],
        nf: json["NF"],
        eq: json["EQ"],
      );

  Map<String, dynamic> toMap() => {
        "grupo": grupo,
        "materia": materia,
        "1P": the1P == null ? null : the1P,
        "2P": the2P,
        "3p": the3P,
        "NF": nf,
        "EQ": eq,
      };
}
