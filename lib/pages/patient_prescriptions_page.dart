import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PatientPrescriptionsPage extends StatelessWidget {
  const PatientPrescriptionsPage({super.key});

  Stream<QuerySnapshot> getPrescriptions() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('prescriptions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlaç Listem"),
        backgroundColor: Colors.green.shade700,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getPrescriptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Henüz eklenmiş bir ilacınız yok.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final prescriptions = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final data = prescriptions[index].data() as Map<String, dynamic>;

              final barcode = data['barcode'] ?? 'N/A';
              final startDate = data['startDate'];
              final finishDate = data['finishDate'];

              String formatDate(String? iso) {
                if (iso == null) return "-";
                final date = DateTime.tryParse(iso);
                return date != null ? DateFormat('dd.MM.yyyy').format(date) : "-";
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.medication, color: Colors.green),
                  title: Text("Barkod: $barcode"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Başlangıç: ${formatDate(startDate)}"),
                      Text("Bitiş: ${formatDate(finishDate)}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
