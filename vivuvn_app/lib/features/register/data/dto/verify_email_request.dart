class VerifyEmailRequest {
  final String email;
  final String token;

  VerifyEmailRequest({required this.email, required this.token});

  Map<String, dynamic> toMap() {
    return {'email': email, 'token': token};
  }
}
