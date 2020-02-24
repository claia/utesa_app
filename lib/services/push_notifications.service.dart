import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:midoriiro/scripts/registerIdDevice.dart';

class PushNotificationService {
  final _notificationController = BehaviorSubject<Map<String, dynamic>>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  RegisterIdDevice _registerIdDevice = RegisterIdDevice();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;
  void Function(Map<String, dynamic>) get emitEvent =>
      _notificationController.sink.add;

  void initNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((String token) {
      _registerIdDevice.setIdDevice(token);
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
