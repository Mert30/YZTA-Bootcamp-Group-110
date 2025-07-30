import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LungDetectionPage extends StatefulWidget {
  const LungDetectionPage({super.key});

  @override
  State<LungDetectionPage> createState() => _LungDetectionPageState();
}

class _LungDetectionPageState extends State<LungDetectionPage> {
  late Interpreter _interpreter;
  String _result = '';
  bool _isLoading = true;

  final Map<String, double> _inputs = {
    'GENDER': 0,
    'AGE': 30,
    'SMOKING': 0,
    'YELLOW_FINGERS': 0,
    'ANXIETY': 0,
    'PEER_PRESSURE': 0,
    'CHRONIC_DISEASE': 0,
    'FATIGUE': 0,
    'ALLERGY': 0,
    'WHEEZING': 0,
    'ALCOHOL_CONSUMING': 0,
    'COUGHING': 0,
    'SHORTNESS_OF_BREATH': 0,
    'SWALLOWING_DIFFICULTY': 0,
    'CHEST_PAIN': 0,
  };

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/ml_models/lung_model.tflite',
    );
    setState(() => _isLoading = false);
  }

  void _predict() {
    final input = _inputs.values.toList();
    final output = List.filled(1 * 1, 0.0).reshape([1, 1]);

    _interpreter.run([input], output);

    setState(() {
      _result = output[0][0] > 0.5
          ? "⚠️ Yüksek akciğer kanseri riski tespit edildi."
          : "✅ Akciğer kanseri riski düşük.";
    });
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSwitchCard(String label, String keyName) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        value: _inputs[keyName] == 1,
        onChanged: (val) => setState(() {
          _inputs[keyName] = val ? 1 : 0;
        }),
        title: Text(label),
        activeColor: const Color(0xFF04BF8A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAgeSlider() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Yaş", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _inputs['AGE']!,
              min: 10,
              max: 100,
              divisions: 90,
              label: _inputs['AGE']!.round().toString(),
              onChanged: (val) {
                setState(() {
                  _inputs['AGE'] = val;
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Seçilen: ${_inputs['AGE']!.round()} yaş"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: DropdownButtonFormField<double>(
          value: _inputs['GENDER'],
          decoration: const InputDecoration(
            labelText: "Cinsiyet",
            border: InputBorder.none,
          ),
          items: const [
            DropdownMenuItem(value: 0, child: Text("Kadın")),
            DropdownMenuItem(value: 1, child: Text("Erkek")),
          ],
          onChanged: (val) => setState(() => _inputs['GENDER'] = val!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF04BF8A);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DiseaseDetectionPage(),
              ), // buraya yönlendireceğin sayfayı yaz
            );
          },
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Text(
          "Akciğer Kanseri Tahmini",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Kişisel Bilgiler"),
                  _buildGenderDropdown(),
                  _buildAgeSlider(),
                  _buildSectionTitle("Belirti & Alışkanlıklar"),
                  _buildSwitchCard("Sigara Kullanımı", "SMOKING"),
                  _buildSwitchCard("Sararmış Parmaklar", "YELLOW_FINGERS"),
                  _buildSwitchCard("Anksiyete", "ANXIETY"),
                  _buildSwitchCard("Akran Baskısı", "PEER_PRESSURE"),
                  _buildSwitchCard("Kronik Hastalık", "CHRONIC_DISEASE"),
                  _buildSwitchCard("Yorgunluk", "FATIGUE"),
                  _buildSwitchCard("Alerji", "ALLERGY"),
                  _buildSwitchCard("Hırıltı", "WHEEZING"),
                  _buildSwitchCard("Alkol Tüketimi", "ALCOHOL_CONSUMING"),
                  _buildSwitchCard("Öksürük", "COUGHING"),
                  _buildSwitchCard("Nefes Darlığı", "SHORTNESS_OF_BREATH"),
                  _buildSwitchCard("Yutma Güçlüğü", "SWALLOWING_DIFFICULTY"),
                  _buildSwitchCard("Göğüs Ağrısı", "CHEST_PAIN"),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.analytics_outlined),
                      onPressed: _predict,
                      label: const Text("Tahmin Et"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_result.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: _result.contains("⚠️")
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _result,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
