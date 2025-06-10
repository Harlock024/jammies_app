import 'package:dio/dio.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/api_client.dart';

class PlaylistServices {
  final _client = ApiClient();

  Future<List<Playlist>> fetchPlaylists() async {
    final response = await _client.get('/playlist');

    if (response.statusCode == 200) {
      final List playlistsJson = response.data;
      return playlistsJson
          .map((json) => Playlist.fromJson(json))
          .toList()
          .cast<Playlist>();
    } else {
      throw Exception('Failed to load playlists');
    }
  }

  Future<List<Playlist>> fetchUserPlaylists() async {
    final response = await _client.get('/playlist/user');

    if (response.statusCode == 200) {
      final List playlistsJson = response.data;
      return playlistsJson
          .map((json) => Playlist.fromJson(json))
          .toList()
          .cast<Playlist>();
    } else {
      throw Exception('Failed to load user playlists');
    }
  }

  Future<Playlist> createPlaylist(String name) async {
    final response = await _client.post('/playlist', {'name': name});
    if (response.statusCode == 201) {
      return Playlist.fromJson(response.data);
    } else {
      throw Exception('Failed to create playlist');
    }
  }

  Future<Playlist> updatePlaylist(
    String id,
    String name,
    String description,
    String? coverUrl,
  ) async {
    final body = {'name': name, 'description': description};

    if (coverUrl != null) {
      body['cover'] = coverUrl;
    }

    final response = await _client.put('/playlists/$id', body);

    if (response.statusCode == 200) {
      return Playlist.fromJson(response.data);
    } else {
      throw Exception('Failed to update playlist');
    }
  }

  Future<bool> deletePlaylist(String id) async {
    final response = await _client.delete('/playlist/$id');
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete playlist');
    }
  }

  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    final response = await _client.post('/playlist/$playlistId/tracks', {
      'track_id': trackId,
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to add track to playlist');
    }
  }

  Future<bool> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) async {
    final response = await _client.delete(
      '/playlist/$playlistId/tracks/$trackId',
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to remove track from playlist');
    }
  }

  Future<List<Track>> fetchTracksInPlaylist(String playlistId) async {
    final response = await _client.get('/playlist/$playlistId/tracks');

    if (response.statusCode == 200) {
      final List tracksJson = response.data;
      return tracksJson
          .map((json) => Track.fromJson(json))
          .toList()
          .cast<Track>();
    } else {
      throw Exception('Failed to fetch tracks in playlist');
    }
  }
}
