import 'package:get/get.dart';
import 'package:tes1/app/modules/home/views/login_page.dart';
import 'package:tes1/app/modules/home/views/home_page.dart';
import 'package:tes1/app/modules/home/bindings/login_binding.dart';
import 'package:tes1/app/modules/home/bindings/home_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
