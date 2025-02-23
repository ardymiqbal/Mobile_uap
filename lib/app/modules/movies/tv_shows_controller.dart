import 'package:get/get.dart';
import 'package:tes1/app/modules/tmdb/tmdb_api.dart';

class TVShowsController extends GetxController {
  final TMDBApi tmdbApi = TMDBApi();

  // State
  var tvShows = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTVShows();
  }

  // Fetch TV Shows
  void fetchTVShows() async {
    try {
      isLoading(true);
      final data = await tmdbApi.getPopularTVShows();
      tvShows.assignAll(data);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load TV Shows: $e');
    } finally {
      isLoading(false);
    }
  }
}
