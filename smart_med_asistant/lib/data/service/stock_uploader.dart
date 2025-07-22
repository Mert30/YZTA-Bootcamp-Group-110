import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockUploader {
  static Future<void> uploadMedicinesFromExportedJson() async {
    final firestore = FirebaseFirestore.instance;

    // JSON'u yükle
    final String jsonString = await rootBundle.loadString('assets/ilac.json');
    final List<dynamic> fullJson = json.decode(jsonString);

    // Sadece `data` kısmını al
    final List<dynamic> medicines = fullJson.firstWhere(
      (e) => e['type'] == 'table',
    )['data'];

    for (var med in medicines) {
      final productName = med['Product_Name'] ?? 'İsimsiz';
      final barcode = med['barcode'] ?? '';
      final stock_quantity =
          100; // Başlangıç değeri isteğe göre değiştirilebilir

      // Aynı ürün daha önce eklenmiş mi kontrol et
      final existing = await firestore
          .collection('stock')
          .where('barcode', isEqualTo: barcode)
          .get();

      if (existing.docs.isEmpty) {
        await firestore.collection('stock').add({
          'productName': productName,
          'barcode': barcode,
          'stock_quantity': stock_quantity,
        });
      }
    }

    print("JSON'daki ilaçlar yüklendi ✅");
  }
}
