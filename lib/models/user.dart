class User {
  String id;
  String email;
  String name;
  String? avatarUrl;
  String? bio;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.bio,
  });
}
