import 'package:audioplayers/audioplayers.dart';

class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  MusicController._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? currentTrack;

  // Callback untuk memberi tahu UI
  Function()? onMusicComplete;

  MusicController.init() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state != null) {
        print('Player State: $state');
        isPlaying = state == PlayerState.playing;
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      currentTrack = null;

      // Panggil callback ketika musik selesai diputar
      if (onMusicComplete != null) {
        onMusicComplete!();
      }
    });
  }

  Future<void> play(String filePath) async {
    try {
      print("Memutar file: $filePath");
      if (isPlaying) {
        await _audioPlayer.stop();
      }
      currentTrack = filePath;
      await _audioPlayer.play(AssetSource(filePath));
      isPlaying = true;
      print("Berhasil memutar $filePath");
    } catch (e) {
      print("Error saat memutar musik: $e");
      throw Exception("Gagal memutar lagu: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      isPlaying = false;
      currentTrack = null;
    } catch (e) {
      throw Exception("Gagal menghentikan lagu: $e");
    }
  }

  Future<void> togglePlayPause(String filePath) async {
    if (currentTrack == filePath && isPlaying) {
      await stop();
    } else {
      await play(filePath);
    }
  }
}
