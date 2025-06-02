class Track {
  String id;
  String title;
  String postedBy; // mejor nombre que artist, según JSON
  String album;
  double duration;
  String coverUrl;
  bool isFavorite;

  Track({
    required this.id,
    required this.title,
    required this.postedBy,
    required this.album,
    required this.duration,
    required this.coverUrl,
    required this.isFavorite,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      postedBy: json['posted_by'] ?? '',
      album: json['album'] ?? '',
      duration:
          (json['duration'] != null)
              ? (json['duration'] as num).toDouble()
              : 0.0,
      coverUrl: json['cover_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posted_by': postedBy,
      'album': album,
      'duration': duration,
      'cover_url': coverUrl,
      'is_favorite': isFavorite,
    };
  }
}
