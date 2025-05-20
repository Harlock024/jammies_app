class UserResponse {
  String id;
  String username;
  String email;
  String? avatarUrl;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
