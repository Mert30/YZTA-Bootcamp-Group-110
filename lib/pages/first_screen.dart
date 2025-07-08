import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_med_assistant/pages/pharmacy_register_page.dart';
import 'package:smart_med_assistant/pages/patient_register_page.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _buttonsController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  late Animation<double> _buttonsFade;
  late Animation<double> _buttonsScale;

  void pharmacyPageClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PharmacyRegisterPage()),
    );
  }

  void patientPageClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PatientRegisterPage()),
    );
  }

  void exitClick() {
    SystemNavigator.pop();
  }

  @override
  void initState() {
    super.initState();

    // Logo animasyonu
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoScale = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Buton animasyonu
    _buttonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _buttonsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonsController, curve: Curves.easeIn),
    );
    _buttonsScale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _buttonsController, curve: Curves.easeOut),
    );

    // Animasyonları sırayla başlat
    _logoController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _buttonsController.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan görsel
          Positioned.fill(
            child: Image.asset('assets/first3.jpg', fit: BoxFit.cover),
          ),

          // LOGO ANİMASYONLU
          FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/MediMate.png',
                    width: size.width * 0.5,
                  ),
                ),
              ),
            ),
          ),

          // BUTONLAR ANİMASYONLU
          FadeTransition(
            opacity: _buttonsFade,
            child: ScaleTransition(
              scale: _buttonsScale,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildButton(
                        "Eczacı Giriş",
                        Icons.local_pharmacy,
                        pharmacyPageClick,
                      ),
                      const SizedBox(height: 12),
                      _buildButton(
                        "Hasta Giriş",
                        Icons.person,
                        patientPageClick,
                      ),
                      const SizedBox(height: 12),
                      _buildButton("Çıkış", Icons.exit_to_app, exitClick),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.teal),
        label: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.teal),
        ),
      ),
    );
  }
}
