import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HeartDiseasePage extends StatefulWidget {
  const HeartDiseasePage({super.key});

  @override
  State<HeartDiseasePage> createState() => _HeartDiseasePageState();
}

class _HeartDiseasePageState extends State<HeartDiseasePage> {
  final _formKey = GlobalKey<FormState>();
  late Interpreter interpreter;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController trestbpsController = TextEditingController();
  final TextEditingController cholController = TextEditingController();
  final TextEditingController fbsController = TextEditingController();
  final TextEditingController restecgController = TextEditingController();
  final TextEditingController thalachController = TextEditingController();
  final TextEditingController exangController = TextEditingController();
  final TextEditingController oldpeakController = TextEditingController();
  final TextEditingController slopeController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController thalController = TextEditingController();

  String? result;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/ml_models/heart_model.tflite',
    );
  }

  void predict() {
    final input = [
      double.parse(ageController.text),
      double.parse(sexController.text),
      double.parse(cpController.text),
      double.parse(trestbpsController.text),
      double.parse(cholController.text),
      double.parse(fbsController.text),
      double.parse(restecgController.text),
      double.parse(thalachController.text),
      double.parse(exangController.text),
      double.parse(oldpeakController.text),
      double.parse(slopeController.text),
      double.parse(caController.text),
      double.parse(thalController.text),
    ];

    var inputShape = interpreter.getInputTensor(0).shape;
    var outputShape = interpreter.getOutputTensor(0).shape;
    var output = List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

    interpreter.run([input], output);

    setState(() {
      result = output[0][0] > 0.5
          ? "Yüksek Kalp Hastalığı Riski"
          : "Düşük Kalp Hastalığı Riski";
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Boş bırakılamaz' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "Kalp Hastalığı Riski",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF04BF8A),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Yaş", ageController),
              buildTextField("Cinsiyet (1=Erkek, 0=Kadın)", sexController),
              buildTextField("Göğüs Ağrısı Tipi (cp)", cpController),
              buildTextField("Dinlenme Kan Basıncı", trestbpsController),
              buildTextField("Kolesterol", cholController),
              buildTextField("Açlık Kan Şekeri (fbs)", fbsController),
              buildTextField("Dinlenme EKG (restecg)", restecgController),
              buildTextField("Maksimum Kalp Atış Hızı", thalachController),
              buildTextField(
                "Egzersizle Gelen Angina (exang)",
                exangController,
              ),
              buildTextField("ST Depresyonu (oldpeak)", oldpeakController),
              buildTextField("ST Eğimi (slope)", slopeController),
              buildTextField("Ana Damar Sayısı (ca)", caController),
              buildTextField("Thal (thal)", thalController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) predict();
                },
                child: const Text("Riski Hesapla"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF04BF8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (result != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: result!.contains("Yüksek")
                        ? Colors.red[100]
                        : Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result!,
                    style: TextStyle(
                      color: result!.contains("Yüksek")
                          ? Colors.red
                          : Colors.green[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
