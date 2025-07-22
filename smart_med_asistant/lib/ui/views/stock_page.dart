import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  final Color darkBlue = const Color(0xFF024059);
  final Color mediumBlue = const Color(0xFF026873);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color darkGreen = const Color(0xFF025940);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen.withOpacity(0.15),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Stok Takibi",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Stok listesi
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stock')
                    .orderBy('productName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(child: Text('Stokta ilaç yok.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data()! as Map<String, dynamic>;

                      final productName = data['productName'] ?? 'İsimsiz İlaç';
                      final stockQuantity = data['stock_quantity'] ?? 0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: mediumBlue.withOpacity(0.15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          splashColor: lightGreen.withOpacity(0.3),
                          onTap: () {
                            // İlaç detay sayfası veya stok güncelleme açılabilir
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                color: lightGreen.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.local_pharmacy,
                                color: darkGreen,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              productName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: darkBlue,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "Stok: $stockQuantity kutu",
                              style: TextStyle(
                                color: mediumBlue.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: mediumBlue.withOpacity(0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
