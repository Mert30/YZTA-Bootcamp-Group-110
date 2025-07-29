import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart'; // Lottie import edildi
import 'package:smart_med_assistant/ui/views/pharmacy_register_page.dart';
import 'package:smart_med_assistant/ui/views/patient_register_page.dart';

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
      MaterialPageRoute(builder: (context) => PharmacyRegisterPage()),
    );
  }

  void patientPageClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientRegisterPage()),
    );
  }

  @override
  void initState() {
    super.initState();

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
          /// 🔴 LOTTIE ANIMASYONU ARKAPLANDA
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/firstScreenAnimation.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          /// 🟢 LOGO ve HOŞ GELDİNİZ YAZISI
          FadeTransition(
            opacity: _logoFade,
            child: ScaleTransition(
              scale: _logoScale,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          'assets/medimatenewlogo.png',
                          width: size.width * 0.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "MediMate'e Hoş Geldiniz",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🟡 BUTONLAR
          FadeTransition(
            opacity: _buttonsFade,
            child: ScaleTransition(
              scale: _buttonsScale,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildButton(
                        "Eczacı Giriş",
                        Icons.local_pharmacy,
                        pharmacyPageClick,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      _buildButton(
                        "Hasta Giriş",
                        Icons.person,
                        patientPageClick,
                        color: Colors.white,
                      ),
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

  Widget _buildButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required Color color,
  }) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: color,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: color.withOpacity(0.4),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 25),
        label: Text(
          text,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
