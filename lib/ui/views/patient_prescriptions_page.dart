import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_med_assistant/data/entity/prescription.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/ui/cubit/patient_prescriptions_cubit.dart';

class PatientPrescriptionsPage extends StatelessWidget {
  const PatientPrescriptionsPage({super.key});

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      PatientPrescriptionsCubit(PrescriptionRepository())..fetchPrescriptions(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("İlaç Listem"),
          backgroundColor: Colors.green.shade700,
        ),
        body: BlocBuilder<PatientPrescriptionsCubit, PatientPrescriptionsState>(
          builder: (context, state) {
            if (state is PatientPrescriptionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PatientPrescriptionsError) {
              return Center(
                child: Text(
                  "Hata: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is PatientPrescriptionsLoaded) {
              final prescriptions = state.prescriptions;

              if (prescriptions.isEmpty) {
                return const Center(child: Text("Henüz eklenmiş bir ilacınız yok."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  final p = prescriptions[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.green),
                      title: Text("Barkod: ${p.barcode}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Başlangıç: ${formatDate(p.startDate)}"),
                          Text("Bitiş: ${formatDate(p.finishDate)}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink(); // Initial veya diğer durumlar
          },
        ),
      ),
    );
  }
}
