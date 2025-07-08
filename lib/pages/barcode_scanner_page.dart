import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatelessWidget {
  final Function(String) onScanned;

  const BarcodeScannerPage({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Barkod Tara"),
        backgroundColor: Colors.teal.shade700,
        elevation: 6,
        shadowColor: Colors.teal.shade300,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;

              if (code != null) {
                onScanned(code);
                Navigator.of(context).pop();
              }
            },
          ),
          // Overlay: koyu yarı şeffaf
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
          ),
          // Tarama kutusu (beyaz border, yuvarlak)
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.teal.shade300, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade200.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
                color: Colors.transparent,
              ),
            ),
          ),
          // Alt açıklama metni
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Text(
              'Barkodu kutunun içine yerleştirin. Kamera otomatik olarak tarayacaktır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
