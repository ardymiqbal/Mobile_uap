import 'package:get/get.dart';
import 'package:tes1/app/modules/login/views/login_page.dart';
import 'package:tes1/app/modules/home/views/home_page.dart';
import 'package:tes1/app/modules/login/bindings/login_binding.dart';
import 'package:tes1/app/modules/home/bindings/home_binding.dart';
import 'package:tes1/app/modules/articel_dertail/bindings/article_detail_binding.dart';
import 'package:tes1/app/modules/articel_dertail/views/article_detail_view.dart';
import 'package:tes1/app/modules/articel_dertail/views/article_detail_web_view.dart';
import 'package:tes1/app/modules/http_screen/bindings/http_binding.dart';
import 'package:tes1/app/modules/http_screen/views/http_view.dart';

part 'app_routes.dart';

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
    GetPage(
        name: '/http', 
        page: () => const HttpView(), 
        binding: HttpBinding()),
    GetPage(
        name: '/article_details',
        page: () => ArticleDetailPage(article: Get.arguments),
        binding: ArticleDetailBinding()),
    GetPage(
        name: '/article_details_webview',
        page: () => ArticleDetailWebView(article: Get.arguments),
        binding: ArticleDetailBinding()),
  ];
}
