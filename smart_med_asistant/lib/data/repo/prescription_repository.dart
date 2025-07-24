import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entity/prescription.dart';

class PrescriptionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔸 Reçete ekleme (AI ile gelen verileri de içerir)
  Future<void> addPrescription({
    required Prescription prescription,
    required String patientEmail,
  }) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: patientEmail)
        .where('role', isEqualTo: 'hasta')
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Hasta bulunamadı');
    }

    final patientId = querySnapshot.docs.first.id;

    await _firestore
        .collection('users')
        .doc(patientId)
        .collection('prescriptions')
        .add(prescription.toMap());
  }

  // 🔹 Giriş yapan hastanın reçetelerini al
  Future<List<Prescription>> getPrescriptionsForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Oturum açılmamış.");

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('prescriptions')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Prescription.fromFirestore(data, doc.id);
    }).toList();
  }

  // 🗑️ Giriş yapan hastanın bir reçetesini sil
  Future<void> deletePrescription(String prescriptionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Oturum açılmamış.");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('prescriptions')
        .doc(prescriptionId)
        .delete();
  }
}
