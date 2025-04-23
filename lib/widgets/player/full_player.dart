import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final Track track;

  PlayerScreen({super.key, required this.track});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.track.audioUrl);

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue =
        _totalDuration.inMilliseconds == 0
            ? 0
            : _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // centro para todos los elementos
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.track.coverUrl,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.track.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.track.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            Slider(
              value: sliderValue,
              onChanged: (value) {
                final newPosition = _totalDuration * value;
                _audioPlayer.seek(newPosition);
              },
              activeColor: Color(0xFF86CECB),
              inactiveColor: Colors.white24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(_currentPosition),
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  formatDuration(_totalDuration),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 32,
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {
                    _audioPlayer.seek(Duration.zero);
                  },
                ),
                IconButton(
                  iconSize: 32,
                  icon: Icon(
                    _audioPlayer.playing
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    size: 64,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _audioPlayer.playing
                        ? _audioPlayer.pause()
                        : _audioPlayer.play();
                  },
                ),
                IconButton(
                  iconSize: 32,
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    _audioPlayer.seek(_totalDuration);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
