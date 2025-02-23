import 'package:get/get.dart';
import 'package:tes1/app/modules/login/controllers/login_controller.dart';
import 'package:tes1/app/modules/register/controllers/register_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RegisterController>(() => RegisterController());
  } 
}  