import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/models/user.dart';

class Post {
  String id;
  String? content;
  String? image;
  User postedBy;
  Track? track;
  String? createdAt;

  Post({
    required this.id,
    this.content,
    this.image,
    required this.postedBy,
    this.track,
    this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    print('Post JSON: $json');

    return Post(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString(),
      image: json['image']?.toString(),
      postedBy: User.fromJson(json['posted_by'] ?? {}),
      track: json['track'] != null ? Track.fromJson(json['track']) : null,
      createdAt: json['created_at'],
    );
  }
}
