import 'dart:async';
import 'package:midoriiro/scripts/decodeToken.dart';
import 'package:rxdart/rxdart.dart';

import 'package:midoriiro/models/payload.model.dart';
export 'package:midoriiro/models/payload.model.dart';

abstract class HomeStateEvent {}

class HomeState {
  final _decodeToken = DecodeToken();

  // final _homeStateManagement = StreamController<HomeStateEvent>();
  final _tokenDataStream = BehaviorSubject<Payload>();

  Stream<Payload> get tokenStream => _tokenDataStream.stream;

  void _initState() async {
    _tokenDataStream.sink.add(await _decodeToken.getTokenPayload());
  }

  HomeState() {
    _initState();
  }

  void dispose() {
    // _homeStateManagement.close();
    _tokenDataStream.close();
  }
}
