import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tes1/app/modules/tmdb/tmdb_api.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  MovieDetailPage({required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final TMDBApi api = TMDBApi();
  YoutubePlayerController? _youtubeController;
  String? trailerKey;

  @override
  void initState() {
    super.initState();
    fetchTrailer();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> fetchTrailer() async {
    try {
      final trailers = await api.getMovieTrailers(widget.movie['id']);
      if (trailers.isNotEmpty) {
        setState(() {
          trailerKey = trailers.first['key'];
          _youtubeController = YoutubePlayerController(
            initialVideoId: trailerKey!,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              enableCaption: false,
              isLive: false,
            ),
          );
        });
      }
    } catch (e) {
      print('Error loading trailer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var posterUrl = widget.movie['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}'
        : 'https://via.placeholder.com/500';

    var title = (widget.movie['title'] ?? widget.movie['name'] ?? 'No Title')
        .toString();
    var overview =
        (widget.movie['overview'] ?? 'No overview available').toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey,
                child: Center(
                  child:
                      Icon(Icons.broken_image, size: 50, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Overview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Text(
              overview,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (_youtubeController != null)
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  onReady: () => _youtubeController!.play(),
                  onEnded: (metaData) =>
                      _youtubeController!.seekTo(Duration.zero),
                ),
                builder: (context, player) => AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
              )
            else
              Text('No trailer available', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
