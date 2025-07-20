import 'package:flutter/material.dart';
import 'package:smart_med_assistant/ui/views/settings_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011627),
      appBar: AppBar(
        backgroundColor: const Color(0xFF011627),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF04BF8A)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          ),
        ),
        title: const Text(
          'Hakkında',
          style: TextStyle(
            color: Color(0xFF04BF8A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'MediMate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text('v1.0.0', style: TextStyle(color: Colors.white54)),
              SizedBox(height: 24),
              Text(
                'MediMate, kullanıcıların sağlıklarını en iyi şekilde yönetebilmeleri için geliştirilmiş kapsamlı bir ilaç takip ve yönetim asistanıdır. '
                'Uygulama, ilaç kullanımını kolaylaştırırken, güvenli ve düzenli bir tedavi süreci sağlar.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Başlıca Özellikler:',
                style: TextStyle(
                  color: Color(0xFF04BF8A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '• İlaç hatırlatmaları ile düzenli kullanım garantisi.\n'
                '• Barkod tarama ile ilaç bilgilerine hızlı erişim.\n'
                '• Kişisel profil ve sağlık bilgileri yönetimi.\n'
                '• Bildirimler sayesinde önemli uyarılardan haberdar olma.\n'
                '• Güvenli veri saklama ve gizlilik politikalarına tam uyum.\n',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'MediMate, kullanıcı dostu arayüzü ve gelişmiş teknolojisi ile sağlık yönetimini basitleştirir. '
                'Her yaştan kullanıcı için uygun olan bu uygulama, sağlığınıza değer verir ve tedavi sürecinizi destekler.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Bizimle iletişime geçmek için:',
                style: TextStyle(
                  color: Color(0xFF04BF8A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'E-posta: support@medimate.com\n'
                'Web: www.medimate.com',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
