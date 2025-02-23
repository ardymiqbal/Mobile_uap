import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes1/app/modules/foreground_message/notification_service.dart';
import 'package:tes1/app/modules/home/controllers/music_controller.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  final MusicController _musicController = MusicController();

  Future<void> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Username or password cannot be empty');
      return;
    }

    try {
      // Proses login ke Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.value,
        password: password.value,
      );

      // Tampilkan notifikasi login sukses
      await NotificationService().showNotification(
        "Login Successful",
        "You have successfully logged in.",
      );

      // Memutar lagu Windah Basudara
      const windahSongPath =
          'audio/Windah_Basudara_-_Aur-auran__Lyric_Video__[_YouConvert.net_].mp3';
      await _musicController.play(windahSongPath);

      // Navigasi ke halaman Home
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Invalid username or password: $e');
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }
}
