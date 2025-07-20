import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF03A64A).withOpacity(0.9);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                "Hoş Geldiniz, Eczacım!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF024059),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatCard(
                    "Toplam İlaç",
                    "112",
                    Icons.medical_services,
                    cardColor,
                  ),
                  _buildStatCard(
                    "Kritik Stok",
                    "4",
                    Icons.warning_amber_rounded,
                    Colors.redAccent,
                  ),
                  _buildStatCard(
                    "Hasta Sayısı",
                    "36",
                    Icons.people,
                    const Color(0xFF026873),
                  ),
                  _buildStatCard(
                    "Bugünkü Satış",
                    "₺1.340",
                    Icons.attach_money,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF04BF8A).withOpacity(0.2),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "📌 Not: Son kullanma tarihi yaklaşan 3 ilaç var. Stok takibini unutmayın!",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 4)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
