import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_post.dart';
import 'package:jammies_app/widgets/posts/post_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 110;

    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: bottomPadding),
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
