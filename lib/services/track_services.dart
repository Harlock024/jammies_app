import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jammies_app/models/track.dart';
import 'api_url.dart';

Future<List<Track>> fetchTracks() async {
  final url = Uri.parse('$ApiUrl/tracks');

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

// streaming api request
// TODO
