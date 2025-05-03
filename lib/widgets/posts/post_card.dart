import 'package:flutter/material.dart';
import 'package:jammies_app/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    post.author.avatarUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      post.timestamp,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(post.content, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 12),

            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(post.imageUrl!, fit: BoxFit.cover),
              ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionWithCounter(
                  icon:
                      post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                  label: 'Like',
                  count: post.likesCount,
                  iconColor: post.isLikedByMe ? Colors.red : Colors.grey[700],
                ),
                _ActionWithCounter(
                  icon: Icons.mode_comment_outlined,
                  label: 'Comment',
                  count: post.commentsCount,
                ),
                _ActionWithCounter(icon: Icons.share, label: 'Share'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionWithCounter extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final Color? iconColor;

  const _ActionWithCounter({
    required this.icon,
    required this.label,
    this.count,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          count != null ? '$count' : label,
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
      ],
    );
  }
}
