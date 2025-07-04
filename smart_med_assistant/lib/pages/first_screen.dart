import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smart_med_assistant/pages/register_page.dart";

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  void homePageClick() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void exitClick() async {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // TAM EKRAN ARKA PLAN GÖRSELİ
          Positioned.fill(
            child: Image.asset('assets/first3.jpg', fit: BoxFit.cover),
          ),

          // ORTADA LOGO (MediMate)
          Center(
            child: Image.asset('assets/MediMate.png', width: 200, height: 200),
          ),

          // EN ALTA YAKIN BUTONLAR
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: homePageClick,
                  child: const Icon(Icons.login, color: Colors.green, size: 25),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: exitClick,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.green,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
