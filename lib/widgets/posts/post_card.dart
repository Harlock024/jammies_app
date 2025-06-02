import 'package:flutter/material.dart';
import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/widgets/posts/post_detail_page.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(context),
              const SizedBox(height: 16),
              if (post.content != null && post.content!.trim().isNotEmpty)
                _buildPostText(),
              if (post.image != null && post.image!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildPostImage(),
              ],
              if (post.track != null) ...[
                const SizedBox(height: 12),
                TrackCard(track: post.track!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            post.postedBy.avatarUrl ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.postedBy.username ?? 'Usuario desconocido',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              post.createdAt ?? 'Fecha desconocida',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostText() {
    return Text(post.content!, style: const TextStyle(fontSize: 15));
  }

  Widget _buildPostImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        post.image!,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
            ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 180,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildTrackInfo() {
    final track = post.track!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              track.coverUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  track.postedBy,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  track.album,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
