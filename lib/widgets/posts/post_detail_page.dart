import 'package:flutter/material.dart';
import 'package:jammies_app/models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.author.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            if (post.imageUrl != null)
              Image.network(post.imageUrl!),
          ],
        ),
      ),
    );
  }
}
