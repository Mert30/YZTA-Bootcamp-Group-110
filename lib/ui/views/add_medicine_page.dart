import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_med_assistant/data/service/gemini_service.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/ui/cubit/add_medicine_cubit.dart';
import 'package:smart_med_assistant/ui/views/barcode_scanner_page.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _patientEmailController = TextEditingController();

  DateTime? _startDate;
  DateTime? _finishDate;

  String? aiDescription; // Yapay zekadan gelen açıklama

  final geminiService = GeminiService('AIzaSyCogncljqhDbk53iFWtLvfXGmoKOCmUnuE'); // kendi API keyini gir

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMedicineCubit(PrescriptionRepository(), geminiService),
      child: Scaffold(
        backgroundColor: Colors.teal.shade100.withOpacity(0.2),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade200.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: BlocConsumer<AddMedicineCubit, AddMedicineState>(
                  listener: (context, state) {
                    if (state is AddMedicineSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("İlaç bilgisi başarıyla kaydedildi."),
                          backgroundColor: Colors.teal,
                        ),
                      );
                      _barcodeController.clear();
                      _patientEmailController.clear();
                      setState(() {
                        _startDate = null;
                        _finishDate = null;
                        aiDescription = null;
                      });
                    } else if (state is AddMedicineFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is AddMedicineAIResponse) {
                      setState(() {
                        aiDescription = state.aiSummary;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "İlaç Bilgisi Ekle",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Barkod
                          TextFormField(
                            controller: _barcodeController,
                            decoration: _inputDecoration(
                              'Barkod',
                              Icons.qr_code,
                              suffix: IconButton(
                                icon: const Icon(Icons.camera_alt_rounded, color: Colors.teal),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BarcodeScannerPage(
                                        onScanned: (value) {
                                          _barcodeController.text = value;
                                          context.read<AddMedicineCubit>().fetchMedicineInfoFromAI(value);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            onChanged: (val) {
                              if (val.length >= 5) {
                                context.read<AddMedicineCubit>().fetchMedicineInfoFromAI(val);
                              }
                            },
                            validator: (val) => val == null || val.isEmpty ? 'Barkod giriniz' : null,
                            style: TextStyle(color: Colors.teal.shade900),
                          ),
                          const SizedBox(height: 20),

                          // AI'dan gelen açıklama
                          if (aiDescription != null) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Yapay Zeka Açıklaması:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                aiDescription!,
                                style: TextStyle(color: Colors.teal.shade800),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Hasta Email
                          TextFormField(
                            controller: _patientEmailController,
                            decoration: _inputDecoration('Hasta E-posta', Icons.person),
                            validator: (val) => val == null || val.isEmpty ? 'E-posta giriniz' : null,
                            style: TextStyle(color: Colors.teal.shade900),
                          ),
                          const SizedBox(height: 20),

                          // Tarihler
                          _datePickerField(
                            label: 'Başlangıç Tarihi',
                            date: _startDate,
                            onTap: () => _selectDate(true),
                            icon: Icons.date_range_rounded,
                          ),
                          const SizedBox(height: 20),
                          _datePickerField(
                            label: 'Bitiş Tarihi',
                            date: _finishDate,
                            onTap: () => _selectDate(false),
                            icon: Icons.date_range_outlined,
                          ),
                          const SizedBox(height: 40),

                          // Kaydet Butonu
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: state is AddMedicineLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate() &&
                                    _startDate != null &&
                                    _finishDate != null) {
                                  context.read<AddMedicineCubit>().saveMedicine(
                                    barcode: _barcodeController.text.trim(),
                                    patientEmail: _patientEmailController.text.trim(),
                                    startDate: _startDate!,
                                    finishDate: _finishDate!,
                                  );
                                }
                              },
                              icon: state is AddMedicineLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                                  : const Icon(Icons.save_alt_rounded, color: Colors.white),
                              label: const Text(
                                "Kaydet",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.teal.shade700,
            onPrimary: Colors.white,
            onSurface: Colors.teal.shade900,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_finishDate != null && _finishDate!.isBefore(_startDate!)) {
            _finishDate = null;
          }
        } else {
          _finishDate = picked;
        }
      });
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal.shade700),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.teal.shade50.withOpacity(0.4),
      labelStyle: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  Widget _datePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: _inputDecoration(
            label,
            icon,
            suffix: const Icon(Icons.calendar_today_rounded, color: Colors.teal),
          ).copyWith(
            hintText: date != null ? DateFormat('dd.MM.yyyy').format(date) : 'Tarih seçiniz',
            hintStyle: TextStyle(
              color: date != null ? Colors.teal.shade900 : Colors.teal.shade300,
              fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          validator: (_) => date == null ? '$label seçiniz' : null,
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
