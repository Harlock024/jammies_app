import 'dart:convert';

import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/api_client.dart';

class FavoriteTrackService {
  final _client = ApiClient();

  Future<List<Track>> fetchFavoriteTracks() async {
    final response = await _client.get('/favorite_tracks');

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Track.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load favorite tracks');
    }
  }

  Future<Track> addTrackToFavorite(String trackId) async {
    final response = await _client.post('/favorite_tracks', {
      'track_id': trackId,
    });
    if (response.statusCode == 200) {
      return Track.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add track to favorites');
    }
  }

  Future<void> removeTrackToFavorite(String trackId) async {
    final repo = await _client.delete('/favorite_tracks/$trackId');
    if (repo.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to remove track from favorites');
    }
  }
}
