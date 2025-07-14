import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:smart_med_assistant/ui/views//dashboard_page.dart';
import 'package:smart_med_assistant/ui/views//add_medicine_page.dart';
import 'package:smart_med_assistant/ui/views//patients_page.dart';
import 'package:smart_med_assistant/ui/views//stock_page.dart';

class PharmacistMainPage extends StatefulWidget {
  const PharmacistMainPage({super.key});

  @override
  State<PharmacistMainPage> createState() => _PharmacistMainPageState();
}

class _PharmacistMainPageState extends State<PharmacistMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    PharmacistPanelPage(),
    AddMedicinePage(),
    PatientsPage(),
    StockPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.teal,
        activeColor: Colors.white,
        color: Colors.white70,
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.dashboard, title: 'Dashboard'),
          TabItem(icon: Icons.add_box_outlined, title: 'İlaç Ekle'),
          TabItem(icon: Icons.people_alt_outlined, title: 'Hastalar'),
          TabItem(icon: Icons.inventory_2_outlined, title: 'Stok'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
