import 'package:flutter/material.dart';
import 'package:smart_med_assistant/ui/views//add_medicine_page.dart';
import 'package:smart_med_assistant/ui/views//patients_page.dart';
import 'package:smart_med_assistant/ui/views//stock_page.dart';

class PharmacistPanelPage extends StatelessWidget {
  const PharmacistPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Hoş geldiniz 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "İşlemlerinizi aşağıdan seçebilirsiniz.",
                style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildPanelCard(
                      context,
                      title: "İlaç Ekle",
                      icon: Icons.add_box_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMedicinePage(),
                          ),
                        );
                      },
                    ),
                    _buildPanelCard(
                      context,
                      title: "Hastalarım",
                      icon: Icons.people_alt_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PatientsPage(),
                          ),
                        );
                      },
                    ),
                    _buildPanelCard(
                      context,
                      title: "Stok",
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StockPage(),
                          ),
                        );
                      },
                    ),
                    _buildPanelCard(
                      context,
                      title: "Bildirimler",
                      icon: Icons.notifications,
                      onTap: () {
                        // Bildirimler sayfası eklenecek
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.teal.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal.shade700, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
