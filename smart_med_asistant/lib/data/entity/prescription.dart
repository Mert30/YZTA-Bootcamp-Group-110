class Prescription {
  final String id;
  final String barcode;
  final DateTime startDate;
  final DateTime finishDate;
  final String addedBy;

  // Kullanıcıdan gelen bilgiler
  final String dozaj;
  final String usageType; // Aç/Tok
  final String selectedTime; // Sabah/Öğle/Akşam

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
    required this.dozaj,
    required this.usageType,
    required this.selectedTime,
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
      'dozaj': dozaj,
      'usageType': usageType,
      'selectedTime': selectedTime,
      'descriptionAI': descriptionAI,
      'usageAI': usageAI,
      'sideEffectsAI': sideEffectsAI,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  factory Prescription.fromFirestore(Map<String, dynamic> map, String id) {
    return Prescription(
      id: id,
      barcode: map['barcode'] ?? '',
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      finishDate: DateTime.tryParse(map['finishDate'] ?? '') ?? DateTime.now(),
      addedBy: map['addedBy'] ?? '',
      dozaj: map['dozaj'] ?? '',
      usageType: map['usageType'] ?? '',
      selectedTime: map['selectedTime'] ?? '',
      descriptionAI: map['descriptionAI'],
      usageAI: map['usageAI'],
      sideEffectsAI: map['sideEffectsAI'],
    );
  }
}
