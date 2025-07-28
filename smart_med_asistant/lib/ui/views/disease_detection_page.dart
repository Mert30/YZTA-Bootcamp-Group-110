import 'package:flutter/material.dart';

class DiseaseDetectionPage extends StatelessWidget {
  const DiseaseDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = [
      {"title": "Kalp Hastalığı", "icon": Icons.favorite, "onTap": () {}},
      {"title": "Diyabet", "icon": Icons.bloodtype, "onTap": () {}},
      {"title": "Göğüs Kanseri", "icon": Icons.search, "onTap": () {}},
      {"title": "Obezite / VKİ", "icon": Icons.monitor_weight, "onTap": () {}},
      {
        "title": "Gebelik Riskleri",
        "icon": Icons.pregnant_woman,
        "onTap": () {},
      },
      {"title": "Göz Hastalıkları", "icon": Icons.visibility, "onTap": () {}},
      {"title": "Akciğer Hastalıkları", "icon": Icons.air, "onTap": () {}},
      {
        "title": "Psikolojik Rahatsızlıklar",
        "icon": Icons.psychology,
        "onTap": () {},
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF04BF8A),
        centerTitle: true,
        title: const Text(
          'Hastalık Tespiti',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.health_and_safety,
              color: Color(0xFF04BF8A),
              size: 60,
            ),
            const SizedBox(height: 12),
            const Text(
              'Belirti analizi yapmak istediğiniz hastalığı seçin:',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF025940),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: diseases.map((disease) {
                  return _diseaseCard(
                    title: disease["title"] as String,
                    icon: disease["icon"] as IconData,
                    onTap: disease["onTap"] as VoidCallback,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diseaseCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF04BF8A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
