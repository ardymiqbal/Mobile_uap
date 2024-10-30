import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/data/services/http_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(HttpController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Streaming App Login',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema gelap
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: AppPages.routes, // Gunakan routing dari AppPages
    );
  }
}
