import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadProducts() async {
  final String jsonString = await rootBundle.loadString('assets/ilac.json');
  final List<dynamic> jsonData = jsonDecode(jsonString);

  final batch = FirebaseFirestore.instance.batch();

  for (var product in jsonData) {
    final docRef = FirebaseFirestore.instance.collection('products').doc();
    batch.set(docRef, {
      'barcode': product['barcode'],
      'productName': product['Product_Name'],
      'stock_quantity': 20,
    });
  }

  try {
    await batch.commit();
    print('Tüm ürünler başarıyla yüklendi.');
  } catch (e) {
    print('Yükleme sırasında hata: $e');
  }
}
