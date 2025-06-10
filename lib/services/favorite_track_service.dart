import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/api_client.dart';

class FavoriteTrackService {
  final _client = ApiClient();

  Future<List<Track>> fetchFavoriteTracks() async {
    final response = await _client.get('/favorite_tracks');

    if (response.statusCode == 200) {
      final List tracksJson = response.data;
      return tracksJson
          .map((json) => Track.fromJson(json))
          .toList()
          .cast<Track>();
    } else {
      throw Exception('Failed to load favorite tracks');
    }
  }

  Future<Track> addTrackToFavorite(String trackId) async {
    final response = await _client.post('/favorite_tracks', {
      'track_id': trackId,
    });

    if (response.statusCode == 200) {
      return Track.fromJson(response.data);
    } else {
      throw Exception('Failed to add track to favorites');
    }
  }

  Future<void> removeTrackToFavorite(String trackId) async {
    final response = await _client.delete('/favorite_tracks/$trackId');
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to remove track from favorites');
    }
  }
}
