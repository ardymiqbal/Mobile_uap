import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'app/data/services/http_controller.dart';
import 'app/modules/foreground_message/notification_service.dart';
import 'app/modules/network/controllers/network_controller.dart';
import 'app/modules/foreground_message/firebase_messaging_service.dart';
import 'app/modules/tmdb/tmdb_api.dart'; // Import TMDBApi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Notification Services
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize Firebase Messaging
  FirebaseMessagingService();

  // Dependency Injection
  Get.put(HttpController());
  Get.put(TMDBApi()); // Tambahkan TMDBApi ke Dependency Injection
    // Inisialisasi NetworkController
  Get.put(NetworkController());


  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Streaming App Login',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: AppPages.routes,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notificationService = NotificationService();
  await notificationService.initialize();

  if (message.notification != null) {
    await notificationService.showNotification(
      message.notification!.title ?? 'New Notification',
      message.notification!.body ?? '',
    );
  }
}