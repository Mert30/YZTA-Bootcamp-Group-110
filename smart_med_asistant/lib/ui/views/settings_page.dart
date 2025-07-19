import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF011627),
        elevation: 0,
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Color(0xFF04BF8A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildSettingsOption(
            icon: Icons.notifications_active,
            title: 'Bildirimler',
            subtitle: 'İlaç hatırlatmaları, güncellemeler',
            onTap: () {},
          ),
          _buildSettingsOption(
            icon: Icons.color_lens,
            title: 'Tema',
            subtitle: 'Açık/Koyu mod ayarı',
            onTap: () {},
          ),
          _buildSettingsOption(
            icon: Icons.lock,
            title: 'Gizlilik',
            subtitle: 'Veri yönetimi ve izinler',
            onTap: () {},
          ),
          _buildSettingsOption(
            icon: Icons.info_outline,
            title: 'Hakkında',
            subtitle: 'Uygulama bilgileri',
            onTap: () {},
          ),
          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Çıkış Yap',
            subtitle: 'Hesaptan çık',
            onTap: () {
              // TODO: Firebase logout işlemi
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      color: const Color(0xFF022B42),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF04BF8A),
          radius: 28,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        title: const Text(
          'Ecz. Ahmet Yılmaz',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'ahmet.yilmaz@example.com',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.edit, color: Colors.white54),
        onTap: () {
          // Profil düzenleme
        },
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF022B42),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF04BF8A), size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
