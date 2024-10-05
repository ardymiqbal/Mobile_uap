import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
