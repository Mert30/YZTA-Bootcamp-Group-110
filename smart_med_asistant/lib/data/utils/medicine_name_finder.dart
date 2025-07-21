import 'dart:convert';
import 'package:flutter/services.dart';

class MedicineNameFinder {
  static Map<String, String> _barcodeToName = {};
  static bool isLoaded = false;

  static Future<void> loadJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/ilac.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      // "table" tipinde olan nesneyi bul
      final tableEntry = jsonList.firstWhere(
        (element) => element['type'] == 'table' && element['name'] == 'ilac',
        orElse: () => null,
      );

      if (tableEntry == null) {
        print("🔴 'table' tipinde 'ilac' bulunamadı!");
        return;
      }

      final List<dynamic> ilacData = tableEntry['data'];

      _barcodeToName = {
        for (var item in ilacData)
          if (item['barcode'] != null && item['Product_Name'] != null)
            item['barcode']: item['Product_Name'],
      };

      isLoaded = true;
      print("✅ JSON yüklendi, ilaç sayısı: ${_barcodeToName.length}");
    } catch (e) {
      print("🔴 JSON yüklenirken hata oluştu: $e");
    }
  }

  static String getMedicineName(String barcode) {
    return _barcodeToName[barcode] ?? "İlaç Adı Bulunamadı";
  }
}
