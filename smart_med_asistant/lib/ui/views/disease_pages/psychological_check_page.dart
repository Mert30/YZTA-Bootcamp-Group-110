import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';

class PsychologicalCheckPage extends StatefulWidget {
  const PsychologicalCheckPage({super.key});

  @override
  State<PsychologicalCheckPage> createState() => _PsychologicalCheckPageState();
}

class _PsychologicalCheckPageState extends State<PsychologicalCheckPage> {
  final List<String> questions = [
    "Son zamanlarda kendinizi sık sık üzgün veya umutsuz hissediyor musunuz?",
    "Uyku düzeninizde belirgin bir değişiklik oldu mu?",
    "Günlük aktivitelerinize karşı ilginizi kaybettiniz mi?",
    "Kendinize ya da çevrenizdekilere zarar verme düşünceniz oldu mu?",
    "Aşırı yorgunluk veya enerjisizlik hissediyor musunuz?",
    "Kendinize olan güveninizde azalma var mı?",
    "Anksiyete (kaygı) belirtileri yaşıyor musunuz?",
  ];

  final Map<int, bool?> answers = {};

  bool get isComplete => answers.length == questions.length;

  String getResultMessage() {
    final positiveCount = answers.values.where((e) => e == true).length;

    if (positiveCount >= 5) {
      return "Yüksek riskli belirtiler tespit edildi. Lütfen bir uzmandan profesyonel destek almayı ihmal etmeyin.";
    } else if (positiveCount >= 3) {
      return "Bazı riskli durumlar gözlemlendi. Takip etmeniz ve gerekirse bir uzmana danışmanız önerilir.";
    } else {
      return "Herhangi bir ciddi belirti gözlemlenmedi. Ancak psikolojik sağlığınızı düzenli olarak kontrol etmek önemlidir.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFEF5),
      body: SafeArea(
        child: Column(
          children: [
            // Başlık ve Geri Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF04BF8A),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiseaseDetectionPage(),
                      ),
                    ),
                  ),
                  Text(
                    "Psikolojik Durum Analizi",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF024059),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Motive Edici Cümle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Unutmayın, ruh sağlığı da beden sağlığı kadar değerlidir. Kendinize zaman ayırın.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF04BF8A),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sorular
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text("Evet"),
                                  value: true,
                                  groupValue: answers[index],
                                  onChanged: (value) =>
                                      setState(() => answers[index] = value),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: const Text("Hayır"),
                                  value: false,
                                  groupValue: answers[index],
                                  onChanged: (value) =>
                                      setState(() => answers[index] = value),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Sonuç Butonu
            if (isComplete)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF04BF8A),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final result = getResultMessage();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Analiz Sonucu"),
                        content: Text(result, style: GoogleFonts.poppins()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tamam"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    "Analizi Tamamla",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
