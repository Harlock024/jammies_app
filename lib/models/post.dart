class Post {
  String id;
  String title;
  String content;
  String userId;
  String userName;
  String author;
  DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.userName,
    required this.author,
    required this.createdAt,
  });
}
