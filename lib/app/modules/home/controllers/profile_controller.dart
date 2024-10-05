
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // For web compatibility


// Profile Controller for handling profile image logic
class ProfileController extends GetxController {
  var profileImage = Rx<Uint8List?>(null); // Observable variable to hold the selected image

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = await image.readAsBytes(); // Convert image to bytes
    }
  }
}

