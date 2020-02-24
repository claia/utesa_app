import 'dart:convert';
import 'package:midoriiro/models/token.model.dart';

class DecodeToken {
  static Token getPayload(String token) {
    try {
      String payload = token.split(".")[1];
      var decode = base64.decode(base64.normalize(payload));
      var data = utf8.decode(decode);

      return tokenFromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
