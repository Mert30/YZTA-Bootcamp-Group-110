import 'dart:convert';
import 'package:flutter/services.dart';

class IlacData {
  late final Map<String, String> _barcodeToName;

  Future<void> loadIlaclar() async {
    final String jsonString = await rootBundle.loadString('assets/ilac.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _barcodeToName = {
      for (var item in jsonList)
        if (item['barcode'] != null && item['ProductName'] != null)
          item['barcode']: item['ProductName'],
    };
  }

  String getIlacAdi(String barcode) {
    return _barcodeToName[barcode] ?? 'İlaç Adı Bulunamadı';
  }
}
