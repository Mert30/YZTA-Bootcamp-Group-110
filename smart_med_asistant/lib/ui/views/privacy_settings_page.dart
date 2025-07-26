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

  final Color lightGreen = const Color(0xFF04BF8A);

  @override
  Widget build(BuildContext context) {
    // Beyaz taban + hafif yeşil ton:
    final Color pageBackgroundColor = Color.lerp(
      Colors.white,
      lightGreen,
      0.08,
    )!;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: lightGreen),
        title: Text(
          'Veri Yönetimi',
          style: TextStyle(
            color: lightGreen,
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
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.redAccent, width: 2),
            ),
            child: ListTile(
              title: Text(
                "Hesabını Sil",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                "Tüm verilerini ve hesabını kalıcı olarak sil.",
                style: TextStyle(color: Colors.black87),
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
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              "Bu seçenek açık olduğunda, uygulama kullanımı analiz edilmek üzere anonimleştirilmiş şekilde paylaşılır.",
              style: TextStyle(color: Colors.black),
            ),
            activeColor: lightGreen,
          ),
          CheckboxListTile(
            value: isKvkkApproved,
            onChanged: (val) {
              setState(() => isKvkkApproved = val ?? false);
            },
            title: const Text(
              "KVKK kapsamında kişisel verilerimin işlenmesini onaylıyorum",
              style: TextStyle(color: Colors.black),
            ),
            activeColor: lightGreen,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 24),
          const Text(
            "📄 Kişisel verilerin KVKK ve ilgili mevzuatlara uygun şekilde işlenir.",
            style: TextStyle(color: Colors.black),
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
        style: TextStyle(
          color: lightGreen,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoCard(String title, String content, {VoidCallback? onTap}) {
    final Color lightGreen = const Color(0xFF04BF8A);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shadowColor: lightGreen.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: lightGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                content,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final Color lightGreen = const Color(0xFF04BF8A);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Hesabı Sil",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          "Hesabınızı kalıcı olarak silmek istediğinize emin misiniz?",
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text(
              "İptal",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Sil", style: TextStyle(fontSize: 16)),
            onPressed: () async {
              Navigator.pop(context);
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
