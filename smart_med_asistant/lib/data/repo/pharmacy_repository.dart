import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/entity/pharmacy_user.dart';

class PharmacyRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerPharmacyUser(PharmacyUser user, String password) async {
    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    final uid = credential.user!.uid;

    await _firestore.collection("users").doc(uid).set(user.toMap());
  }

  Future<void> loginPharmacyUser(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

}
