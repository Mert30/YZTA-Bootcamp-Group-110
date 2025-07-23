import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final Color darkBlue = const Color(0xFF024059);
  final Color mediumBlue = const Color(0xFF026873);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color darkGreen = const Color(0xFF025940);

  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

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

            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: "İlaç ara...",
                  prefixIcon: Icon(Icons.search, color: mediumBlue),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: lightGreen.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: darkGreen, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📦 Stok listesi
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

                  final filteredDocs = docs.where((doc) {
                    final data = doc.data()! as Map<String, dynamic>;
                    final name = (data['productName'] ?? '')
                        .toString()
                        .toLowerCase();
                    return name.contains(searchText);
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text('İlaç bulunamadı.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
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
                            // detay vs.
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
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 26,
                              ),
                              onPressed: () {
                                // silme dialogu
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange.shade800,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "İlacı Sil",
                                            style: TextStyle(
                                              color: darkBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        "$productName adlı ilacı silmek istediğinizden emin misiniz?",
                                        style: TextStyle(color: darkBlue),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            "İptal",
                                            style: TextStyle(
                                              color: mediumBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final messenger =
                                                ScaffoldMessenger.of(context);
                                            Navigator.of(context).pop();

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('stock')
                                                  .doc(doc.id)
                                                  .delete();
                                              messenger.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '$productName başarıyla silindi.',
                                                  ),
                                                  backgroundColor:
                                                      Colors.green.shade600,
                                                ),
                                              );
                                            } catch (e) {
                                              messenger.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Silme işlemi başarısız: $e',
                                                  ),
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Evet, Sil",
                                            style: TextStyle(
                                              color: Colors.red.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
