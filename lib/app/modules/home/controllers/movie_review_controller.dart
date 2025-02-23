import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MovieReviewController extends GetxController {
  var reviews = <Map<String, dynamic>>[].obs; // List untuk menyimpan review film
  final ImagePicker picker = ImagePicker();

  Future<void> addReview(String title, String description, File? videoFile) async {
    reviews.add({
      'title': title,
      'description': description,
      'video': videoFile,
    });
    Get.snackbar('Success', 'Review added successfully!');
  }

  Future<File?> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> captureVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}