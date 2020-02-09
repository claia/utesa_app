import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamController _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;
  void Function(Map<String, dynamic>) get emitEvent =>
      _notificationController.sink.add;

  void initNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((String token) {
      print(token);
    });

    _firebaseMessaging.configure(onMessage: (info) {
      emitEvent(info);
      return;
    });
  }

  void dispose() {
    _notificationController.close();
  }
}
