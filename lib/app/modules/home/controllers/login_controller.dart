import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  void login() {
    if (username.value == 'user' && password.value == 'password') {
      Get.offNamed('/home'); // Arahkan ke halaman Home setelah login berhasil
    } else {
      Get.snackbar('Error', 'Invalid username or password');
    }
  }
}
