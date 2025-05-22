class UserResponse {
  final String id;
  final String? name; // <- aceptar null
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;

  UserResponse({
    required this.id,
    this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
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
