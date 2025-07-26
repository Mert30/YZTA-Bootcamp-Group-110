import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'critical_stock_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Renk paleti
  final Color darkBlue = const Color(0xFF0D3B66);
  final Color mediumBlue = const Color(0xFF2A6F97);
  final Color lightBlue = const Color(0xFFB1D4E0);
  final Color softGreen = const Color(0xFF9BC1BC);
  final Color redAccent = Colors.redAccent.shade200;

  // Text Style
  final TextStyle titleStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0D3B66),
  );

  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 16,
    color: Color(0xFF557A95),
  );

  Future<String> getPharmacistName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        print("Giriş yapan kullanıcı yok.");
        return "Eczacım";
      }

      print("Giriş yapan email: ${user.email}");

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .where('role', isEqualTo: 'eczaci')
          .limit(1)
          .get();

      print("Eşleşen eczacı sayısı: ${query.docs.length}");

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        print("Gelen kullanıcı verisi: $data");
        return data['fullname'] ?? "Eczacı";
      } else {
        print("Eşleşen eczacı bulunamadı.");
        return "Eczacı";
      }
    } catch (e) {
      print("HATA: $e");
      return "Eczacı";
    }
  }

  Future<int> getTotalMedicineCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('stock').get();
    return snapshot.size;
  }

  Future<int> getCriticalStockCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('stock')
        .where('stock_quantity', isLessThan: 10)
        .get();
    return snapshot.size;
  }

  Widget buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      shadowColor: iconColor.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: iconColor, size: 36),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 6),
                    Text(subtitle, style: subtitleStyle),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGreen.withOpacity(0.15),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          children: [
            // Başlık
            FutureBuilder<String>(
              future: getPharmacistName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Hata: ${snapshot.error}',
                    style: TextStyle(color: darkBlue),
                  );
                }
                final name = snapshot.data ?? "Eczacım";
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hoşgeldiniz, $name 👋',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            FutureBuilder<int>(
              future: getTotalMedicineCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Hata: ${snapshot.error}');
                }
                final count = snapshot.data ?? 0;
                return buildCard(
                  icon: Icons.medication_rounded,
                  title: 'Toplam İlaç Sayısı',
                  subtitle: '$count adet kayıtlı ilaç var',
                  iconColor: mediumBlue,
                );
              },
            ),

            FutureBuilder<int>(
              future: getCriticalStockCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Hata: ${snapshot.error}');
                }
                final count = snapshot.data ?? 0;
                return buildCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Kritik Stok Sayısı',
                  subtitle: '$count ilacın stoğu kritik seviyede',
                  iconColor: redAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CriticalStockPage(),
                      ),
                    );
                  },
                );
              },
            ),

            buildCard(
              icon: Icons.people_alt_rounded,
              title: 'Toplam Hasta Sayısı',
              subtitle: 'Veri alınamadı (örnek gösterim)',
              iconColor: Colors.deepPurple.shade400,
            ),

            // Yeni Bildirimler kartı
            buildCard(
              icon: Icons.notifications_active_rounded,
              title: 'Bildirimler',
              subtitle: 'Yeni bildirim yok',
              iconColor: Colors.orange.shade700,
              onTap: () {
                // İstersen buraya bildirimler sayfası açılabilir
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bildirimler sayfası açılacak.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
