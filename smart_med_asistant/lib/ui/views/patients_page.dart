import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/prescription_repository.dart';
import '../cubit/patients_cubit.dart';
import 'add_medicine_page.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientsCubit(PrescriptionRepository())..fetchPatients(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Hastalarım")),
        body: BlocBuilder<PatientsCubit, PatientsState>(
          builder: (context, state) {
            if (state is PatientsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PatientsLoaded) {
              if (state.patients.isEmpty) {
                return const Center(child: Text("Henüz hasta eklenmemiş."));
              }

              return ListView.builder(
                itemCount: state.patients.length,
                itemBuilder: (context, index) {
                  final patient = state.patients[index];
                  return ListTile(
                    title: Text(patient['fullname'] ?? 'Ad yok'),
                    subtitle: Text(patient['email'] ?? 'Email yok'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddMedicinePage(
                            patientEmail: patient['email'], // maili yolla
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is PatientsError) {
              return Center(child: Text("Hata: ${state.message}"));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
