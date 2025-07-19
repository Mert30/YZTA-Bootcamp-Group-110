import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_med_assistant/data/service/gemini_service.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/ui/cubit/add_medicine_cubit.dart';
import 'package:smart_med_assistant/ui/views/barcode_scanner_page.dart';
import 'package:smart_med_assistant/ui/views/pharmacy_main_page.dart';

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

  String? aiDescription;

  final Color darkBlue = const Color(0xFF024059);
  final Color mediumBlue = const Color(0xFF026873);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color darkGreen = const Color(0xFF025940);

  final geminiService = GeminiService(
    'AIzaSyCogncljqhDbk53iFWtLvfXGmoKOCmUnuE',
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMedicineCubit(PrescriptionRepository(), geminiService),
      child: Scaffold(
        backgroundColor: lightGreen.withOpacity(0.15),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: mediumBlue.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: BlocConsumer<AddMedicineCubit, AddMedicineState>(
                  listener: (context, state) {
                    if (state is AddMedicineSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "İlaç bilgisi başarıyla kaydedildi.",
                          ),
                          backgroundColor: darkGreen,
                          behavior: SnackBarBehavior.floating,
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
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.floating,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PharmacistMainPage(),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(30),
                                splashColor: darkGreen.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 28,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "İlaç Bilgisi Ekle",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: darkBlue,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Barkod
                          _buildTextField(
                            controller: _barcodeController,
                            label: 'Barkod',
                            icon: Icons.qr_code,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: mediumBlue,
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BarcodeScannerPage(
                                      onScanned: (value) {
                                        _barcodeController.text = value;
                                        context
                                            .read<AddMedicineCubit>()
                                            .fetchMedicineInfoFromAI(value);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            onChanged: (val) {
                              if (val.length >= 5) {
                                context
                                    .read<AddMedicineCubit>()
                                    .fetchMedicineInfoFromAI(val);
                              }
                            },
                            validator: (val) => val == null || val.isEmpty
                                ? 'Barkod giriniz'
                                : null,
                          ),
                          const SizedBox(height: 24),

                          // AI Açıklaması
                          if (aiDescription != null) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Yapay Zeka Açıklaması:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: lightGreen.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: darkGreen.withOpacity(0.6),
                                ),
                              ),
                              child: Text(
                                aiDescription!,
                                style: TextStyle(
                                  color: darkBlue.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],

                          // Hasta Email
                          _buildTextField(
                            controller: _patientEmailController,
                            label: 'Hasta E-posta',
                            icon: Icons.person,
                            validator: (val) => val == null || val.isEmpty
                                ? 'E-posta giriniz'
                                : null,
                          ),
                          const SizedBox(height: 24),

                          // Tarihler
                          _datePickerField(
                            label: 'Başlangıç Tarihi',
                            date: _startDate,
                            onTap: () => _selectDate(true),
                            icon: Icons.date_range_rounded,
                            darkBlue: darkBlue,
                            mediumBlue: mediumBlue,
                            lightGreen: lightGreen,
                          ),
                          const SizedBox(height: 20),
                          _datePickerField(
                            label: 'Bitiş Tarihi',
                            date: _finishDate,
                            onTap: () => _selectDate(false),
                            icon: Icons.date_range_outlined,
                            darkBlue: darkBlue,
                            mediumBlue: mediumBlue,
                            lightGreen: lightGreen,
                          ),
                          const SizedBox(height: 36),

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
                                        context
                                            .read<AddMedicineCubit>()
                                            .saveMedicine(
                                              barcode: _barcodeController.text
                                                  .trim(),
                                              patientEmail:
                                                  _patientEmailController.text
                                                      .trim(),
                                              startDate: _startDate!,
                                              finishDate: _finishDate!,
                                            );
                                      }
                                    },
                              icon: state is AddMedicineLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.save_alt_rounded,
                                      color: Colors.white,
                                    ),
                              label: const Text(
                                "Kaydet",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkGreen,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 6,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(color: darkBlue, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: mediumBlue),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: lightGreen.withOpacity(0.2),
        labelStyle: TextStyle(color: darkBlue, fontWeight: FontWeight.w700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: mediumBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
    );
  }

  Widget _datePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
    required Color darkBlue,
    required Color mediumBlue,
    required Color lightGreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: mediumBlue),
            suffixIcon: Icon(Icons.calendar_today_rounded, color: mediumBlue),
            filled: true,
            fillColor: lightGreen.withOpacity(0.25),
            labelStyle: TextStyle(color: darkBlue, fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: mediumBlue, width: 2),
            ),
            hintText: date != null
                ? DateFormat('dd.MM.yyyy').format(date)
                : 'Tarih seçiniz',
            hintStyle: TextStyle(
              color: date != null ? darkBlue : mediumBlue.withOpacity(0.6),
              fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
          ),
          validator: (_) => date == null ? '$label seçiniz' : null,
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.w700),
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
            primary: mediumBlue,
            onPrimary: Colors.white,
            onSurface: darkBlue,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: mediumBlue,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
}
