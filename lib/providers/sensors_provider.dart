import 'dart:async';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotionListener {
  late final AudioController _audio;
  StreamSubscription<AccelerometerEvent>? _accelSub;

  MotionListener(BuildContext context) {
    _audio = Provider.of<AudioController>(context, listen: false);
    _initAccel();
  }

  void _initAccel() {
    _accelSub = accelerometerEvents.listen((AccelerometerEvent event) {
      final x = event.x;
      final y = event.y;
      final z = event.z;

      if ((x.abs() > 15 || y.abs() > 15 || z.abs() > 15)) {
        _handleShake();
      }

      if (x > 8) {
        _audio.player.setVolume(1.0);
        print("🔊 Volumen alto");
      } else if (x < -8) {
        _audio.player.setVolume(0.2);
        print("🔉 Volumen bajo");
      }
    });
  }

  bool _toggleLock = false;

  void _handleShake() {
    if (_toggleLock) return;

    _toggleLock = true;

    if (_audio.isPlaying) {
      _audio.pause();
      debugPrint("shaked to pause");
    } else {
      _audio.play();
      debugPrint("shaked to play");
    }

    Future.delayed(const Duration(seconds: 1), () {
      _toggleLock = false;
    });
  }

  void dispose() {
    _accelSub?.cancel();
  }
}
