import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:jammies_app/models/track.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  Track? currentTrack;

  Future<void> setTrack(Track track) async {
    currentTrack = track;
    notifyListeners();

    await player.setUrl(track.audioUrl);
    play();
  }

  void play() {
    player.play();
    notifyListeners();
  }

  void pause() {
    player.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    player.seek(position);
  }

  bool get isPlaying => player.playing;
  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
