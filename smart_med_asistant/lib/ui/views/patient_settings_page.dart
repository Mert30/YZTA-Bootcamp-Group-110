import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_med_assistant/ui/views/first_screen.dart';
import 'package:smart_med_assistant/ui/views/patient_reset_password_page.dart';
import 'package:smart_med_assistant/ui/views/support_page.dart';

class PatientSettingsPage extends StatefulWidget {
  const PatientSettingsPage({super.key});

  @override
  State<PatientSettingsPage> createState() => _PatientSettingsPageState();
}

class _PatientSettingsPageState extends State<PatientSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _notificationsEnabled = true;

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Burada bildirim ayarları Firestore veya local preferences kaydedilebilir
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: const Color(0xFF04BF8A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bildirim Ayarları
          SwitchListTile(
            title: const Text(
              'Bildirimler',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            subtitle: const Text(
              'Uygulama bildirimlerini aç/kapat',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: const Color(0xFF04BF8A),
          ),

          const Divider(),

          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF04BF8A).withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.lock_outline, color: Color(0xFF04BF8A)),
            ),
            title: const Text(
              'Şifremi Değiştir',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientResetPasswordPage(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF04BF8A).withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.support_agent, color: Color(0xFF04BF8A)),
            ),
            title: const Text(
              'Destek / Geri Bildirim',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
          ),

          const Divider(),

          // Uygulama Hakkında
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF04BF8A)),
            title: const Text(
              'Uygulama Hakkında',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            subtitle: const Text(
              'Versiyon 1.0.0',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MediMate',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.favorite,
                  color: Color(0xFF04BF8A),
                ),
                children: [
                  const Text(
                    'Bu uygulama hasta ve ilaç takibi için geliştirilmiştir.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Geliştirici: MediMate Squad 110',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Mail: support@medimate.com',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 40),

          // Çıkış Yap Butonu
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Çıkış Yap'),
                  content: const Text(
                    'Uygulamadan çıkmak istediğinize emin misiniz?',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('İptal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _signOut();
                      },
                      child: const Text('Çıkış Yap'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white, size: 18),
            label: const Text(
              'Çıkış Yap',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF04BF8A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
