import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApi {
  final String apiKey =
      '26447442ed8ebab9158f7dce9de9563c'; // Ganti dengan API Key Anda
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/search/movie?api_key=$apiKey&query=$query&language=en-US&page=1&include_adult=false'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results']; // Kembalikan hasil pencarian
      } else {
        print('Failed to load movies');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<dynamic>> loadMoreMovies(String query, int currentPage) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/search/movie?api_key=$apiKey&query=$query&page=$currentPage&language=en-US&include_adult=false'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results']; // Kembalikan hasil pencarian tambahan
      } else {
        throw Exception('Failed to load more movies');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan rekomendasi film
  Future<List<dynamic>> getRecommendedMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'];
      } else {
        print('Failed to load recommended movies');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan rekomendasi series
  Future<List<dynamic>> getRecommendedSeries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tv/popular?api_key=$apiKey&language=en-US&page=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'];
      } else {
        print('Failed to load recommended series');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan rekomendasi kartun (genre 16 adalah Animation)
  Future<List<dynamic>> getRecommendedCartoons() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/discover/movie?api_key=$apiKey&with_genres=16&language=en-US&page=1'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'];
      } else {
        print('Failed to load recommended cartoons');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fungsi untuk mengambil data trending movies
  Future<List<dynamic>> getTrendingMovies() async {
    final url = Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Fungsi untuk mendapatkan daftar populer movies (dengan pagination untuk lebih dari 100)
  Future<List<dynamic>> getPopularMovies() async {
    List<dynamic> allMovies = [];
    int page = 1;

    while (allMovies.length < 500) {
      // Hanya ambil lebih dari 100
      final url =
          Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&page=$page');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        allMovies.addAll(data['results']);
      } else {
        throw Exception('Failed to fetch data');
      }
      page++;
    }

    return allMovies.take(500).toList(); // Membatasi hanya 100 movie
  }

  // Fungsi untuk mendapatkan daftar TV Shows populer (dengan pagination untuk lebih dari 100)
  Future<List<dynamic>> getPopularTVShows() async {
    List<dynamic> allTVShows = [];
    int page = 1;

    while (allTVShows.length < 99) {
      // Hanya ambil lebih dari 100
      final url = Uri.parse('$baseUrl/tv/popular?api_key=$apiKey&page=$page');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        allTVShows.addAll(data['results']);
      } else {
        throw Exception('Failed to fetch data');
      }
      page++;
    }

    return allTVShows.take(99).toList(); // Membatasi hanya 100 TV Shows
  }

  // Fungsi untuk mendapatkan daftar anime (dengan pagination untuk lebih dari 100)
  Future<List<dynamic>> getPopularAnime() async {
    List<dynamic> allAnime = [];
    int page = 1;

    while (allAnime.length < 500) {
      // Hanya ambil lebih dari 100
      final url = Uri.parse(
          '$baseUrl/discover/tv?api_key=$apiKey&with_genres=16&page=$page'); // 16 adalah ID genre untuk Anime
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        allAnime.addAll(data['results']);
      } else {
        throw Exception('Failed to fetch data');
      }
      page++;
    }

    return allAnime.take(500).toList(); // Membatasi hanya 100 anime
  }

  // Fungsi untuk mendapatkan daftar "My List" (sesuaikan dengan data pengguna)
  Future<List<dynamic>> getMyList() async {
    // Fungsi ini bisa diimplementasikan untuk mengambil daftar dari penyimpanan lokal atau API
    // Misalnya, kita bisa menyimpan daftar film atau acara TV favorit pengguna
    return []; // Mengembalikan list kosong untuk sementara
  }

  // Fungsi untuk mendapatkan semua kategori (Movies, TV Shows, Anime, dll)
  Future<List<dynamic>> getAllCategories() async {
    try {
      final movies = await getPopularMovies();
      final tvShows = await getPopularTVShows();
      final anime = await getPopularAnime();

      // Gabungkan semua data menjadi satu
      return [
        {'category': 'Movies', 'data': movies},
        {'category': 'TV Shows', 'data': tvShows},
        {'category': 'Anime', 'data': anime},
      ];
    } catch (e) {
      throw Exception('Failed to fetch all categories: $e');
    }
  }

  Future<List<dynamic>> getMovieTrailers(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']
          .where((video) => video['site'] == 'YouTube')
          .toList();
    } else {
      throw Exception('Failed to fetch movie trailers');
    }
  }
}
