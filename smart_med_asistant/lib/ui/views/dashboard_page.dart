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
  final Color darkBlue = const Color(0xFF024059);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color mediumBlue = const Color(0xFF026873);

  Future<String> getPharmacistName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return "Eczacım"; // Kullanıcı giriş yapmamışsa default isim
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null &&
          data['role'] == 'eczacı' &&
          data['fullName'] != null) {
        return data['fullName'] as String;
      }
    }
    return "Eczacı"; // Veri yoksa default isim
  }

  Future<int> getTotalMedicineCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('stock').get();
    return snapshot.size;
  }

  Future<int> getCriticalStockCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('stock')
        .where('stock_quantity', isLessThan: 5)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          leading: Icon(icon, color: iconColor, size: 40),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkBlue,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: darkBlue.withOpacity(0.7), fontSize: 16),
          ),
          trailing: onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey.shade400,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),

            // Hoşgeldiniz + Gerçek Eczacı İsmi
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
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Hoşgeldiniz, $name 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                );
              },
            ),

            // Toplam İlaç Sayısı
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
                  icon: Icons.medication,
                  title: 'Toplam İlaç Sayısı',
                  subtitle: '$count adet kayıtlı ilaç var',
                  iconColor: mediumBlue,
                );
              },
            ),

            // Kritik Stok Sayısı (Tıklanabilir)
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
                  iconColor: Colors.redAccent,
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

            // Placeholder Kart: Hasta Sayısı
            buildCard(
              icon: Icons.people,
              title: 'Toplam Hasta Sayısı',
              subtitle: 'Veri alınamadı (örnek gösterim)',
              iconColor: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
