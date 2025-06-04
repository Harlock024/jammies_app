import 'package:flutter/material.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/sensors_provider.dart';
import 'package:jammies_app/services/ws_services.dart';
import 'package:jammies_app/widgets/devices/devices_modal.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  MotionListener? _motionListener;
  double _currentVolume = 0.5;
  String _lastAction = "";
  bool _showMotionFeedback = false;
  bool _motionControlEnabled = false;

  late AnimationController _shakeAnimationController;
  late AnimationController _volumeAnimationController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _volumeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (_motionControlEnabled) {
      _initializeMotionListener();
    }
    _getCurrentVolume();
  }

  void _initializeAnimations() {
    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _volumeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _volumeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _volumeAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _initializeMotionListener() {
    if (_motionListener != null) {
      _motionListener!.dispose();
    }

    final config = MotionConfig(
      shakeThreshold: 22.0,
      shakeCooldownMs: 1200,
      tiltThreshold: 7.5,
      volumeCooldownMs: 700,
      volumeStep: 0.1,
      enableVibration: true,
      enableVolumeControl: true,
      enableShakeControl: true,
    );

    _motionListener = MotionListener(
      context: context,
      config: config,
      onShakeDetected: _handleShakeDetected,
      onVolumeChanged: _handleVolumeChanged,
      onError: _handleMotionError,
    );
  }

  void _getCurrentVolume() async {
    try {
      final volume = await VolumeController.instance.getVolume();
      setState(() {
        _currentVolume = volume;
      });
    } catch (e) {
      debugPrint("Error obteniendo volumen inicial: $e");
    }
  }

  void _handleShakeDetected() {
    setState(() {
      _lastAction = "🤯 Shake detectado";
      _showMotionFeedback = true;
    });

    _shakeAnimationController.forward().then((_) {
      _shakeAnimationController.reset();
    });

    _hideMotionFeedback();
  }

  void _handleVolumeChanged(double newVolume) {
    setState(() {
      _currentVolume = newVolume;
      final percentage = (newVolume * 100).round();
      _lastAction = "🔊 Volumen: $percentage%";
      _showMotionFeedback = true;
    });

    _volumeAnimationController.forward().then((_) {
      _volumeAnimationController.reset();
    });

    _hideMotionFeedback();
  }

  void _handleMotionError() {
    setState(() {
      _lastAction = "❌ Error en sensores";
      _showMotionFeedback = true;
    });
    _hideMotionFeedback();
  }

  void _toggleMotionControl(bool enabled) {
    setState(() {
      _motionControlEnabled = enabled;
    });

    if (enabled) {
      _initializeMotionListener();
      setState(() {
        _lastAction = "Motion Control ON";
        _showMotionFeedback = true;
      });
    } else {
      _motionListener?.dispose();
      _motionListener = null;
      setState(() {
        _lastAction = "Motion Control OFF";
        _showMotionFeedback = true;
      });
    }

    _hideMotionFeedback();
  }

  void _hideMotionFeedback() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showMotionFeedback = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final track = audioController.currentTrack;

    if (track == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No track selected",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final totalMs = audioController.totalDuration.inMilliseconds;
    final currentMs = audioController.currentPosition.inMilliseconds;
    double sliderValue =
        (totalMs == 0) ? 0 : (currentMs / totalMs).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          const Text(
                            "My Playlist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_motionListener?.state ==
                              MotionListenerState.listening)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                ),
                              ),
                              child: const Text(
                                "Motion Control ON",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: _showMotionSettings,
                      ),
                    ],
                  ),
                ),

                Center(
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value *
                              10 *
                              (1 - _shakeAnimation.value) *
                              (DateTime.now().millisecondsSinceEpoch % 2 == 0
                                  ? 1
                                  : -1),
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        track.coverUrl,
                        width: 320,
                        height: 320,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF86CECB),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white70,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Track info
                Column(
                  children: [
                    Text(
                      track.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track.postedBy.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Slider + durations con indicador de volumen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Slider(
                        value: sliderValue,
                        onChanged:
                            audioController.currentlyLoading
                                ? null
                                : (value) {
                                  final newPosition =
                                      audioController.totalDuration * value;
                                  audioController.seek(newPosition);
                                },
                        activeColor: const Color(0xFF86CECB),
                        inactiveColor: Colors.white24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(audioController.currentPosition),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          // Indicador de volumen sutil
                          AnimatedBuilder(
                            animation: _volumeAnimation,
                            builder: (context, child) {
                              return AnimatedOpacity(
                                opacity: _volumeAnimation.value,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF86CECB,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _currentVolume > 0.5
                                            ? Icons.volume_up
                                            : _currentVolume > 0
                                            ? Icons.volume_down
                                            : Icons.volume_off,
                                        color: const Color(0xFF86CECB),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${(_currentVolume * 100).round()}%",
                                        style: const TextStyle(
                                          color: Color(0xFF86CECB),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(
                            formatDuration(audioController.totalDuration),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.shuffle,
                        color: Colors.white70,
                        size: 28,
                      ),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                        onPressed:
                            audioController.currentlyLoading
                                ? null
                                : () => audioController.seek(Duration.zero),
                      ),
                      IconButton(
                        iconSize: 64,
                        icon:
                            audioController.currentlyLoading
                                ? const CircularProgressIndicator(
                                  color: Color(0xFF86CECB),
                                )
                                : Icon(
                                  audioController.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                ),
                        onPressed:
                            audioController.currentlyLoading
                                ? null
                                : () {
                                  if (audioController.isPlaying) {
                                    audioController.pause();
                                  } else {
                                    audioController.play();
                                  }
                                },
                      ),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                        onPressed:
                            audioController.currentlyLoading
                                ? null
                                : () => audioController.seek(
                                  audioController.totalDuration,
                                ),
                      ),
                      const Icon(Icons.repeat, color: Colors.white70, size: 28),
                    ],
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_showMotionControls())
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Motion Controls",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildMotionHint(
                                        Icons.vibration,
                                        "Shake\nPlay/Pause",
                                      ),
                                      const SizedBox(width: 24),
                                      _buildMotionHint(
                                        Icons.phone_android,
                                        "Tilt\nVolume",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.devices),
                            tooltip: 'Cambiar dispositivo',
                            onPressed: () {
                              showDevicesBottomSheet(context, (device) {
                                print(
                                  '🎧 Conectarse a canal del dispositivo ${device.deviceId}',
                                );
                                final ws = Provider.of<WsServices>(
                                  context,
                                  listen: false,
                                );
                                ws.connect(device.deviceId);
                              });
                            },
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (_showMotionFeedback && _lastAction.isNotEmpty)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _showMotionFeedback ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF86CECB).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _lastAction,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotionHint(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  bool _showMotionControls() {
    return _motionListener?.state == MotionListenerState.listening &&
        _showMotionFeedback;
  }

  void _showMotionSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Motion Controls",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enable Motion Controls",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Switch(
                      value: _motionControlEnabled,
                      onChanged: _toggleMotionControl,
                      activeColor: const Color(0xFF86CECB),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        _motionListener?.state == MotionListenerState.listening
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _motionListener?.state ==
                                  MotionListenerState.listening
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _motionListener?.state == MotionListenerState.listening
                            ? Icons.sensors
                            : Icons.sensors_off,
                        color:
                            _motionListener?.state ==
                                    MotionListenerState.listening
                                ? Colors.green
                                : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _motionListener?.state == MotionListenerState.listening
                            ? "Sensors Active"
                            : "Sensors Inactive",
                        style: TextStyle(
                          color:
                              _motionListener?.state ==
                                      MotionListenerState.listening
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "How to use:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                _buildInstructionRow(
                  Icons.vibration,
                  "Shake your device",
                  "Play/Pause music",
                ),
                const SizedBox(height: 8),
                _buildInstructionRow(
                  Icons.phone_android,
                  "Tilt right",
                  "Increase volume",
                ),
                const SizedBox(height: 8),
                _buildInstructionRow(
                  Icons.phone_android,
                  "Tilt left",
                  "Decrease volume",
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86CECB),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Got it!",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String action, String result) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$action ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "→ $result",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _motionListener?.dispose();
    _shakeAnimationController.dispose();
    _volumeAnimationController.dispose();
    super.dispose();
  }
}
