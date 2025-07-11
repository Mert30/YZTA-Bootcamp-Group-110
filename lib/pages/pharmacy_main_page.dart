import 'package:flutter/material.dart';
import 'package:smart_med_assistant/pages/add_medicine_page.dart';
import 'package:smart_med_assistant/pages/patients_page.dart';

class PharmacistMainPage extends StatelessWidget {
  const PharmacistMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Özel başlık
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Eczacı Paneli',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Butonlar
            _buildCardButton(
              context,
              label: 'İlaç Ekle',
              icon: Icons.add_box_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMedicinePage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCardButton(
              context,
              label: 'Hastalarım',
              icon: Icons.people_alt_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientsPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCardButton(
              context,
              label: 'Stok Takibi',
              icon: Icons.inventory_2_outlined,
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => StockPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.teal.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal.shade700, size: 32),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: Colors.teal.shade900,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
