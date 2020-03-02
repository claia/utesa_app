import 'dart:convert';
import 'package:midoriiro/models/payload.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecodeToken {
  Payload _getPayload(String token) {
    // print(token);
    try {
      String payload = token.split(".")[1];
      var decode = base64.decode(base64.normalize(payload));
      var data = utf8.decode(decode);

      return payloadFromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Payload> getTokenPayload() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      return _getPayload(token);
    } catch (e) {
      throw e.toString();
    }
  }
}
