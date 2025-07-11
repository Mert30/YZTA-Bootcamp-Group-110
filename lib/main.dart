import 'package:flutter/material.dart';
import 'package:smart_med_assistant/pages/first_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_med_assistant/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediMate',
      home: const FirstScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
