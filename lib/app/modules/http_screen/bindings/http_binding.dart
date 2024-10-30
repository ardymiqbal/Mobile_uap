import 'package:get/get.dart';

import 'package:tes1/app/data/services/http_controller.dart';

class HttpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HttpController>(
      () => HttpController(),
    );
  }
}
