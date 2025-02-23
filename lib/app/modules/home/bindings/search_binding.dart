import 'package:get/get.dart';
import 'package:tes1/app/modules/home/controllers/search_controller.dart';

class MovieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MovieController>(() => MovieController());
  }
}