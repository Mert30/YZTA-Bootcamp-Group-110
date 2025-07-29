import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';

class PregnancyRiskPage extends StatefulWidget {
  const PregnancyRiskPage({super.key});

  @override
  State<PregnancyRiskPage> createState() => _PregnancyRiskPageState();
}

class _PregnancyRiskPageState extends State<PregnancyRiskPage> {
  // Sorular (7 tane)
  bool hasChronicIllness = false;
  bool isOver35 = false;
  bool smokes = false;
  bool hadMiscarriage = false;
  bool hadCesarean = false;
  bool highBMI = false;
  bool hasGeneticHistory = false;

  String result = "";
  Color resultColor = Colors.green.shade100;

  void calculateRisk() {
    int score = 0;
    if (hasChronicIllness) score++;
    if (isOver35) score++;
    if (smokes) score++;
    if (hadMiscarriage) score++;
    if (hadCesarean) score++;
    if (highBMI) score++;
    if (hasGeneticHistory) score++;

    String message;
    String suggestion;
    Color color;

    if (score >= 4) {
      message = "🚨 Yüksek Gebelik Riski";
      suggestion = "Lütfen en kısa sürede bir kadın doğum uzmanına başvurun.";
      color = Colors.red.shade100;
    } else if (score >= 2) {
      message = "⚠️ Orta Düzeyde Risk";
      suggestion = "Rutin kontrollerinizi ihmal etmeyin, dikkatli olun.";
      color = Colors.amber.shade100;
    } else {
      message = "✅ Düşük Riskli";
      suggestion = "Sağlıklı bir gebelik için iyi gidiyorsunuz!";
      color = Colors.green.shade100;
    }

    setState(() {
      result =
          "$message\n\n$suggestion\n\n🌸 Unutmayın, her kadın özeldir ve sağlık en büyük hazinedir.";
      resultColor = color;
    });
  }

  Widget buildSwitch(String title, bool value, void Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: GoogleFonts.poppins(fontSize: 15)),
      activeColor: const Color(0xFF04BF8A),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF04BF8A);
    const Color white = Colors.white;

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              // Başlık ve geri
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiseaseDetectionPage(),
                      ),
                    ),
                    color: green,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Gebelik Risk Analizi",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Ortalamayı korumak için boşluk
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Lütfen aşağıdaki soruları yanıtlayınız:",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 10),

              // Sorular
              buildSwitch(
                "Kronik bir hastalığınız var mı?",
                hasChronicIllness,
                (val) => setState(() => hasChronicIllness = val),
              ),
              buildSwitch(
                "35 yaş üzeri misiniz?",
                isOver35,
                (val) => setState(() => isOver35 = val),
              ),
              buildSwitch(
                "Sigara kullanıyor musunuz?",
                smokes,
                (val) => setState(() => smokes = val),
              ),
              buildSwitch(
                "Daha önce düşük yaptınız mı?",
                hadMiscarriage,
                (val) => setState(() => hadMiscarriage = val),
              ),
              buildSwitch(
                "Sezaryen doğum geçmişiniz var mı?",
                hadCesarean,
                (val) => setState(() => hadCesarean = val),
              ),
              buildSwitch(
                "VKİ’niz 30’un üzerinde mi?",
                highBMI,
                (val) => setState(() => highBMI = val),
              ),
              buildSwitch(
                "Ailede genetik hastalık öyküsü var mı?",
                hasGeneticHistory,
                (val) => setState(() => hasGeneticHistory = val),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: calculateRisk,
                child: Text(
                  "Risk Analizi Yap",
                  style: GoogleFonts.poppins(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (result.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: resultColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: green, width: 1.2),
                  ),
                  child: Text(result, style: GoogleFonts.poppins(fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
