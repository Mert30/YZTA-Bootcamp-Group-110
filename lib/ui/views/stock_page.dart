import 'package:flutter/material.dart';
import 'package:smart_med_assistant/ui/views/pharmacy_main_page.dart';

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
            // Başlık ve geri tuşu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PharmacistMainPage(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(30),
                    splashColor: darkGreen.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, size: 28, color: darkBlue),
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
                          color: darkBlue,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                  ), // Geri tuşu ile simetri için boşluk
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 10, // Firebase ile dinamik olacak
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
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
                        // İlaç detayları sayfası açılabilir
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
                          "İlaç Adı $index",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: darkBlue,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Stok: ${10 + index} kutu",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
