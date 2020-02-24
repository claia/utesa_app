import 'package:http/http.dart' as http;
import 'package:midoriiro/services/login.services.dart';

class RegisterIdDevice {
  final _loginService = LoginService();

  setIdDevice(String code) async {
    try {
      _loginService.stream.listen((userData) async {
        await http.post("http://10.0.0.9:8080/api/auth/setDeviceId",
            body: {"userid": userData.userid.toString(), "deviceid": code});
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
