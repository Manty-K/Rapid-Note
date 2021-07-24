import 'package:just_audio/just_audio.dart';

class AudioPlayerController {
  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get player => _audioPlayer;

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  Future<Duration?> setPath({required String filePath}) async {
    final duration = await _audioPlayer.setFilePath(filePath);

    return duration;
  }
}
