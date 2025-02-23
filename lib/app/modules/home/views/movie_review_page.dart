import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_review_controller.dart';
import 'video_page.dart';

class MovieReviewPage extends StatelessWidget {
  final MovieReviewController reviewController = Get.put(MovieReviewController());

  MovieReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Reviews'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (reviewController.reviews.isEmpty) {
                  return const Center(
                    child: Text('No reviews yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  itemCount: reviewController.reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviewController.reviews[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(review['title']),
                        subtitle: Text(review['description']),
                        onTap: () {
                          // When a review is tapped, navigate to the video player page
                          if (review['video'] != null) {
                            // Check if video exists
                            Get.to(() => VideoPlayerPage(videoFile: review['video']));
                          } else {
                            // If no video is available, show an error
                            Get.snackbar('Error', 'No video available to play.');
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddReviewDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Review'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to add review
  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    File? selectedVideo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Button to select video
                  ElevatedButton.icon(
                    onPressed: () async {
                      selectedVideo = await reviewController.pickVideo();
                      if (selectedVideo != null) {
                        Get.snackbar('Video Selected', 'Video has been added.');
                      }
                    },
                    icon: const Icon(Icons.video_library),
                    label: const Text('Pick Video'),
                  ),
                  // Button to capture video
                  ElevatedButton.icon(
                    onPressed: () async {
                      selectedVideo = await reviewController.captureVideo();
                      if (selectedVideo != null) {
                        Get.snackbar('Video Captured', 'Video has been recorded.');
                      }
                    },
                    icon: const Icon(Icons.videocam),
                    label: const Text('Record Video'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Ensure all fields are filled before adding the review
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  reviewController.addReview(
                    titleController.text,
                    descriptionController.text,
                    selectedVideo,
                  );
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar('Error', 'All fields are required.');
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}