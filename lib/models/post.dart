import 'package:jammies_app/models/user.dart';

class Post {
  String id;
  String title;
  String content;
  String userId;
  User author;
  final String timestamp;
  DateTime createdAt;
  bool isLikedByMe;
  String? imageUrl;
  int likesCount;
  int commentsCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.author,
    required this.timestamp,
    required this.createdAt,
    required this.isLikedByMe,
    required this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
  });
}
