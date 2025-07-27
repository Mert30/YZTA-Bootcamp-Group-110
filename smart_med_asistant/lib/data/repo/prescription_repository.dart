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

    final patientDoc = querySnapshot.docs.first;
    final patientId = patientDoc.id;

    // Hastanın reçetelerine ekle
    await _firestore
        .collection('users')
        .doc(patientId)
        .collection('prescriptions')
        .add(prescription.toMap());

    // 🔹 Ekleyen eczacının altına bu hastayı kaydet
    final pharmacistUid = FirebaseAuth.instance.currentUser?.uid;
    if (pharmacistUid != null) {
      final pharmacistRef = _firestore.collection('users').doc(pharmacistUid);
      final addedPatientRef = pharmacistRef.collection('added_patients').doc(patientId);

      // Bu hasta daha önce eklenmemişse ekle
      await addedPatientRef.set({
        'email': patientDoc['email'],
        'fullname': patientDoc['fullname'], // veya username, entity'ye bağlı
        'addedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge=true: üstüne yazmaz, günceller
    }
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

  Future<List<Map<String, dynamic>>> getPatientsWithPrescriptionsByPharmacist(String pharmacistUid) async {
    final prescriptionSnapshots = await _firestore
        .collectionGroup('prescriptions')
        .where('addedBy', isEqualTo: pharmacistUid)
        .get();

    final patientIds = prescriptionSnapshots.docs
        .map((doc) => doc.reference.parent.parent!.id) // users/{id}
        .toSet();

    List<Map<String, dynamic>> patients = [];

    for (String id in patientIds) {
      final userDoc = await _firestore.collection('users').doc(id).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          patients.add({
            'email': data['email'],
            'username': data['username'],
          });
        }
      }
    }

    return patients;
  }


  Future<List<Map<String, dynamic>>> getPatientsWithPrescriptionsByEczaci(String eczaciEmail) async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'hasta')
        .get();

    List<Map<String, dynamic>> patients = [];

    for (var userDoc in usersSnapshot.docs) {
      final prescriptionsSnapshot = await userDoc.reference
          .collection('prescriptions')
          .where('addedBy', isEqualTo: eczaciEmail)
          .limit(1)
          .get();

      if (prescriptionsSnapshot.docs.isNotEmpty) {
        patients.add(userDoc.data());
      }
    }

    return patients;
  }

  Future<List<Map<String, dynamic>>> getPatientsAddedByPharmacist() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("Eczacı oturumu açık değil");

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('added_patients')
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }


}
