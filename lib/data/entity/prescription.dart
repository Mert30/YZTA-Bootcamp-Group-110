class Prescription {
  final String id;
  final String barcode;
  final DateTime startDate;
  final DateTime finishDate;
  final String addedBy;

  Prescription({
    required this.id,
    required this.barcode,
    required this.startDate,
    required this.finishDate,
    required this.addedBy,
  });

  factory Prescription.fromFirestore(Map<String, dynamic> data, String docId) {
    return Prescription(
      id: docId,
      barcode: data['barcode'] ?? '',
      startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
      finishDate: DateTime.tryParse(data['finishDate'] ?? '') ?? DateTime.now(),
      addedBy: data['addedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'startDate': startDate.toIso8601String(),
      'finishDate': finishDate.toIso8601String(),
      'addedBy': addedBy,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
