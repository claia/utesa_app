import 'package:midoriiro/models/daysModel.dart';
import 'package:midoriiro/models/pendingSubjectModel.dart';
import 'package:midoriiro/models/studentJoinedModel.dart';
import 'package:midoriiro/models/subjectRequestModel.dart';
import 'package:midoriiro/services/api.service.dart';
import 'package:http/http.dart' as http;

class NewGroupRequestService {
  final String url = ApiService.url;

  Future<List<PendingSubjectModel>> searchSubjects(
      int studentid, int pensumid) async {
    final res = await http.get("$url/api/newGroups/$pensumid/$studentid");

    if (res.statusCode == 200)
      return pendingSubjectModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<SubjectRequestModel>> getAllSubjectsRequest(int studentid) async {
    final res = await http.get("$url/api/newGroups/$studentid");

    if (res.statusCode == 200)
      return subjectRequestModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<PendingSubjectModel>> addGroupsRequest(
      int userid, int subjectid, String tanda, String diasid) async {
    final res = await http.post("$url/api/newGroups/", body: {
      "userid": userid.toString(),
      "subjectid": subjectid.toString(),
      "tanda": tanda,
      "diasid": diasid
    });

    if (res.statusCode == 200)
      return pendingSubjectModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<DayModel>> getAllDaysFromRequest(int requestid) async {
    final res = await http.get("$url/api/newGroups/days", headers: {
      "requestid": requestid.toString(),
    });

    if (res.statusCode == 200)
      return dayModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<bool> cancelRequest(int requestid) async {
    final res = await http.delete("$url/api/newGroups/", headers: {
      "requestid": requestid.toString(),
    });

    if (res.statusCode == 200)
      return true;
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<bool> exitGroupRequest(int studentid) async {
    final res = await http.delete("$url/api/newGroups/exit", headers: {
      "studentid": studentid.toString(),
    });

    if (res.statusCode == 200)
      return true;
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<bool> jointToRequest(int requestid, int studentid) async {
    final res = await http.post("$url/api/newGroups/join", body: {
      "requestid": requestid.toString(),
      "studentid": studentid.toString(),
    });

    if (res.statusCode == 200)
      return true;
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<StudentJoinedModel>> getAllStudentJoined(int requestid) async {
    final res = await http.get("$url/api/newGroups/joinedStudent", headers: {
      "requestid": requestid.toString(),
    });

    if (res.statusCode == 200)
      return studentJoinedModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }
}
