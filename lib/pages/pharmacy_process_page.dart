import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_med_assistant/pages/barcode_scanner_page.dart';

class PharmacyProcessPage extends StatefulWidget {
  const PharmacyProcessPage({super.key});

  @override
  State<PharmacyProcessPage> createState() => _PharmacyProcessPageState();
}

class _PharmacyProcessPageState extends State<PharmacyProcessPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _finishDate;

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.teal.shade700, // Header background
            onPrimary: Colors.white, // Header text color
            onSurface: Colors.teal.shade900, // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal.shade700, // Ok button color
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

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _finishDate != null) {
      await FirebaseFirestore.instance.collection('medicine').add({
        'barcode': _barcodeController.text.trim(),
        'patientName': _patientNameController.text.trim(),
        'startDate': _startDate!.toIso8601String(),
        'finishDate': _finishDate!.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İlaç bilgisi başarıyla kaydedildi.'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );

      _barcodeController.clear();
      _patientNameController.clear();
      setState(() {
        _startDate = null;
        _finishDate = null;
      });
    }
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal.shade700),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.teal.shade50.withOpacity(0.4),
      labelStyle: TextStyle(
        color: Colors.teal.shade900,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
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
          decoration:
              _inputDecoration(
                label,
                icon,
                suffix: const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.teal,
                ),
              ).copyWith(
                hintText: date != null
                    ? DateFormat('dd.MM.yyyy').format(date)
                    : 'Tarih seçiniz',
                hintStyle: TextStyle(
                  color: date != null
                      ? Colors.teal.shade900
                      : Colors.teal.shade300,
                  fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
          validator: (_) => date == null ? '$label seçiniz' : null,
          style: TextStyle(
            color: Colors.teal.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Form(
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

                    TextFormField(
                      controller: _barcodeController,
                      decoration: _inputDecoration(
                        'Barkod',
                        Icons.qr_code,
                        suffix: IconButton(
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BarcodeScannerPage(
                                  onScanned: (value) {
                                    _barcodeController.text = value;
                                  },
                                ),
                              ),
                            );
                            // Eğer başka işlem gerekirse buraya eklenebilir
                          },
                        ),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Barkod giriniz' : null,
                      style: TextStyle(color: Colors.teal.shade900),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _patientNameController,
                      decoration: _inputDecoration('Hasta İsmi', Icons.person),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Hasta ismi giriniz'
                          : null,
                      style: TextStyle(color: Colors.teal.shade900),
                    ),
                    const SizedBox(height: 20),

                    _datePickerField(
                      label: 'Başlangıç Tarihi',
                      date: _startDate,
                      onTap: () => _selectDate(isStart: true),
                      icon: Icons.date_range_rounded,
                    ),
                    const SizedBox(height: 20),

                    _datePickerField(
                      label: 'Bitiş Tarihi',
                      date: _finishDate,
                      onTap: () => _selectDate(isStart: false),
                      icon: Icons.date_range_outlined,
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveData,
                        icon: const Icon(
                          Icons.save_alt_rounded,
                          size: 24,
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
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: Colors.teal.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
