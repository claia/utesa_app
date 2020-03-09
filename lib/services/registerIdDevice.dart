import 'package:http/http.dart' as http;
import 'package:midoriiro/models/payload.model.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/api.service.dart';

class RegisterIdDevice {
  final _decodeToken = DecodeToken();
  final String url = ApiService.url;

  setIdDevice(String code) async {
    Payload userData = await _decodeToken.getTokenPayload();

    try {
      await http.post("$url/api/auth/setDeviceId",
          body: {"userid": userData.userid.toString(), "deviceid": code});
    } catch (e) {
      throw e.toString();
    }
  }
}
