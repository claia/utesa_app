import 'package:http/http.dart' as http;
import 'package:midoriiro/models/checkQualificationRequest.model.dart';
import 'package:midoriiro/models/groupCheckQualification.model.dart';
import 'package:midoriiro/services/api.service.dart';

class CheckQualificationRequestService {
  final String url = ApiService.url;

  Future<List<CheckQualificationRequestModel>> getDocumentsRequest(
      int userid) async {
    final res =
        await http.get("$url/api/checkQualificationRequests/requests/$userid");

    if (res.statusCode == 200)
      return checkQualificationRequestModelFromJson(res.body);
    else
      throw "Error " + res.statusCode.toString();
  }

  Future<List<GroupsCheckQualificationModel>> getGroups(int studentid) async {
    final res =
        await http.get("$url/api/checkQualificationRequests/groups/$studentid");

    if (res.statusCode == 200)
      return groupsCheckQualificationModelFromJson(res.body);
    else
      throw "Error " + res.statusCode.toString();
  }

  Future<bool> cancelRequest(int requestid) async {
    final res = await http.delete("$url/api/checkQualificationRequests/",
        headers: {"requestid": requestid.toString()});

    if (res.statusCode == 200)
      return true;
    else
      print(res.body.toString());
    return false;
  }

  Future<bool> addRequest(int userid, int groupid, String razon) async {
    final res = await http.post("$url/api/checkQualificationRequests/", body: {
      "userid": userid.toString(),
      "groupid": groupid.toString(),
      "razon": razon.toString()
    });

    if (res.statusCode == 200)
      return true;
    else
      print(res.body.toString());
    return false;
  }
}
