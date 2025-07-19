import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  final Color darkBlue = const Color(0xFF024059);
  final Color mediumBlue = const Color(0xFF026873);
  final Color lightGreen = const Color(0xFF04BF8A);
  final Color darkGreen = const Color(0xFF025940);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen.withOpacity(0.1),
      body: SafeArea(
        child: Column(
          children: [
            // Başlık ve geri butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    splashColor: mediumBlue.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: mediumBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Hastalarım",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('medicine')
                    .orderBy('startDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: mediumBlue),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Henüz hasta kaydı yok.',
                        style: TextStyle(
                          fontSize: 18,
                          color: darkBlue.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  final patients = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final data = patients[index];
                      final barcode = data['barcode'] ?? '-';
                      final name = data['patientName'] ?? '-';
                      final startDate = _formatDate(data['startDate']);
                      final finishDate = _formatDate(data['finishDate']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: lightGreen.withOpacity(0.3),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                              color: lightGreen.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.medication_outlined,
                              color: darkGreen,
                              size: 32,
                            ),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: darkBlue,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelValue("Barkod:", barcode),
                                _buildLabelValue("Başlangıç:", startDate),
                                _buildLabelValue("Bitiş:", finishDate),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF025940),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return DateFormat('dd MMM yyyy', 'tr_TR').format(timestamp.toDate());
      }
      return '-';
    } catch (_) {
      return '-';
    }
  }
}
