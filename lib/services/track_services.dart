import 'dart:convert';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/api_client.dart';
import 'package:http/http.dart' as http;

class TrackService {
  final _client = ApiClient();

  Future<List<Track>> fetchTracks() async {
    final response = await _client.get('/track');

    if (response.statusCode == 200) {
      final List<dynamic> trackList = json.decode(response.body);
      final List<Track> tracks =
          trackList
              .map((item) => Track.fromJson(item as Map<String, dynamic>))
              .toList();

      return tracks;
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<Track> fetchTrackById(String id) async {
    final response = await _client.get('/track/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> trackJson = json.decode(response.body);
      final Track track = Track.fromJson(trackJson);

      return track;
    } else {
      throw Exception('Failed to load track');
    }
  }

  Future<bool> createTrack(
    String title,
    http.MultipartFile audio,
    http.MultipartFile cover,
  ) async {
    final response = await _client.postTrack('/track', title, audio, cover);
    if (response.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }
}
