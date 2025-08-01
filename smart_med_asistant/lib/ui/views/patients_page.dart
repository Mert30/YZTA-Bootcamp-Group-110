import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/ui/views/pharmacy_main_page.dart';
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PharmacistMainPage(),
                ), // buraya yönlendireceğin sayfayı yaz
              );
            },
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: const Text("Hastalarım"),
        ),
        body: BlocBuilder<PatientsCubit, PatientsState>(
          builder: (context, state) {
            if (state is PatientsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PatientsLoaded) {
              if (state.patients.isEmpty) {
                return const Center(
                  child: Text(
                    "Henüz hasta eklenmemiş.",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.patients.length,
                itemBuilder: (context, index) {
                  final patient = state.patients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        patient['fullname'] ?? 'Ad yok',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(patient['email'] ?? 'Email yok'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddMedicinePage(patientEmail: patient['email']),
                          ),
                        );
                      },
                    ),
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
