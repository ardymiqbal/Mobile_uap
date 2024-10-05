import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:tes1/app/modules/home/views/profile_page.dart';


// Home Page with BottomNavigationBar and various sections
class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> _pages = [
    HomeContent(), // The main home content page
    Center(child: Text('Play Page')), // Placeholder for Play Page
    Center(child: Text('Search Page')), // Placeholder for Search Page
    Center(child: Text('Favorites Page')), // Placeholder for Favorites Page
    ProfilePage(), // Profile Page with Image Picker
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WELCOME TO APP STREAMING FILM'),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Obx(() => _pages[homeController.currentIndex.value]), // Observe page index
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            backgroundColor: Colors.black87,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white54,
            currentIndex: homeController.currentIndex.value,
            onTap: homeController.changeTab, // Change tab on tap
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: 'Play'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          )),
    );
  }
}

// Home Content as a separate widget for better readability
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Categories Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () {}, child: Text("Movies")),
              TextButton(onPressed: () {}, child: Text("TV Shows")),
              TextButton(onPressed: () {}, child: Text("Anime")),
              TextButton(onPressed: () {}, child: Text("My List")),
            ],
          ),
          SizedBox(height: 20),
          // Featured Content
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/arcane.jpg'), // Use AssetImage for local asset
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
                        "Arcane",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "New · Season 1",
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
          SizedBox(height: 20),
          // Recent Watched Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Watched',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See all'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              movieThumbnail('Captain Marvel', 'assets/captain-marvel.jpg'),
              movieThumbnail('Joker', 'assets/joker.jpg'),
              movieThumbnail('The Hobbit', 'assets/hobbit.jpg'),
            ],
          ),
          SizedBox(height: 20),
          // Continue Watch Section
          Text(
            "Continue Watching",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'S1 : E1 "Jinx Born"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.5, // Progress of the video
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Using backgroundColor
                    ),
                    child: Text(
                      'Continue Watching',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // The Cast Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'The Cast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See all'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                castThumbnail('Character 1', 'https://example.com/character1.jpg'),
                castThumbnail('Character 2', 'https://example.com/character2.jpg'),
                castThumbnail('Character 3', 'https://example.com/character3.jpg'),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Favorites Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('See all'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              movieThumbnail('Free Guy', 'assets/free-guy.jpg'),
              movieThumbnail('Alita', 'assets/alita.jpg'),
              movieThumbnail('Dune', 'assets/dune.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget movieThumbnail(String title, String imageUrl) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl), // Use AssetImage for local assets
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget castThumbnail(String name, String imageUrl) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
