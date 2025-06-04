import 'package:flutter/material.dart';
import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/services/post_services.dart';
import 'package:jammies_app/widgets/posts/post_card.dart';
import 'package:jammies_app/widgets/posts/post_skeleton_card.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final PostService _postService = PostService();
  List<Post> posts = [];
  bool isLoading = true;

  Future<void> _fetchPost() async {
    try {
      setState(() {
        isLoading = true;
      });

      final fetchedPosts = await _postService.fetchPosts();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const PostCardSkeleton();
        },
      );
    }

    if (posts.isEmpty) {
      return const Center(
        child: Text(
          'No hay posts disponibles',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}
