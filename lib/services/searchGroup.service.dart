import 'package:http/http.dart' as http;
import 'package:midoriiro/models/group.model.dart';
export 'package:midoriiro/models/group.model.dart';

class GroupService {
  // String url = "https://utesawebservice.herokuapp.com";
  final String url = "http://10.0.0.7:8080";

  Future<List<GroupModel>> searchGroups(String search) async {
    final res = await http.get("$url/api/groups/$search");

    if (res.statusCode == 200)
      return groupModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }
}
