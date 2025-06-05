import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/providers/queue_controller.dart';
import 'package:jammies_app/services/track_services.dart';
import 'package:jammies_app/services/ws_services.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  bool get currentlyLoading => isLoading.value;
  AudioPlayer get player => _player;
  final TrackService trackService = TrackService();
  late QueueController queueController;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  String? _audioUrl;
  WsServices? _wsServices;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  bool _isSyncingFromWs = false;

  AudioController() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _player.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _player.onPositionChanged.listen((Duration position) {
      _currentPosition = position;
      notifyListeners();
    });

    _player.onDurationChanged.listen((Duration duration) {
      _totalDuration = duration;
      notifyListeners();
    });
    _player.onPlayerComplete.listen((event) async {
      _isPlaying = false;
      _currentPosition = Duration.zero;

      final hasNext = queueController.next();
      if (hasNext) {
        await playCurrentFromQueue();
      }
      notifyListeners();
    });
  }

  void setWsServices(WsServices ws) {
    _wsServices = ws;
  }

  Future<void> loadTrackFromWs(Track track, String audioUrl) async {
    _currentTrack = track;
    _audioUrl = null;
    notifyListeners();

    isLoading.value = true;
    try {
      _audioUrl = audioUrl;
      await _player.setSourceUrl(_audioUrl!);
      await Future.delayed(Duration(milliseconds: 200));
    } catch (e) {
      print('Error loading audio from WS: $e');
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  void selectTrack(Track track) {
    if (_currentTrack?.id == track.id) {
      print('⚠️ La misma canción ya está seleccionada. No se hace nada.');
      return;
    }

    _currentTrack = track;
    _audioUrl = null;
    notifyListeners();

    print('new track selected: ${track.id}');

    if (!_isSyncingFromWs) {
      _wsServices?.sendEvent(
        event: "playing",
        trackId: track.id,
        currentTime: 0,
      );
    }
  }

  Future<void> updateFromWs(Map<String, dynamic> data) async {
    print('updateFromWs called with data: $data');

    _isSyncingFromWs = true;
    try {
      if (data['event'] == 'request_state') {
        final targetRoom = data['target_room'];
        print('📥 Received request_state in room $targetRoom');

        if (_currentTrack != null && _audioUrl != null) {
          final response = {
            'event': _isPlaying ? 'playing' : 'paused',
            'track_id': _currentTrack!.id,
            'audio_url': _audioUrl,
            'current_time': _currentPosition.inMilliseconds / 1000.0,
            'target_room': targetRoom,
          };

          _wsServices?.sendRawJson(response);
          print('📤 Sent state_response to room $targetRoom');
        }
        return;
      }

      if (data['event'] != 'playing' &&
          data['event'] != 'paused' &&
          data['event'] != 'seek') {
        print('❌ Event not handled: ${data['event']}');
        return;
      }

      final trackId = data['track_id'] as String;
      final audioUrl = data['audio_url'] as String?;
      final currentTime = (data['current_time'] as num).toDouble();

      if (audioUrl != null && audioUrl != _audioUrl) {
        isLoading.value = true;

        if (_currentTrack == null || _currentTrack!.id != trackId) {
          final track = await trackService.fetchTrackById(trackId);
          await loadTrackFromWs(track, audioUrl);
          print('🎵 Track updated from WebSocket');
        } else {
          _audioUrl = audioUrl;
          await _player.setSourceUrl(_audioUrl!);
          await Future.delayed(Duration(milliseconds: 200));
        }

        isLoading.value = false;
      }

      final seekPosition = Duration(milliseconds: (currentTime * 1000).toInt());
      await _player.seek(seekPosition);

      if (data['event'] == 'playing') {
        await _player.resume();
        _isPlaying = true;
      } else if (data['event'] == 'paused') {
        await _player.pause();
        _isPlaying = false;
      }

      notifyListeners();
    } catch (e, stack) {
      print('❌ Error in updateFromWs: $e');
      print(' StackTrace: $stack');
      isLoading.value = false;
    } finally {
      _isSyncingFromWs = false;
    }
  }

  Future<void> playCurrentFromQueue() async {
    final track = queueController.current;
    if (track == null) return;

    _currentTrack = track;
    notifyListeners();

    _wsServices?.sendEvent(event: 'playing', trackId: track.id, currentTime: 0);
  }

  Future<void> play() async {
    if (_currentTrack == null || _audioUrl == null) return;

    try {
      if (_player.state == PlayerState.paused) {
        await _player.resume();
      } else {
        await _player.play(UrlSource(_audioUrl!));
      }
      _isPlaying = true;
      notifyListeners();

      if (!_isSyncingFromWs) {
        final currentTime = _currentPosition.inMilliseconds / 1000.0;
        _wsServices?.sendEvent(
          event: "playing",
          trackId: _currentTrack!.id,
          currentTime: currentTime,
        );
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    if (_currentTrack == null) return;

    await _player.pause();
    _isPlaying = false;
    notifyListeners();

    if (!_isSyncingFromWs) {
      final currentTime = _currentPosition.inMilliseconds / 1000.0;
      _wsServices?.sendEvent(
        event: "paused",
        trackId: _currentTrack!.id,
        currentTime: currentTime,
      );
    }
  }

  Future<void> seek(Duration position) async {
    if (_currentTrack == null) return;

    await _player.seek(position);

    if (!_isSyncingFromWs) {
      _wsServices?.sendEvent(
        event: "seek",
        trackId: _currentTrack!.id,
        currentTime: position.inMilliseconds / 1000.0,
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
