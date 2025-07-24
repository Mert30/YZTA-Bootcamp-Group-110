import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF04BF8A);
    const Color backgroundColor = Color(0xFFF4F6F8);
    const Color headingColor = Color(0xFF1C1C1E);
    const Color textColor = Color(0xFF4A4A4A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF04BF8A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: backgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hakkında',
          style: TextStyle(
            color: backgroundColor,
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
                  color: headingColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text('v1.0.0', style: TextStyle(color: Colors.black45)),
              SizedBox(height: 24),
              Text(
                'MediMate, kullanıcıların sağlıklarını en iyi şekilde yönetebilmeleri için geliştirilmiş kapsamlı bir ilaç takip ve yönetim asistanıdır. '
                'Uygulama, ilaç kullanımını kolaylaştırırken, güvenli ve düzenli bir tedavi süreci sağlar.',
                style: TextStyle(color: textColor, fontSize: 16, height: 1.4),
              ),
              SizedBox(height: 16),
              Text(
                'Başlıca Özellikler:',
                style: TextStyle(
                  color: primaryColor,
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
                style: TextStyle(color: textColor, fontSize: 16, height: 1.4),
              ),
              SizedBox(height: 16),
              Text(
                'MediMate, kullanıcı dostu arayüzü ve gelişmiş teknolojisi ile sağlık yönetimini basitleştirir. '
                'Her yaştan kullanıcı için uygun olan bu uygulama, sağlığınıza değer verir ve tedavi sürecinizi destekler.',
                style: TextStyle(color: textColor, fontSize: 16, height: 1.4),
              ),
              SizedBox(height: 24),
              Text(
                'Bizimle iletişime geçmek için:',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'E-posta: support@medimate.com\n'
                'Web: www.medimate.com',
                style: TextStyle(color: textColor, fontSize: 16, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
