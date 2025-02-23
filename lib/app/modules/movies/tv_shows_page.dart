import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tv_shows_controller.dart';

class TVShowsPage extends StatelessWidget {
  final TVShowsController controller = Get.put(TVShowsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners (opsional)
          ),
          child: Text(
            "TV Shows",
            style: TextStyle(color: Colors.white), // Warna teks putih
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 232, 5, 5), // Warna latar belakang AppBar
      ),
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.tvShows.isEmpty) {
          return Center(
            child: Text(
              "No TV Shows Found",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 3,
          ),
          itemCount: controller.tvShows.length,
          itemBuilder: (context, index) {
            final show = controller.tvShows[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${show['poster_path']}',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
