import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/ws_services.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  bool get currentlyLoading => isLoading.value;
  AudioPlayer get player => _player;

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

    _player.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    });
  }

  void setWsServices(WsServices ws) {
    _wsServices = ws;
  }

  void selectTrack(Track track) {
    if (_currentTrack?.id == track.id) {
      print('⚠️ La misma canción ya está seleccionada. No se hace nada.');
      return;
    }

    _currentTrack = track;
    _audioUrl = null;
    notifyListeners();

    print('🎵 Nueva canción seleccionada: ${track.id}');
    _wsServices?.sendEvent(event: "playing", trackId: track.id, currentTime: 0);
  }

  Future<void> updateFromWs(Map<String, dynamic> data) async {
    print('updateFromWs called with data: $data');
    try {
      if (data['event'] != 'playing' &&
          data['event'] != 'paused' &&
          data['event'] != 'seek') {
        print('❌ Event not handled: ${data['event']}');
        return;
      }

      final trackId = data['track_id'] as String;
      final audioUrl = data['audio_url'] as String?;
      final currentTime = (data['current_time'] as num).toDouble();
      print(
        ' Parsed data - TrackId: $trackId, AudioUrl: $audioUrl, CurrentTime: $currentTime',
      );

      // Si no hay track actual o es diferente al recibido
      if (_currentTrack == null || _currentTrack!.id != trackId) {
        print(
          '❌ Track ID no coincide o es null. Current: ${_currentTrack?.id}, Received: $trackId',
        );
        return;
      }

      print(
        ' Track ID matches. Processing WS event: ${data['event']} for track: $trackId',
      );

      // Si hay una nueva URL de audio, cargarla
      if (audioUrl != null && audioUrl != _audioUrl) {
        print(' Loading new audio URL: $audioUrl');
        print(' Player state before loading: ${_player.state}');

        isLoading.value = true;
        _audioUrl = audioUrl;

        try {
          print(' Calling _player.setSourceUrl...');
          await _player.setSourceUrl(audioUrl);
          print(' Audio URL loaded successfully');
          print(' Player state after loading: ${_player.state}');
        } catch (e) {
          print('❌ Error loading audio URL: $e');
          print(' Player state after error: ${_player.state}');
          isLoading.value = false;
          return;
        } finally {
          isLoading.value = false;
        }
      }

      // Hacer seek a la posición indicada
      final seekPosition = Duration(milliseconds: (currentTime * 1000).toInt());
      print(' Seeking to position: ${seekPosition.inSeconds}s');
      await _player.seek(seekPosition);
      print(' Seeked to position: ${seekPosition.inSeconds}s');

      // Ejecutar la acción según el evento
      if (data['event'] == 'playing') {
        print(' Starting playback...');
        print(' Player state before play: ${_player.state}');
        await _player.resume();
        _isPlaying = true;
        print('Playback started. Player state: ${_player.state}');
      } else if (data['event'] == 'paused') {
        print(' Pausing playback...');
        await _player.pause();
        _isPlaying = false;
        print(' Playback paused');
      } else if (data['event'] == 'seek') {
        print(' Seek completed');
      }

      notifyListeners();
      print(
        ' WS event processed successfully. IsPlaying: $_isPlaying, PlayerState: ${_player.state}',
      );
    } catch (e, stackTrace) {
      print('❌ Error in updateFromWs: $e');
      print(' StackTrace: $stackTrace');
      isLoading.value = false;
    }
  }

  Future<void> play() async {
    if (_currentTrack == null) {
      print('No current track to play');
      return;
    }

    if (_audioUrl == null) {
      print('No audio URL available');
      return;
    }

    try {
      if (_player.state == PlayerState.paused) {
        await _player.resume();
      } else {
        await _player.play(UrlSource(_audioUrl!));
      }
      _isPlaying = true;
      notifyListeners();

      final currentTime = _currentPosition.inMilliseconds / 1000.0;
      _wsServices?.sendEvent(
        event: "playing",
        trackId: _currentTrack!.id,
        currentTime: currentTime,
      );
      print('Play command sent via WS');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    if (_currentTrack == null) return;

    try {
      await _player.seek(position);
      _wsServices?.sendEvent(
        event: "seek",
        trackId: _currentTrack!.id,
        currentTime: position.inMilliseconds / 1000.0,
      );
      print('Seek to ${position.inSeconds}s');
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  Future<void> pause() async {
    if (_currentTrack == null) {
      print('No current track to pause');
      return;
    }

    try {
      final currentTime = _currentPosition.inMilliseconds / 1000.0;
      _wsServices?.sendEvent(
        event: "paused",
        trackId: _currentTrack!.id,
        currentTime: currentTime,
      );

      await _player.pause();
      _isPlaying = false;
      notifyListeners();
      print('Pause command sent via WS');
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
