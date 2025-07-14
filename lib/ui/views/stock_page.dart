import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Başlık ve geri tuşu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Stok Takibi",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44), // Geri tuşu ile simetri
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 10, // Firebase ile entegre olunca bu dinamik olacak
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.teal.withOpacity(0.2),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_pharmacy,
                        color: Colors.teal.shade700,
                      ),
                      title: Text("İlaç Adı $index"),
                      subtitle: Text("Stok: ${10 + index} kutu"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      onTap: () {
                        // İlaç detayları açılabilir  sonra yapılıcak.
                      },
                    ),
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
