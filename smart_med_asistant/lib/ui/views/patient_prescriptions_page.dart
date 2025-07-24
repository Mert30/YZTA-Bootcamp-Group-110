import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/data/utils/medicine_name_finder.dart';
import 'package:smart_med_assistant/ui/cubit/patient_prescriptions_cubit.dart';
import 'package:smart_med_assistant/ui/views/patient_home_page.dart';
import 'package:smart_med_assistant/ui/views/prescription_detail_page.dart';

class PatientPrescriptionsPage extends StatefulWidget {
  const PatientPrescriptionsPage({super.key});

  @override
  State<PatientPrescriptionsPage> createState() =>
      _PatientPrescriptionsPageState();
}

class _PatientPrescriptionsPageState extends State<PatientPrescriptionsPage> {
  final Color darkGreen = const Color(0xFF025940);
  final Color mediumGreen = const Color(0xFF04BF8A);
  final Color lightGreen = const Color(0xFFB2EDE4);
  final Color textDark = const Color(0xFF024059);

  final PrescriptionRepository _repository = PrescriptionRepository();

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    MedicineNameFinder.loadJson().then((_) {
      setState(() {});
    });
  }

  Future<void> _deletePrescription(
    String prescriptionId,
    String medicineName,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
            const SizedBox(width: 10),
            const Text("Reçeteyi Sil"),
          ],
        ),
        content: Text(
          "$medicineName adlı ilacı silmek istediğinize emin misiniz?",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("İptal", style: TextStyle(color: mediumGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Sil",
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.deletePrescription(prescriptionId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$medicineName silindi."),
              backgroundColor: Colors.green.shade600,
            ),
          );
          // Reçeteleri tekrar yüklemek için cubit fetch fonksiyonunu çağır
          context.read<PatientPrescriptionsCubit>().fetchPrescriptions();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Silme işlemi başarısız: $e"),
              backgroundColor: Colors.red.shade400,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PatientPrescriptionsCubit(PrescriptionRepository())
            ..fetchPrescriptions(),
      child: Scaffold(
        backgroundColor: lightGreen.withOpacity(0.5),
        appBar: AppBar(
          title: const Text("İlaç Listem"),
          backgroundColor: mediumGreen,
          elevation: 6,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PatientHomePage()),
              );
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: MedicineNameFinder.isLoaded
            ? BlocBuilder<PatientPrescriptionsCubit, PatientPrescriptionsState>(
                builder: (context, state) {
                  if (state is PatientPrescriptionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PatientPrescriptionsError) {
                    return Center(
                      child: Text(
                        "Hata: ${state.message}",
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  if (state is PatientPrescriptionsLoaded) {
                    final prescriptions = state.prescriptions;

                    if (prescriptions.isEmpty) {
                      return Center(
                        child: Text(
                          "Henüz eklenmiş bir ilacınız yok.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: prescriptions.length,
                      itemBuilder: (context, index) {
                        final p = prescriptions[index];
                        final ilacAdi = MedicineNameFinder.getMedicineName(
                          p.barcode,
                        );

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          shadowColor: mediumGreen.withOpacity(0.2),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PrescriptionDetailPage(prescription: p),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: mediumGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.medication,
                                color: darkGreen,
                                size: 32,
                              ),
                            ),
                            title: Text(
                              ilacAdi,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: textDark,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Başlangıç: ${formatDate(p.startDate)}",
                                    style: TextStyle(
                                      color: textDark.withOpacity(0.75),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Bitiş: ${formatDate(p.finishDate)}",
                                    style: TextStyle(
                                      color: textDark.withOpacity(0.75),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: mediumGreen,
                                  size: 20,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                  ),
                                  tooltip: "Sil",
                                  onPressed: () =>
                                      _deletePrescription(p.id, ilacAdi),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
