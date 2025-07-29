import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  double _height = 170;
  double _weight = 70;
  String? _result;
  String? _advice;

  void _calculateBMI() {
    final heightInMeters = _height / 100;
    final bmi = _weight / (heightInMeters * heightInMeters);

    String category;
    String advice;

    if (bmi < 18.5) {
      category = "Zayıf";
      advice = "Biraz daha dengeli beslen, sağlıklı kal.";
    } else if (bmi < 25) {
      category = "Normal";
      advice = "Harika! Bu formu korumaya devam et!";
    } else if (bmi < 30) {
      category = "Fazla Kilolu";
      advice = "Daha aktif ol, hedefine adım adım ulaşabilirsin.";
    } else {
      category = "Obez";
      advice = "Bir uzmandan destek almanı öneririz.";
    }

    setState(() {
      _result = "VKİ: ${bmi.toStringAsFixed(1)} → $category";
      _advice = advice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri butonu ve başlık ortalanmış
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiseaseDetectionPage(),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "VKİ Hesaplama",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // simetri için boşluk
                ],
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      // Boy seçimi
                      Text(
                        "Boy: ${_height.toInt()} cm",
                        style: GoogleFonts.poppins(
                          fontSize: 20, // Daha büyük
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      Slider(
                        activeColor: Colors.teal.shade700,
                        value: _height,
                        min: 100,
                        max: 220,
                        divisions: 120,
                        label: "${_height.toInt()} cm",
                        onChanged: (value) {
                          setState(() {
                            _height = value;
                          });
                        },
                      ),

                      // Kilo seçimi
                      Text(
                        "Kilo: ${_weight.toInt()} kg",
                        style: GoogleFonts.poppins(
                          fontSize: 20, // Daha büyük
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      Slider(
                        activeColor: Colors.teal.shade700,
                        value: _weight,
                        min: 30,
                        max: 150,
                        divisions: 120,
                        label: "${_weight.toInt()} kg",
                        onChanged: (value) {
                          setState(() {
                            _weight = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Hesapla",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_result != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _result!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _advice ?? "",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
