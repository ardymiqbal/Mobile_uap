import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessagingService() {
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() {
    // Request permission for iOS
    _firebaseMessaging.requestPermission();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService().showNotification(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
        );
      }
    });

    // Handle background and terminated state messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when app is opened from a notification
    });

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

// Background handler function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // Ensure NotificationService is initialized
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Show the notification
    await notificationService.showNotification(
      message.notification!.title ?? 'New Notification',
      message.notification!.body ?? '',
    );
  }
}
