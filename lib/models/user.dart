class User {
  String id;
  String email;
  String? username;
  String name;
  String? avatarUrl;
  String? bio;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.avatarUrl,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
    );
  }
}
