import 'package:flutter/material.dart';
import 'package:smart_med_assistant/ui/views/add_medicine_page.dart';
import 'package:smart_med_assistant/ui/views/patients_page.dart';
import 'package:smart_med_assistant/ui/views/stock_page.dart';

class PharmacistPanelPage extends StatelessWidget {
  const PharmacistPanelPage({super.key});

  // Renkler
  final Color darkBlue = const Color(0xFF024059);
  final Color mediumBlue = const Color(0xFF026873);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color darkGreen = const Color(0xFF025940);
  final Color brightGreen = const Color(0xFF03A64A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen.withOpacity(
        0.1,
      ), // Hafif açık yeşil arka plan
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "İşlemlerinizi aşağıdan seçebilirsiniz.",
                style: TextStyle(
                  fontSize: 16,
                  color: darkGreen.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildPanelCard(
                      context,
                      title: "İlaç Ekle",
                      icon: Icons.add_box_outlined,
                      iconBgColor: brightGreen.withOpacity(0.2),
                      iconColor: brightGreen,
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
                      iconBgColor: mediumBlue.withOpacity(0.2),
                      iconColor: mediumBlue,
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
                      iconBgColor: darkGreen.withOpacity(0.2),
                      iconColor: darkGreen,
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
                      iconBgColor: brightGreen.withOpacity(0.2),
                      iconColor: brightGreen,
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
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: iconColor.withOpacity(0.3),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, color: iconColor, size: 40),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
