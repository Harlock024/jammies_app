class User {
  String id;
  String? username;
  String email;
  String? name;
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
      name: json['name'],
      email: json['email'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }
}
