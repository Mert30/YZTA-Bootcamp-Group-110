import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CriticalStockPage extends StatelessWidget {
  const CriticalStockPage({super.key});

  // Modern renk paleti
  final Color primaryColor = const Color(0xFF1E3A8A); // Koyu mavi
  final Color accentColor = const Color(0xFFF97316); // Turuncu
  final Color backgroundColor = const Color(0xFFF3F4F6); // Açık gri arka plan
  final Color cardColor = Colors.white;

  Stream<QuerySnapshot> getCriticalStockStream() {
    return FirebaseFirestore.instance
        .collection('stock')
        .where('stock_quantity', isLessThan: 10)
        .orderBy('stock_quantity')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Kritik Stoktaki İlaçlar',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.6),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.5),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCriticalStockStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hata: ${snapshot.error}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Kritik seviyede stokta ilaç yok.',
                style: TextStyle(
                  color: primaryColor.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = docs[index].data()! as Map<String, dynamic>;
              final productName = data['productName'] ?? 'İsimsiz İlaç';
              final stockQuantity = data['stock_quantity'] ?? 0;

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
                shadowColor: Colors.black26,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: accentColor,
                      size: 32,
                    ),
                  ),
                  title: Text(
                    productName,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: accentColor),
                    ),
                    child: Text(
                      '$stockQuantity kutu',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
