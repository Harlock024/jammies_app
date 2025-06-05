import 'package:flutter/material.dart';
import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/widgets/posts/post_detail_page.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Gris oscuro principal
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(context),
                  const SizedBox(height: 16),
                  if (post.content != null && post.content!.trim().isNotEmpty)
                    _buildPostText(),
                  if (post.image != null && post.image!.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _buildPostImage(),
                  ],
                  if (post.track != null) ...[
                    const SizedBox(height: 14),
                    _buildTrackSection(),
                  ],
                  const SizedBox(height: 8),
                  _buildPostActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.network(
              post.postedBy.avatarUrl ?? '',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(26),
                  ),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.postedBy.username ?? 'Usuario desconocido',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(post.createdAt ?? 'Fecha desconocida'),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // Botón de menú opcional
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.more_horiz,
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildPostText() {
    return Container(
      width: double.infinity,
      child: Text(
        post.content!,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image.network(
          post.image!,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error al cargar imagen',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cargando imagen...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrackSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: TrackCard(track: post.track!),
      ),
    );
  }

  Widget _buildPostActions() {
    return Row(
      children: [
        _buildActionButton(
          Icons.favorite_border,
          '0',
          Colors.red.withOpacity(0.8),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          Icons.chat_bubble_outline,
          '0',
          Colors.blue.withOpacity(0.8),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          Icons.share_outlined,
          '',
          Colors.green.withOpacity(0.8),
        ),
        const Spacer(),
        _buildActionButton(
          Icons.bookmark_border,
          '',
          Colors.yellow.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String count, Color color) {
    return GestureDetector(
      onTap: () {
        // Implementar acciones
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.white.withOpacity(0.7)),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              count,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return 'hace ${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return 'hace ${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return 'hace ${difference.inMinutes}m';
      } else {
        return 'ahora';
      }
    } catch (e) {
      return dateString;
    }
  }
}

// Versión alternativa más minimalista
class PostCardMinimal extends StatelessWidget {
  final Post post;

  const PostCardMinimal({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info simplificada
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          post.postedBy.avatarUrl ?? '',
                        ),
                        backgroundColor: Colors.grey[700],
                        child:
                            post.postedBy.avatarUrl == null
                                ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.white70,
                                )
                                : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post.postedBy.username ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (post.content != null &&
                      post.content!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      post.content!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (post.track != null) ...[
                    const SizedBox(height: 12),
                    TrackCard(track: post.track!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
