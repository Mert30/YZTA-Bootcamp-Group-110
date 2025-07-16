class Prescription {
  final String id;
  final String barcode;
  final DateTime startDate;
  final DateTime finishDate;
  final String addedBy;

  // Gemini AI'dan gelen yanıtlar:
  final String? descriptionAI;
  final String? usageAI;
  final String? sideEffectsAI;

  Prescription({
    required this.id,
    required this.barcode,
    required this.startDate,
    required this.finishDate,
    required this.addedBy,
    this.descriptionAI,
    this.usageAI,
    this.sideEffectsAI,
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'startDate': startDate.toIso8601String(),
      'finishDate': finishDate.toIso8601String(),
      'addedBy': addedBy,
      'timestamp': DateTime.now().toIso8601String(),
      'descriptionAI': descriptionAI,
      'usageAI': usageAI,
      'sideEffectsAI': sideEffectsAI,
    };
  }

  factory Prescription.fromFirestore(Map<String, dynamic> map, String id) {
    return Prescription(
      id: id,
      barcode: map['barcode'] ?? '',
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      finishDate: DateTime.tryParse(map['finishDate'] ?? '') ?? DateTime.now(),
      addedBy: map['addedBy'] ?? '',
      descriptionAI: map['descriptionAI'],
      usageAI: map['usageAI'],
      sideEffectsAI: map['sideEffectsAI'],
    );
  }
}
