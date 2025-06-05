import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/providers/audio_player.dart';

class QueueController with ChangeNotifier {
  final List<Track> _queue = [];
  int _currentIndex = 0;

  late AudioController _audioController;

  List<Track> get queue => _queue;
  Track? get current {
    if (_queue.isEmpty || _currentIndex < 0 || _currentIndex >= _queue.length) {
      return null;
    }
    return _queue[_currentIndex];
  }

  void setAudioController(AudioController audioController) {
    _audioController = audioController;
  }

  void addToQueue(Track track) {
    _queue.add(track);
    notifyListeners();
  }

  void addTracks(List<Track> tracks) {
    _queue.addAll(tracks);
    print('QueueController initialized $queue');
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index < _queue.length) {
      _queue.removeAt(index);
      if (_queue.isEmpty) {
        _currentIndex = 0;
      } else if (_currentIndex >= _queue.length) {
        _currentIndex = _queue.length - 1;
      }
      notifyListeners();
    }
  }

  void clearQueue() {
    _queue.clear();
    _currentIndex = 0;
    notifyListeners();
  }

  bool next() {
    print(
      'next() called, currentIndex: $_currentIndex, queue length: ${_queue.length}',
    );
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      print('Playing next track, new index: $_currentIndex');
      _audioController.playCurrentFromQueue();
      notifyListeners();
      return true;
    }
    print('No next track available');
    return false;
  }

  bool previous() {
    if (_currentIndex > 0) {
      _currentIndex--;
      playAt(_currentIndex);
      _audioController.playCurrentFromQueue();

      notifyListeners();
      return true;
    }
    return false;
  }

  void playAt(int index) {
    if (index >= 0 && index < _queue.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
