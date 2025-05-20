class TokensResponse {
  final String accessToken;
  final String refreshToken;

  TokensResponse({required this.accessToken, required this.refreshToken});

  factory TokensResponse.fromJson(Map<String, dynamic> json) {
    return TokensResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
