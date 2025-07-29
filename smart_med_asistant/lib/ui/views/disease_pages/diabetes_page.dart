import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class DiabetesDetectionPage extends StatefulWidget {
  const DiabetesDetectionPage({super.key});

  @override
  State<DiabetesDetectionPage> createState() => _DiabetesDetectionPageState();
}

class _DiabetesDetectionPageState extends State<DiabetesDetectionPage> {
  final _formKey = GlobalKey<FormState>();

  final _controllers = List.generate(8, (_) => TextEditingController());

  String _resultText = "";
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/ml_model/diabetes_model.tflite',
      );
      setState(() {});
    } catch (e) {
      debugPrint("Model yüklenirken hata oluştu: $e");
    }
  }

  void _predict() {
    if (!_formKey.currentState!.validate() || _interpreter == null) return;

    final input = Float32List.fromList(
      _controllers.map((c) => double.parse(c.text)).toList(),
    );

    final output = List.filled(1, 0).reshape([1, 1]);
    _interpreter!.run(input.reshape([1, 8]), output);

    setState(() {
      _resultText = output[0][0] == 1
          ? "❗ Diyabet riski mevcut."
          : "✅ Diyabet riski görünmüyor.";
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Color(0xFF04BF8A)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF04BF8A), width: 2),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Bu alan boş bırakılamaz' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF04BF8A);
    final Color background = const Color(0xFFF6F9FB);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF04BF8A)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DiseaseDetectionPage(),
              ), // buraya yönlendireceğin sayfayı yaz
            );
          },
        ),
        title: Text(
          "Diyabet Riski Analizi",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF04BF8A),
          ),
        ),
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Gebelik Sayısı", _controllers[0]),
              _buildTextField("Glukoz", _controllers[1]),
              _buildTextField("Tansiyon", _controllers[2]),
              _buildTextField("Cilt Kalınlığı", _controllers[3]),
              _buildTextField("İnsülin", _controllers[4]),
              _buildTextField("BMI", _controllers[5]),
              _buildTextField("Genetik Skor", _controllers[6]),
              _buildTextField("Yaş", _controllers[7]),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _predict,
                  icon: const Icon(Icons.analytics_outlined, size: 20),
                  label: const Text(
                    "Tahmin Et",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_resultText.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _resultText.contains("❗")
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _resultText.contains("❗")
                          ? Colors.red
                          : Colors.green,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _resultText.contains("❗")
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        color: _resultText.contains("❗")
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _resultText,
                          style: TextStyle(
                            color: _resultText.contains("❗")
                                ? Colors.red
                                : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
