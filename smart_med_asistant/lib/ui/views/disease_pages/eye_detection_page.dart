import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';

class EyeDetectionPage extends StatefulWidget {
  const EyeDetectionPage({super.key});

  @override
  State<EyeDetectionPage> createState() => _EyeDetectionPageState();
}

class _EyeDetectionPageState extends State<EyeDetectionPage> {
  File? _image;
  String _result = '';
  bool _loading = false;

  late Interpreter _interpreter;

  final List<String> _labels = [
    'normal',
    'cataract',
    'glaucoma',
    'disease_retinopathy',
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/ml_models/eye_disease_model.tflite',
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = '';
      });
      _runModelOnImage(_image!);
    }
  }

  Future<void> _runModelOnImage(File image) async {
    setState(() => _loading = true);

    // Örnek varsayım: Model 224x224 girdi alıyor ve 4 sınıf döndürüyor
    final imageBytes = image.readAsBytesSync();
    var input = List.generate(
      1,
      (_) => List.generate(
        224,
        (_) => List.generate(224, (_) => List.filled(3, 0.0)),
      ),
    );
    var output = List.filled(1 * 4, 0.0).reshape([1, 4]);

    _interpreter.run(input, output);

    int maxIndex = output[0].indexWhere(
      (e) => e == output[0].reduce((a, b) => a > b ? a : b),
    );
    setState(() {
      _result = _labels[maxIndex];
      _loading = false;
    });
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
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
        title: const Text(
          "Göz Hastalığı Tespiti",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF04BF8A),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_rounded, size: 24),
              label: const Text(
                "Fotoğraf Yükle",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                backgroundColor: const Color(0xFF04BF8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 30),
            _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _image!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Text(
                        "Henüz bir fotoğraf yüklenmedi",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _loading
                  ? const CircularProgressIndicator()
                  : _result.isNotEmpty
                  ? Container(
                      key: const ValueKey("result"),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tahmin Sonucu",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF04BF8A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _result,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      'Henüz analiz yapılmadı',
                      key: ValueKey("no_result"),
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
