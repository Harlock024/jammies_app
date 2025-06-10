import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/api_client.dart';
import 'package:dio/dio.dart';

class TrackService {
  final _client = ApiClient();

  Future<List<Track>> fetchTracks() async {
    final response = await _client.get('/track');

    if (response.statusCode == 200) {
      final List<dynamic> trackList = response.data;
      final tracks =
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
      final trackJson = response.data as Map<String, dynamic>;
      final track = Track.fromJson(trackJson);
      return track;
    } else {
      throw Exception('Failed to load track');
    }
  }

  Future<bool> createTrack(
    String title,
    MultipartFile audio,
    MultipartFile cover,
  ) async {
    final response = await _client.postTrack('/track', title, audio, cover);
    return response.statusCode == 201;
  }
}
