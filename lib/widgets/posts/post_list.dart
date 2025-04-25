import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jammies_app/mocks/mock_post.dart';
import 'package:jammies_app/widgets/posts/post_card.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          final post = mockPosts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: PostCard(post: post),
          );
        },
      ),
    );
  }
}
