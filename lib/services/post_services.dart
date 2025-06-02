import 'dart:convert';

import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/services/api_client.dart';
import 'package:http/http.dart' as http;

class PostService {
  final _client = ApiClient();

  Future<List<Post>> fetchPosts() async {
    final response = await _client.get('/post');

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Post.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(
    String content,
    http.MultipartFile? imageFile,
    String? trackId,
  ) async {
    final fields = {
      'content': content,
      if (trackId != null) 'track_id': trackId,
    };

    final response = await _client.postMultipart(
      '/post',
      fields: fields,
      file: imageFile,
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear post: ${response.body}');
    }
  }
}
