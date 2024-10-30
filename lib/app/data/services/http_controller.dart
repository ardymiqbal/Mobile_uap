import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/article.dart';

class HttpController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _apiKey =
      '2db2256d9cf8448e9abe8ee44b34fb8e'; // API Key yang kamu gunakan
  static const String _query = 'trending movies'; // Query untuk trending movies
  static const String _language = 'en';
  static const String _sortBy = 'publishedAt';

  RxList<Article> articles = RxList<Article>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchArticles();
    super.onInit();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(
          '$_baseUrl?q=$_query&language=$_language&sortBy=$_sortBy&apiKey=$_apiKey'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final articlesResult = Articles.fromJson(json.decode(jsonData));
        articles.value = articlesResult.articles;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
