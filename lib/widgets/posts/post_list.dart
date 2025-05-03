import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_post.dart';
import 'package:jammies_app/widgets/posts/post_card.dart';
import 'package:jammies_app/widgets/posts/post_skeleton_card.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          final post = mockPosts[index];
          // null is not null for now, but we should handle null cases properly
          final bool isValid =
              post != null &&
              post.title != null &&
              post.author.avatarUrl != null;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: isValid ? PostCard(post: post) : const PostCardSkeleton(),
          );
        },
      ),
    );
  }
}
