class Playlist {
  String id;
  String name;
  String userId;
  String createdBy;
  String? description;
  String? coverUrl;

  Playlist({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.userId,
    this.description,
    this.coverUrl,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      createdBy: json['created_by'],

      description: json['description'],
      coverUrl: json['cover_url'],
    );
  }
}
