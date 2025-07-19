class AppUser {
  final String fullname;
  final String email;
  final String role;
  final DateTime createdAt;

  AppUser({
    required this.fullname,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
