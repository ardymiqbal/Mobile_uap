import 'package:flutter/material.dart';
import 'package:tes1/app/modules/home/controllers/music_controller.dart';

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final MusicController _controller = MusicController();

  final List<String> _musicFiles = [
    'audio/Windah_Basudara_-_Aur-auran__Lyric_Video__[_YouConvert.net_].mp3',
    'audio/Keshi - blue.mp3',
    'audio/Andra And The Backbone - Sempurna (Official Music Video).mp3',
    'audio/LANY - Let Me Know.mp3',
    'audio/Pamungkas - I Love You but Im Letting Go.mp3',
    'audio/The 1975 - A Change Of Heart.mp3',
    'audio/nyenyenye.mp3',
    'audio/ROSE_ft_Bruno_Mars_APT.mp3',
    'audio/Lady Gaga, Bruno Mars - Die With A Smile (Official Music Video).mp3',
    'audio/Billie Eilish - BIRDS OF A FEATHER (Official Music Video).mp3',
    'audio/Anne-Marie & James Arthur - Rewrite The Stars.mp3',
  ];

  String? _currentTrack;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Callback untuk menangani ketika musik selesai diputar
    _controller.onMusicComplete = () {
      setState(() {
        _currentTrack = null;
      });
    };

    _currentTrack = _controller.currentTrack; // Sinkronisasi state
  }

  Future<void> handlePlayPause(String filePath) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      await _controller.togglePlayPause(filePath);
      setState(() {
        _currentTrack = _controller.currentTrack;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backsound'),
      ),
      body: ListView.builder(
        itemCount: _musicFiles.length,
        itemBuilder: (context, index) {
          String filePath = _musicFiles[index];
          String fileName = filePath.split('/').last;

          return ListTile(
            title: Text(fileName),
            trailing: isLoading && _currentTrack == filePath
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(
                      _currentTrack == filePath
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: const Color.fromARGB(255, 227, 5, 5),
                    ),
                    onPressed: () => handlePlayPause(filePath),
                  ),
          );
        },
      ),
    );
  }
}
