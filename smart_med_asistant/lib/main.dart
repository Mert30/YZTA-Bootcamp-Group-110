import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:smart_med_assistant/data/service/stock_uploader.dart';  Kullanılmaycak daha

import 'package:smart_med_assistant/data/service/notification_service.dart';
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

// Yeni: Tema Cubit'i
enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.light);

  void toggleTheme() {
    emit(state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await StockUploader.uploadMedicinesFromExportedJson(); Bir kereye mahsus çalışması lazımdı bu kodun firebase den 20K veriyi çekmek için
  await NotificationService.initialize();   
  runApp(BlocProvider(create: (_) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final patientRepository = PatientRepository();
    final pharmacyRepository = PharmacyRepository();
    final prescriptionRepository = PrescriptionRepository();
    final geminiService = GeminiService(
      'AIzaSyCogncljqhDbk53iFWtLvfXGmoKOCmUnuE',
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PatientRepository>(create: (_) => patientRepository),
        RepositoryProvider<PharmacyRepository>(
          create: (_) => pharmacyRepository,
        ),
        RepositoryProvider<PrescriptionRepository>(
          create: (_) => prescriptionRepository,
        ),
        RepositoryProvider<GeminiService>(create: (_) => geminiService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PatientRegisterCubit(patientRepository)),
          BlocProvider(create: (_) => PatientLoginCubit(patientRepository)),
          BlocProvider(
            create: (_) => PharmacyRegisterCubit(pharmacyRepository),
          ),
          BlocProvider(create: (_) => PharmacyLoginCubit(pharmacyRepository)),
          BlocProvider(
            create: (_) =>
                AddMedicineCubit(prescriptionRepository, geminiService),
          ),
          BlocProvider(
            create: (_) => PatientPrescriptionsCubit(prescriptionRepository),
          ),
        ],
        child: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'MediMate',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: Colors.green,
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: Colors.green,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF121212),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1F1F1F),
                  foregroundColor: Colors.white,
                ),
              ),
              themeMode: themeState == AppThemeMode.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              home: const FirstScreen(),
            );
          },
        ),
      ),
    );
  }
}
