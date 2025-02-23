import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/modules/home/controllers/search_controller.dart';
import 'film_detail.dart';

class SearchPage extends StatelessWidget {
  final MovieController controller = Get.put(MovieController());
  final TextEditingController textEditingController = TextEditingController();

  SearchPage() {
    // Sinkronkan perubahan dari searchText ke TextEditingController
    controller.searchText.listen((value) {
      if (textEditingController.text != value) {
        textEditingController.text = value;
        textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: value.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Kolom pencarian dengan mikrofon di dalamnya
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Search for a movie',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isListening.value
                              ? Icons.mic
                              : Icons.mic_none,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (controller.isListening.value) {
                            controller.stopListening();
                          } else {
                            controller.startListening();
                          }
                        },
                      ),
                    ),
                    onChanged: (text) {
                      controller.searchText.value = text;
                      controller.searchMovies(); // Otomatis mencari
                    },
                  ),
                ),
                // Tombol Search di sebelah kanan kolom pencarian
                IconButton(
                  icon: Icon(Icons.search, color: Colors.red),
                  onPressed: controller.searchMovies,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Membungkus dengan RefreshIndicator
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.searchMovies();
                    },
                    color: Colors.red,
                    child: ListView.builder(
                      itemCount: controller.movies.length,
                      itemBuilder: (context, index) {
                        var movie = controller.movies[index];
                        var posterUrl = movie['poster_path'] != null
                            ? '${controller.imageBaseUrl}${movie['poster_path']}'
                            : 'https://via.placeholder.com/150';

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(posterUrl),
                            ),
                            title: Text(
                              movie['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            subtitle: Text(
                              movie['overview'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Get.to(() => MovieDetailPage(movie: movie));
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
