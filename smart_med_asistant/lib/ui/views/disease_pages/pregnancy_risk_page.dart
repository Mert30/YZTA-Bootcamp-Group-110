import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PregnancyRiskPage extends StatefulWidget {
  const PregnancyRiskPage({super.key});

  @override
  State<PregnancyRiskPage> createState() => _PregnancyRiskPageState();
}

class _PregnancyRiskPageState extends State<PregnancyRiskPage> {
  final _formKey = GlobalKey<FormState>();

  final ageController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final bsController = TextEditingController();
  final tempController = TextEditingController();
  final heartRateController = TextEditingController();

  String? result;
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/ml_models/pregnancy_risk_model.tflite',
      );
      setState(() {});
    } catch (e) {
      print("Model yüklenirken hata oluştu: $e");
    }
  }

  void predict() {
    final age = double.parse(ageController.text);
    final sys = double.parse(systolicController.text);
    final dia = double.parse(diastolicController.text);
    final bs = double.parse(bsController.text);
    final temp = double.parse(tempController.text);
    final hr = double.parse(heartRateController.text);

    var input = [
      [age, sys, dia, bs, temp, hr],
    ];
    var output = List.filled(1 * 3, 0.0).reshape([1, 3]);

    _interpreter?.run(input, output);

    int predictedIndex = output[0].indexOf(
      output[0].reduce((a, b) => a > b ? a : b),
    );
    setState(() {
      result = ['Düşük Risk', 'Orta Risk', 'Yüksek Risk'][predictedIndex];
    });
  }

  @override
  void dispose() {
    ageController.dispose();
    systolicController.dispose();
    diastolicController.dispose();
    bsController.dispose();
    tempController.dispose();
    heartRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF04BF8A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Lütfen bilgilerinizi giriniz:",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(ageController, 'Yaş'),
                  _buildTextField(systolicController, 'Sistolik Kan Basıncı'),
                  _buildTextField(
                    diastolicController,
                    'Diyastolik Kan Basıncı',
                  ),
                  _buildTextField(bsController, 'Kan Şekeri'),
                  _buildTextField(tempController, 'Vücut Sıcaklığı'),
                  _buildTextField(heartRateController, 'Nabız'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  predict();
                }
              },
              child: Text(
                "Risk Durumunu Tahmin Et",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: green, width: 1),
                ),
                child: Center(
                  child: Text(
                    "🔍 Tahmin Sonucu: $result",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) =>
            value == null || value.isEmpty ? 'Bu alan boş bırakılamaz' : null,
      ),
    );
  }
}
