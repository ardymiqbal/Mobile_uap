import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../tmdb/tmdb_api.dart'; // Pastikan Anda mengimpor kelas TMDBApi yang sudah dibuat

class HomeController extends GetxController {
  var currentIndex = 0.obs; // Reactive index to track the current page
  var searchText = ''.obs; // Reactive variable for search text
  final TextEditingController searchController = TextEditingController();

  final stt.SpeechToText _speech = stt.SpeechToText(); // Speech-to-text instance
  var isListening = false.obs; // Reactive variable to track microphone status

  var movies = <dynamic>[].obs; // Reactive list for movies
  var tvShows = <dynamic>[].obs; // Reactive list for TV Shows
  var anime = <dynamic>[].obs; // Reactive list for anime

  final TMDBApi tmdbApi = TMDBApi(); // Instance of TMDBApi

  // Method to change the current tab
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Start listening for voice input
  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      isListening.value = true;
      _speech.listen(onResult: (result) {
        searchText.value = result.recognizedWords;
        searchController.text = result.recognizedWords; // Update text field
        searchMovies(result.recognizedWords); // Trigger search after voice input
      });
    }
  }

  // Stop listening for voice input
  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  // Handle manual text input in search bar
  void onSearchChanged(String value) {
    searchText.value = value;
    searchMovies(value); // Trigger search when text is changed
  }

  // Method to search for movies based on the search query
  void searchMovies(String query) async {
    if (query.isNotEmpty) {
      try {
        // Search for movies using TMDBApi
        var results = await tmdbApi.searchMovies(query);
        movies.assignAll(results); // Update the movie list with search results

        // Optionally, you can also search for TV Shows or Anime
        var tvResults = await tmdbApi.searchMovies(query); // You can modify this for TV Shows or Anime
        tvShows.assignAll(tvResults); // Update the TV Shows list

        // Search for Anime if applicable
        var animeResults = await tmdbApi.searchMovies(query); // Same as above for Anime
        anime.assignAll(animeResults); // Update the Anime list
      } catch (e) {
        print('Error during search: $e');
      }
    } else {
      // Reset the movie list if the search query is empty
      movies.clear();
      tvShows.clear();
      anime.clear();
    }
  }

  // Fetch popular movies, TV shows, and anime (if necessary)
  void fetchPopularContent() async {
    try {
      var popularMovies = await tmdbApi.getPopularMovies();
      movies.assignAll(popularMovies);

      var popularTVShows = await tmdbApi.getPopularTVShows();
      tvShows.assignAll(popularTVShows);

      var popularAnime = await tmdbApi.getPopularAnime();
      anime.assignAll(popularAnime);
    } catch (e) {
      print('Error fetching popular content: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPopularContent(); // Fetch popular content when the controller is initialized
  }

  @override
  void onClose() {
    searchController.dispose(); // Dispose of the controller when the instance is destroyed
    super.onClose();
  }
}
