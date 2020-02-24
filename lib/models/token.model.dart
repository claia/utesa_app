// To parse this JSON data, do
//
//     final token = tokenFromJson(jsonString);

import 'dart:convert';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
  int userid;
  int studentsid;
  int entitieid;
  String firsname;
  String lastname;
  String name;
  int pensumid;
  String key;
  String title;
  int iat;
  int exp;

  Token({
    this.userid,
    this.studentsid,
    this.entitieid,
    this.firsname,
    this.lastname,
    this.name,
    this.pensumid,
    this.key,
    this.title,
    this.iat,
    this.exp,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        userid: json["userid"],
        studentsid: json["studentsid"],
        entitieid: json["entitieid"],
        firsname: json["firsname"],
        lastname: json["lastname"],
        name: json["name"],
        pensumid: json["pensumid"],
        key: json["key"],
        title: json["title"],
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "studentsid": studentsid,
        "entitieid": entitieid,
        "firsname": firsname,
        "lastname": lastname,
        "name": name,
        "pensumid": pensumid,
        "key": key,
        "title": title,
        "iat": iat,
        "exp": exp,
      };
}
