import 'package:http/http.dart';
import 'package:midoriiro/models/token.model.dart';
import 'package:rxdart/rxdart.dart';

class LoginService {
  final _loginController = BehaviorSubject<Token>();
  static final LoginService _loginService = LoginService._();

  Stream<Token> get stream => _loginController.stream;
  void Function(Token) get addTokenDecode => _loginController.sink.add;

  String token;

  LoginService._();
  factory LoginService() {
    return _loginService;
  }

  Future<Response> submitForm(studentid, password, enclosuresid) async {
    try {
      final url = 'http://10.0.0.9:8080/api/auth';
      final response = await post(url, body: {
        'studentid': studentid.toString(),
        'password': password.toString(),
        'enclosuresid': enclosuresid.toString()
      });

      return response;
    } catch (e) {
      return Response("{'error'}", 401);
    }
  }

  void dispose() {
    _loginController.close();
  }
}
