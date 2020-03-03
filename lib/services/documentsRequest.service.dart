import 'package:http/http.dart' as http;
import 'package:midoriiro/models/documents.model.dart';
export 'package:midoriiro/models/documents.model.dart';
import 'package:midoriiro/models/documentsRequest.model.dart';
export 'package:midoriiro/models/documentsRequest.model.dart';

class DocumentsRequestService {
  // String url = "https://utesawebservice.herokuapp.com";
  final String url = "http://10.0.0.7:8080";

  Future<List<DocumentsRequestModel>> getDocumentsRequest(int studentid) async {
    final res =
        await http.get("$url/api/documentsRequests/documents/$studentid");

    if (res.statusCode == 200)
      return documentsRequestModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<DocumentsModel>> getDocuments() async {
    final res = await http.get("$url/api/documentsRequests/documents");

    if (res.statusCode == 200)
      return documentsModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<void> cancelRequest(int requestid) async {
    final res = await http.delete("$url/api/documentsRequests/",
        headers: {"requestid": requestid.toString()});

    if (res.statusCode == 200)
      return documentsModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<void> updateRequest(int requestid) async {
    final res = await http.put("$url/api/documentsRequests/",
        headers: {"requestid": requestid.toString()});

    if (res.statusCode == 200)
      return documentsModelFromJson(res.body);
    else
      throw "Error" + res.statusCode.toString();
  }

  Future<List<DocumentsModel>> addDocumentsRequest(
      int userid, int documentid, String razon) async {
    final res = await http.post("$url/api/documentsRequests", body: {
      "userid": userid.toString(),
      "documentid": documentid.toString(),
      "razon": razon
    });

    if (res.statusCode == 200)
      return documentsModelFromJson(res.body);
    else
      throw "Error: " + res.statusCode.toString();
  }
}
