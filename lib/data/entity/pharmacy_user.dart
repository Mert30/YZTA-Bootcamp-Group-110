import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyUser {
  final String fullname;
  final String email;
  final String role;
  final DateTime createdAt;

  PharmacyUser({
    required this.fullname,
    required this.email,
    this.role = 'eczaci',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

