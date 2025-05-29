import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jammies_app/models/track.dart';
import 'api_url.dart';

Future<List<Track>> fetchTracks() async {
  final url = Uri.parse('$ApiUrl/track');

  final response = await http.get(url);
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
  final url = Uri.parse('$ApiUrl/track/$id');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final Map<String, dynamic> trackJson = json.decode(response.body);
    final Track track = Track.fromJson(trackJson);

    return track;
  } else {
    throw Exception('Failed to load track');
  }
}
