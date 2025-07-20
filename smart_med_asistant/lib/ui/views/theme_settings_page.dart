import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/main.dart';
import 'package:smart_med_assistant/ui/views/settings_page.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == AppThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF011627),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF04BF8A)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          ),
        ),
        title: const Text(
          'Tema Ayarları',
          style: TextStyle(
            color: Color(0xFF04BF8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF011627),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text(
              'Koyu Tema',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Uygulamanın temasını koyu ya da açık yap',
              style: TextStyle(color: Colors.white70),
            ),
            value: isDark,
            onChanged: (value) {
              themeCubit.toggleTheme();
            },
            activeColor: const Color(0xFF04BF8A),
          ),
        ],
      ),
    );
  }
}
