import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:smart_med_assistant/firebase_options.dart';
import 'package:smart_med_assistant/ui/views/first_screen.dart';

// Repository
import 'package:smart_med_assistant/data/repo/patient_repository.dart';
import 'package:smart_med_assistant/data/repo/pharmacy_repository.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/ui/cubit/patient_prescriptions_cubit.dart';

// Cubits
import 'package:smart_med_assistant/ui/cubit/patient_register_cubit.dart';
import 'package:smart_med_assistant/ui/cubit/patient_login_cubit.dart';
import 'package:smart_med_assistant/ui/cubit/pharmacy_register_cubit.dart';
import 'package:smart_med_assistant/ui/cubit/pharmacy_login_cubit.dart';
import 'package:smart_med_assistant/ui/cubit/add_medicine_cubit.dart';

// Gemini
import 'package:smart_med_assistant/data/service/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final patientRepository = PatientRepository();
    final pharmacyRepository = PharmacyRepository();
    final prescriptionRepository = PrescriptionRepository();
    final geminiService = GeminiService('AIzaSyCogncljqhDbk53iFWtLvfXGmoKOCmUnuE'); // BURAYA kendi API anahtarını yaz

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PatientRepository>(create: (_) => patientRepository),
        RepositoryProvider<PharmacyRepository>(create: (_) => pharmacyRepository),
        RepositoryProvider<PrescriptionRepository>(create: (_) => prescriptionRepository),
        RepositoryProvider<GeminiService>(create: (_) => geminiService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PatientRegisterCubit(patientRepository)),
          BlocProvider(create: (_) => PatientLoginCubit(patientRepository)),
          BlocProvider(create: (_) => PharmacyRegisterCubit(pharmacyRepository)),
          BlocProvider(create: (_) => PharmacyLoginCubit(pharmacyRepository)),
          BlocProvider(
            create: (_) => AddMedicineCubit(prescriptionRepository, geminiService),
          ),
          BlocProvider(create: (_) => PatientPrescriptionsCubit(prescriptionRepository)),
        ],
        child: MaterialApp(
          title: 'MediMate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
          ),
          home: const FirstScreen(),
        ),
      ),
    );
  }
}
