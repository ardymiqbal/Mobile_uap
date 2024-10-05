import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs; // Reactive index to track the current page

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
