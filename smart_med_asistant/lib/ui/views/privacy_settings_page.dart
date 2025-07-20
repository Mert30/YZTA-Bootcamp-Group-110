import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool isDataSharingEnabled = false;
  bool isKvkkApproved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF011627),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF04BF8A)),
        title: const Text(
          'Veri Yönetimi',
          style: TextStyle(
            color: Color(0xFF04BF8A),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("🔐 Kişisel Veriler"),
          _infoCard(
            "Toplanan Veriler",
            "Ad, e-posta, profil fotoğrafı gibi bilgiler Firebase üzerinde saklanır.",
          ),
          _infoCard(
            "Kullanım Amaçları",
            "Kişiselleştirme, bildirim gönderimi ve kullanıcı deneyimini iyileştirme.",
          ),
          const SizedBox(height: 24),
          _sectionTitle("📱 Uygulama İzinleri"),
          _infoCard("Kamera", "İlaç barkodlarını taramak için gereklidir."),
          _infoCard(
            "Bildirimler",
            "İlaç hatırlatmalarını zamanında alabilmeniz için kullanılır.",
          ),
          _infoCard(
            "Depolama",
            "Profil fotoğrafı yüklemek için galeri erişimine ihtiyaç duyar.",
          ),
          const SizedBox(height: 24),
          _sectionTitle("🛠️ Veri Kontrolleri"),
          // KIRMIZI HESABI SİL BUTONU
          Card(
            color: const Color(0xFF330000),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: const Text(
                "Hesabını Sil",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                "Tüm verilerini ve hesabını kalıcı olarak sil.",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              onTap: () => _showDeleteDialog(context),
            ),
          ),
          _infoCard(
            "Veri İndirme",
            "Yakında eklenecek. Verilerini indirip inceleyebileceksin.",
          ),
          const SizedBox(height: 24),

          _sectionTitle("📊 Veri İzinleri"),
          SwitchListTile(
            value: isDataSharingEnabled,
            onChanged: (val) {
              setState(() => isDataSharingEnabled = val);
            },
            title: const Text(
              "Analiz Amaçlı Anonim Veri Paylaşımına İzin Ver",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Bu seçenek açık olduğunda, uygulama kullanımı analiz edilmek üzere anonimleştirilmiş şekilde paylaşılır.",
              style: TextStyle(color: Colors.white70),
            ),
            activeColor: const Color(0xFF04BF8A),
          ),

          CheckboxListTile(
            value: isKvkkApproved,
            onChanged: (val) {
              setState(() => isKvkkApproved = val ?? false);
            },
            title: const Text(
              "KVKK kapsamında kişisel verilerimin işlenmesini onaylıyorum",
              style: TextStyle(color: Colors.white),
            ),
            activeColor: const Color(0xFF04BF8A),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          const SizedBox(height: 24),
          const Text(
            "📄 Kişisel verilerin KVKK ve ilgili mevzuatlara uygun şekilde işlenir.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF04BF8A),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoCard(String title, String content, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF022B42),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(content, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF022B42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hesabı Sil",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Hesabınızı kalıcı olarak silmek istediğinize emin misiniz?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("İptal", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Sil"),
            onPressed: () async {
              Navigator.pop(context); // dialogu kapat
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Hesabınız silindi."),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Hata: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
