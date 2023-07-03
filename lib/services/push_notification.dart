import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _fcm.requestPermission();
    final fcmToken = await _fcm.getToken();
    print('FCM Token: $fcmToken');
    // FirebaseMessaging.onBackgroundMessage((message) => _handleMessage(message));
  }

  // _handleMessage(RemoteMessage message) {
  // print('Handling a background message ${message.messageId}');
  // print('Title: ${message.notification?.title}');
  // print('Body: ${message.notification?.body}');
  // print('Data: ${message.data}');
  // }
}
