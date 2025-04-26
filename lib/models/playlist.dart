import 'package:jammies_app/models/user.dart';

class Playlist {
  String id;
  String name;
  String userId;
  User createdBy;
  String? description;
  String? coverUrl;
  int trackCount;

  Playlist({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.userId,
    required this.trackCount,
    this.description,
    this.coverUrl,
  });
}
