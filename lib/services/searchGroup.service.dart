import 'package:http/http.dart' as http;
import 'package:midoriiro/models/group.model.dart';
import 'package:midoriiro/services/api.service.dart';
export 'package:midoriiro/models/group.model.dart';

class GroupService {
  final String url = ApiService.url;

  Future<List<GroupModel>> searchGroups(String search) async {
    final res = await http.get("$url/api/groups/$search");

    if (res.statusCode == 200)
      return groupModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }
}
