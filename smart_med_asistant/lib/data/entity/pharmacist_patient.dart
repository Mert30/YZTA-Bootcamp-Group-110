class PharmacistPatient {
  final String email;
  final String fullname;

  PharmacistPatient({
    required this.email,
    required this.fullname,
  });

  factory PharmacistPatient.fromMap(Map<String, dynamic> map) {
    return PharmacistPatient(
      email: map['email'],
      fullname: map['fullname'],
    );
  }
}
