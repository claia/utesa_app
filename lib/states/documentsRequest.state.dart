import 'dart:async';
import 'package:midoriiro/models/documentsRequest.model.dart';
export 'package:midoriiro/models/documentsRequest.model.dart';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:midoriiro/services/documentsRequest.service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:midoriiro/models/payload.model.dart';
export 'package:midoriiro/models/payload.model.dart';

abstract class DocumentsRequesStateEvent {}

class GetDocumentsRequest extends DocumentsRequesStateEvent {}

class DocumentsRequestState {
  final _documentsRequestService = DocumentsRequestService();
  final _payloadStream = BehaviorSubject<Payload>();
  final _documentRequestStream = BehaviorSubject<List<DocumentsRequestModel>>();
  final _documentStream = BehaviorSubject<List<DocumentsModel>>();
  final _decodeToken = DecodeToken();

  Stream<Payload> get payloadStream => _payloadStream.stream;
  Stream<List<DocumentsRequestModel>> get documentRequestStream =>
      _documentRequestStream.stream;
  Stream<List<DocumentsModel>> get documentStream => _documentStream.stream;

  void addRequest(int userid, int documentid, String razon) {
    _documentsRequestService.addDocumentsRequest(userid, documentid, razon);
  }

  void cancelRequest(int requestid) {
    _documentsRequestService.cancelRequest(requestid);
  }

  void updateRequest(int requestid) {
    _documentsRequestService.updateRequest(requestid);
  }

  emitDataLoad() async {
    _payloadStream.sink.add(await _decodeToken.getTokenPayload());
  }

  void _initState() async {
    _payloadStream.sink.add(await _decodeToken.getTokenPayload());

    payloadStream.listen((payload) async {
      _documentRequestStream.sink.add(await _documentsRequestService
          .getDocumentsRequest(payload.studentid));
      _documentStream.sink.add(await _documentsRequestService.getDocuments());
    });
  }

  DocumentsRequestState() {
    _initState();
  }

  void dispose() {
    _payloadStream.close();
    _documentStream.close();
    _documentRequestStream.close();
  }
}
