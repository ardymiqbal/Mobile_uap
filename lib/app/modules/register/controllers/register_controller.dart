import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes1/app/modules/foreground_message/notification_service.dart'; // Import Notification Service

class RegisterController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Save user information in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'Name': username.value,
        'email': email.value, // Optional: Save email for reference
      });

      // Show success notification
      await NotificationService().showNotification(
        "Registration Successful",
        "Your account has been created successfully.",
      );

      // Navigate back to the login page
      Get.back();
    } catch (e) {
      // Show error if registration fails
      Get.snackbar('Salah bang', e.toString());
    }
  }
}
