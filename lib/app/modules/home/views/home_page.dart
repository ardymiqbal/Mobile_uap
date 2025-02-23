import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:tes1/app/modules/home/views/profile_page.dart';
import 'package:tes1/app/modules/http_screen/views/http_view.dart';
import 'package:tes1/app/modules/home/views/search_page.dart';
import 'package:tes1/app/modules/home/views/movie_review_page.dart';
import 'package:tes1/app/modules/movies/movies_page.dart';
import 'package:tes1/app/modules/movies/tv_shows_page.dart';
import 'package:tes1/app/modules/movies/anime_page.dart';
import 'package:tes1/app/modules/movies/my_list_page.dart';
import 'film_detail.dart';
import 'package:tes1/app/modules/tmdb/tmdb_api.dart';

// Home Page with BottomNavigationBar and various sections
class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final TMDBApi tmdbapi = TMDBApi();

  final List<Widget> _pages = [
    HomeContent(), // The main home content page
    Center(child: Text('Play Page')), // Placeholder for Play Page
    SearchPage(), // Placeholder for Search Page
    MovieReviewPage(), // Placeholder for Favorites Page
    ProfilePage(), // Profile Page with Image Picker
    HttpView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 255, 0, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REELIX FILM',
              style: TextStyle(
                fontSize: 18, // Adjust the font size as per your preference
                fontWeight: FontWeight.bold, // Optional: make the text bold
                color: Colors.white, // Optional: set text color
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications,
                  color: Colors.white), // Optional: set icon color
              onPressed: () {
                Get.to(() => HttpView());
              },
            ),
          ],
        ),
      ),

      // Observe page index and reactively update content
      body: Obx(() =>
          _pages[homeController.currentIndex.value]), // Observe page index
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            backgroundColor: Colors.black87,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white54,
            currentIndex: homeController.currentIndex.value,
            onTap: homeController.changeTab, // Change tab on tap
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.play_circle_filled), label: 'Play'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          )),
    );
  }
}

class HomeContent extends StatelessWidget {
  final TMDBApi tmdbapi = TMDBApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        tmdbapi.getRecommendedMovies(),
        tmdbapi.getRecommendedSeries(),
        tmdbapi.getRecommendedCartoons(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching recommendations'));
        } else {
          final movies = (snapshot.data?[0] as List<dynamic>?) ?? [];
          final series = (snapshot.data?[1] as List<dynamic>?) ?? [];
          final cartoons = (snapshot.data?[2] as List<dynamic>?) ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Categories Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    categoryButton("Movies", () => Get.to(() => MoviesPage())),
                    categoryButton(
                        "TV Shows", () => Get.to(() => TVShowsPage())),
                    categoryButton("Anime", () => Get.to(() => AnimePage())),
                    categoryButton("My List", () => Get.to(() => MyListPage())),
                  ],
                ),
                SizedBox(height: 20),
                // Featured Content
                if (movies.isNotEmpty) featuredContent(movies[0]),
                SizedBox(height: 20),
                // Recommended Movies Section
                categorySection("Recommended Movies", movies),
                categorySection("Recommended Series", series),
                categorySection("Recommended Cartoons", cartoons),
              ],
            ),
          );
        }
      },
    );
  }

  Widget categorySection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Container(
          height: 200, // Adjust the height to fit the thumbnails
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return movieThumbnail(
                (item['title'] ?? item['name']) ?? 'Unknown Title',
                item['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${item['poster_path']}'
                    : 'https://via.placeholder.com/100x150.png?text=No+Image',
                onTap: () {
                  Get.to(() => MovieDetailPage(movie: item));
                },
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget featuredContent(dynamic movie) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MovieDetailPage(movie: movie));
      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? 'Unknown Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Popular · ${movie['release_date'] ?? 'Unknown Date'}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget movieThumbnail(String title, String imageUrl,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey,
                  child:
                      Icon(Icons.broken_image, size: 50, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
