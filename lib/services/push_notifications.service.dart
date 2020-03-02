import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:midoriiro/services/registerIdDevice.dart';

class PushNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  RegisterIdDevice _registerIdDevice = RegisterIdDevice();

  void initNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((String token) {
      _registerIdDevice.setIdDevice(token);
    });

    _firebaseMessaging.configure(onMessage: (info) {
      return;
    });
  }
}
