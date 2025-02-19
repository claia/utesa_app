import 'package:http/http.dart';
import 'package:midoriiro/models/login.model.dart';
import 'package:midoriiro/services/api.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String url = ApiService.url;

  Future<int> submit(studentid, password, enclosuresid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await post('$url/api/auth', body: {
        'studentid': studentid.toString(),
        'password': password.toString(),
        'enclosuresid': enclosuresid.toString()
      });

      if (response.statusCode == 200) {
        String token = loginModelFromJson(response.body).token;
        prefs.setString("token", token);
        return 200;
      } else if (response.statusCode == 401) {
        return 401;
      } else {
        return 500;
      }
    } catch (e) {
      print(e.toString());
      return 500;
    }
  }
}
