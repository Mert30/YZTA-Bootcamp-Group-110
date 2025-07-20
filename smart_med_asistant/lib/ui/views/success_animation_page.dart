import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimationPage extends StatefulWidget {
  final String message;
  final Widget nextPage;

  const SuccessAnimationPage({
    super.key,
    required this.message,
    required this.nextPage,
  });

  @override
  State<SuccessAnimationPage> createState() => _SuccessAnimationPageState();
}

class _SuccessAnimationPageState extends State<SuccessAnimationPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 200,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                widget.message,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
