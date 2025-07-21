import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_med_assistant/ui/views/pharmacy_login_page.dart';
import 'package:smart_med_assistant/ui/views/privacy_settings_page.dart';
import 'package:smart_med_assistant/ui/views/theme_settings_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Giriş sayfası varsa import et
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF011627),
        elevation: 0,
        automaticallyImplyLeading: false,
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

          // Burada SwitchListTile ile tema ayarı eklendi
          _buildSettingsOption(
            icon: Icons.color_lens,
            title: 'Tema',
            subtitle: 'Açık/Koyu mod ayarı',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ThemeSettingsPage()),
              );
            },
          ),

          _buildSettingsOption(
            icon: Icons.lock,
            title: 'Gizlilik',
            subtitle: 'Veri yönetimi ve izinler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacySettingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.info_outline,
            title: 'Hakkında',
            subtitle: 'Uygulama bilgileri',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Çıkış Yap',
            subtitle: 'Hesaptan çık',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectAndUploadImage(BuildContext context, String uid) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$uid.jpg',
      );

      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImageUrl': downloadUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil resmi güncellendi"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata oluştu: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildProfileCard() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const ListTile(
            title: Text(
              'Kullanıcı bilgisi bulunamadı.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final userData = snapshot.data!.data()!;
        final fullname = userData['fullname'] ?? 'Bilinmiyor';
        final email = userData['email'] ?? 'E-posta bulunamadı';
        final profileImageUrl = userData['profileImageUrl'];

        return Card(
          color: const Color(0xFF022B42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: () => _selectAndUploadImage(context, uid!),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF04BF8A),
                radius: 28,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
              ),
            ),
            title: Text(
              'Ecz. $fullname',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              email,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.edit, color: Colors.white54),
            onTap: () {
              _selectAndUploadImage(context, uid!);
            },
          ),
        );
      },
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF022B42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Çıkış Yap',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Hesabınızdan çıkmak istediğinizden emin misiniz?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF04BF8A),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => PharmacyLoginPage()),
                (route) => false,
              );
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }
}
