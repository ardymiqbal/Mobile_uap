import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:tes1/app/modules/tmdb/tmdb_api.dart';

class MovieController extends GetxController {
  var searchText = ''.obs;
  var movies = [].obs;
  var isListening = false.obs;
  var isLoading = false.obs;

  final stt.SpeechToText speech = stt.SpeechToText();
  final TMDBApi tmdbapi = TMDBApi();
  final String imageBaseUrl =
      'https://image.tmdb.org/t/p/w500'; // Base URL gambar

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      await speech.initialize();
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await speech.listen(
        onResult: (result) {
          searchText.value = result.recognizedWords;
          searchMovies(); // Pencarian otomatis saat mendeteksi suara
        },
      );
    } else {
      print("Izin mikrofon ditolak.");
    }
  }

  void stopListening() async {
    isListening.value = false;
    await speech.stop();
  }

  // Fungsi untuk mencari film
  void searchMovies() async {
    if (searchText.value.isEmpty) return;

    isLoading.value = true;
    try {
      var results = await tmdbapi.searchMovies(searchText.value);

      // Tambahkan URL lengkap untuk poster ke setiap film
      movies.value = results.map((movie) {
        movie['poster_url'] = movie['poster_path'] != null
            ? '$imageBaseUrl${movie['poster_path']}'
            : 'https://via.placeholder.com/150'; // Placeholder jika tidak ada poster
        return movie;
      }).toList();
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreMovies() async {
    if (isLoading.value) return; // Jangan load jika sedang memuat data
    isLoading.value = true;

    try {
      int nextPage = (movies.length / 20).floor() + 1;
      var newMovies = await tmdbapi.loadMoreMovies(searchText.value, nextPage);

      // Tambahkan URL lengkap untuk poster ke film baru
      newMovies = newMovies.map((movie) {
        movie['poster_url'] = movie['poster_path'] != null
            ? '$imageBaseUrl${movie['poster_path']}'
            : 'https://via.placeholder.com/150';
        return movie;
      }).toList();

      movies.addAll(newMovies);
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
