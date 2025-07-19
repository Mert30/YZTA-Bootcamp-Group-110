import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:smart_med_assistant/ui/views/first_screen.dart';
import 'package:smart_med_assistant/ui/views/settings_page.dart';

import 'dashboard_page.dart';
import 'add_medicine_page.dart';
import 'patients_page.dart';
import 'stock_page.dart';

class PharmacistMainPage extends StatefulWidget {
  const PharmacistMainPage({super.key});

  @override
  State<PharmacistMainPage> createState() => _PharmacistMainPageState();
}

class _PharmacistMainPageState extends State<PharmacistMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    AddMedicinePage(),
    PatientsPage(),
    StockPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex.clamp(0, _pages.length - 1)],
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          backgroundColor: const Color(0xFF024059),
          activeColor: const Color(0xFF04BF8A),
          color: Colors.white,
          items: const [
            TabItem(icon: Icons.dashboard, title: 'Dashboard'),
            TabItem(icon: Icons.medication, title: 'İlaç Ekle'),
            TabItem(icon: Icons.people, title: 'Hastalar'),
            TabItem(icon: Icons.inventory, title: 'Stok'),
            TabItem(icon: Icons.settings, title: "Ayarlar"),
          ],
          initialActiveIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index.clamp(0, _pages.length - 1);
            });
          },
        ),
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 25;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(color: color, fontWeight: FontWeight.w500);
  }
}
