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
      backgroundColor: const Color(0xFFEFF5F4),
      appBar: AppBar(
        title: const Text("İlaç Detayları"),
        backgroundColor: const Color(0xFF024059),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildMainCard(),
              const SizedBox(height: 24),
              if (prescription.descriptionAI != null)
                buildInfoCard(
                  "1. İlaç Açıklaması",
                  prescription.descriptionAI!,
                ),
              if (prescription.usageAI != null)
                buildInfoCard("2. Kullanım Talimatı", prescription.usageAI!),
              if (prescription.sideEffectsAI != null)
                buildInfoCard("3. Yan Etkiler", prescription.sideEffectsAI!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Barkod: ${prescription.barcode}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF026873),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Başlangıç Tarihi:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(formatDate(prescription.startDate)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bitiş Tarihi:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(formatDate(prescription.finishDate)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String content) {
    return Card(
      color: Colors.white54, // Arka planı beyaz yaptık
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(
                  0xFF026873,
                ), // Başlık rengini biraz daha yumuşattık
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Color(0xFF333333), // İçeriği daha nötr koyu griye aldık
              ),
            ),
          ],
        ),
      ),
    );
  }
}
