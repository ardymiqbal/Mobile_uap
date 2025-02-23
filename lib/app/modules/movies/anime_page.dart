import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/modules/tmdb/tmdb_api.dart';

class AnimePage extends StatelessWidget {
  final TMDBApi tmdbApi = TMDBApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anime"),
        backgroundColor: const Color.fromARGB(255, 228, 5, 5),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: tmdbApi.getPopularAnime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final anime = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Jumlah kolom
              childAspectRatio: 0.55, // Rasio aspek poster agar sesuai
              crossAxisSpacing: 10, // Jarak horizontal antar item
              mainAxisSpacing: 10, // Jarak vertikal antar item
            ),
            padding: EdgeInsets.all(10),
            itemCount: anime.length,
            itemBuilder: (context, index) {
              final show = anime[index];
              return GestureDetector(
                onTap: () {
                  // Implementasi navigasi ke detail anime
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Colors
                              .grey[900], // Warna latar belakang untuk frame
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185${show['poster_path']}',
                            fit: BoxFit.cover, // Menjaga proporsi gambar
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      show['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      show['first_air_date'] ?? 'Unknown Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black, // Background hitam ala Netflix
    );
  }
}
