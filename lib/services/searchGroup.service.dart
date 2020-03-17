import 'package:http/http.dart' as http;
import 'package:midoriiro/models/group.model.dart';
import 'package:midoriiro/models/groupComments.dart';
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

  Future<List<GroupCommentsModel>> getComments(int groupid) async {
    final res = await http.get("$url/api/groups/comments/$groupid");

    if (res.statusCode == 200)
      return groupCommentsModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<bool> addComment(int groupid, String comment, int studentid) async {
    final res = await http.post("$url/api/groups/comments", body: {
      "groupid": groupid.toString(),
      "comment": comment,
      "studentid": studentid.toString(),
    });

    if (res.statusCode == 200)
      return true;
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<bool> addlike(int groupid, bool like, int studentid) async {
    final res = await http.post("$url/api/groups/likes", body: {
      "groupid": groupid.toString(),
      "like": like.toString(),
      "studentid": studentid.toString(),
    });

    if (res.statusCode == 200)
      return true;
    else
      throw "Error" + res.statusCode.toString();
  }
}
