import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/services/api_client.dart';
import 'package:dio/dio.dart';

class PostService {
  final _client = ApiClient();

  Future<List<Post>> fetchPosts() async {
    final response = await _client.get('/post');

    if (response.statusCode == 200) {
      final List postsJson = response.data;
      return postsJson.map((json) => Post.fromJson(json)).toList().cast<Post>();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(
    String content,
    MultipartFile? imageFile,
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
      throw Exception('Error al crear post: ${response.data}');
    }
  }
}
