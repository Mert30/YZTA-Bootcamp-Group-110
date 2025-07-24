import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_med_assistant/ui/views/first_screen.dart';
import 'package:smart_med_assistant/ui/views/privacy_settings_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Açık tema için renkler
    final bgColor = Colors.grey[200]; // Açık gri zemin
    final cardColor = Colors.white;
    final primaryGreen = const Color(0xFF04BF8A);
    final darkText = Colors.grey[900];
    final mediumText = Colors.grey[700];
    final iconColor = const Color(0xFF04BF8A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Ayarlar',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _buildProfileCard(
            cardColor,
            primaryGreen,
            darkText,
            mediumText,
            iconColor,
          ),
          const SizedBox(height: 16),
          _buildSettingsOption(
            icon: Icons.notifications_active,
            title: 'Bildirimler',
            subtitle: 'İlaç hatırlatmaları, güncellemeler',
            onTap: () {},
            cardColor: cardColor,
            iconColor: iconColor,
            titleColor: darkText!,
            subtitleColor: mediumText!,
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
            cardColor: cardColor,
            iconColor: iconColor,
            titleColor: darkText,
            subtitleColor: mediumText,
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
            cardColor: cardColor,
            iconColor: iconColor,
            titleColor: darkText,
            subtitleColor: mediumText,
          ),
          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Çıkış Yap',
            subtitle: 'Hesaptan çık',
            onTap: () {
              _showLogoutDialog(context, primaryGreen, cardColor, darkText);
            },
            cardColor: cardColor,
            iconColor: iconColor,
            titleColor: darkText,
            subtitleColor: mediumText,
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
        SnackBar(
          content: const Text("Profil resmi güncellendi"),
          backgroundColor: Colors.green[600],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata oluştu: $e"),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  Widget _buildProfileCard(
    Color cardColor,
    Color primaryGreen,
    Color? darkText,
    Color? mediumText,
    Color iconColor,
  ) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return ListTile(
            title: Text(
              'Kullanıcı bilgisi bulunamadı.',
              style: TextStyle(color: darkText),
            ),
          );
        }

        final userData = snapshot.data!.data()!;
        final fullname = userData['fullname'] ?? 'Bilinmiyor';
        final email = userData['email'] ?? 'E-posta bulunamadı';
        final profileImageUrl = userData['profileImageUrl'];

        return Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: () => _selectAndUploadImage(context, uid!),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryGreen,
                    radius: 28,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.edit, size: 16, color: primaryGreen),
                    ),
                  ),
                ],
              ),
            ),

            title: Text(
              'Ecz. $fullname',
              style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(email, style: TextStyle(color: mediumText)),
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
    required Color cardColor,
    required Color iconColor,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: TextStyle(color: titleColor)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF212121),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    Color primaryGreen,
    Color cardColor,
    Color? darkText,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Çıkış Yap',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Hesabınızdan çıkmak istediğinizden emin misiniz?',
          style: TextStyle(color: darkText?.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: primaryGreen)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const FirstScreen()),
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
