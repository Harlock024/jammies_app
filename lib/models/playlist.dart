import 'package:jammies_app/models/user.dart';

class Playlist {
  String id;
  String name;
  String userId;
  User author;
  Playlist({
    required this.id,
    required this.name,
    required this.author,
    required this.userId,
  });
}
