import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/entity/prescription.dart';

class PrescriptionDetailPage extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionDetailPage({super.key, required this.prescription});

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlaç Detayları"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Barkod: ${prescription.barcode}",
                      style: titleStyle()),
                  const SizedBox(height: 16),

                  Text("Başlangıç Tarihi: ${formatDate(prescription.startDate)}"),
                  Text("Bitiş Tarihi: ${formatDate(prescription.finishDate)}"),
                  const SizedBox(height: 24),

                  if (prescription.descriptionAI != null)
                    buildSection("1. İlaç Açıklaması", prescription.descriptionAI!),

                  if (prescription.usageAI != null)
                    buildSection("2. Kullanım Talimatı", prescription.usageAI!),

                  if (prescription.sideEffectsAI != null)
                    buildSection("3. Yan Etkiler", prescription.sideEffectsAI!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle titleStyle() => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.teal,
  );

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle()),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
