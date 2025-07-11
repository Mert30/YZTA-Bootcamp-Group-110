import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'pharmacy_process_page.dart';

class PharmacyHomePage extends StatefulWidget {
  const PharmacyHomePage({Key? key}) : super(key: key);

  @override
  State<PharmacyHomePage> createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage> {
  static const String _doctorName = 'Ecz. Dr. Ayşe Yılmaz';
  static const String _appTitle = 'Eczacı Paneli';
  static const String _appSubtitle = 'Reçetelerinizi yönetin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.teal,
      title: _buildAppBarTitle(),
      actions: [_buildAppBarActions()],
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        _buildAppIcon(),
        const SizedBox(width: 12),
        _buildTitleColumn(),
      ],
    );
  }

  Widget _buildAppIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.medical_services,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildTitleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_appTitle, style: AppTextStyles.appBarTitle),
        Text(_appSubtitle, style: AppTextStyles.appBarSubtitle),
      ],
    );
  }

  Widget _buildAppBarActions() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, color: Colors.teal.shade700, size: 16),
          const SizedBox(width: 4),
          Text(_doctorName, style: AppTextStyles.doctorName),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.teal.shade700),
            onPressed: _onSettingsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Firebase verisine göre istatistikleri ayrı bir StreamBuilder ile gösterebilirsin
          const SizedBox(height: 24),
          _buildPrescriptionsSection(),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          _buildPrescriptionsHeader(),
          _buildPrescriptionsList(),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.teal.shade100),
        ),
      ),
      child: Row(
        children: [
          Text('Reçetelerim', style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final docs = snapshot.data!.docs;
        final prescriptions = docs
            .map((doc) => PrescriptionModel.fromFirestore(doc))
            .toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prescriptions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.teal.shade100,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) =>
              _buildPrescriptionItem(prescriptions[index]),
        );
      },
    );
  }

  Widget _buildPrescriptionItem(PrescriptionModel prescription) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(prescription.patientName, style: AppTextStyles.patientName)),
              _buildStatusChip(prescription.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(prescription.medicationName, style: AppTextStyles.medicationName),
          const SizedBox(height: 8),
          _buildPrescriptionDetails(prescription),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PrescriptionStatus status) {
    final isActive = status == PrescriptionStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.teal.shade50 : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.teal.shade800 : Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildPrescriptionDetails(PrescriptionModel prescription) {
    return Row(
      children: [
        _buildDetailItem('📅', prescription.createdDate),
        const SizedBox(width: 16),
        _buildDetailItem('💊', prescription.dosage),
        const SizedBox(width: 16),
        _buildDetailItem('⏰', prescription.duration),
      ],
    );
  }

  Widget _buildDetailItem(String emoji, String text) {
    return Text('$emoji $text', style: AppTextStyles.prescriptionDetail);
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.medical_services_outlined, size: 60, color: Colors.teal.shade100),
          const SizedBox(height: 16),
          Text('Henüz reçete bulunmuyor', style: AppTextStyles.emptyTitle),
          const SizedBox(height: 8),
          Text(
            'Yeni reçete oluşturmak için + butonuna tıklayın',
            style: AppTextStyles.emptySubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _onCreatePrescriptionPressed,
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(Icons.add, size: 28, color: Colors.white),
    );
  }

  void _onSettingsPressed() {}

  void _onCreatePrescriptionPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PharmacyProcessPage(),
      ),
    );
  }
}

// === Model & Enum ===

class PrescriptionModel {
  final int id;
  final String patientName;
  final String medicationName;
  final String createdDate;
  final PrescriptionStatus status;
  final String duration;
  final String dosage;

  const PrescriptionModel({
    required this.id,
    required this.patientName,
    required this.medicationName,
    required this.createdDate,
    required this.status,
    required this.duration,
    required this.dosage,
  });

  factory PrescriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrescriptionModel(
      id: doc.id.hashCode,
      patientName: data['patientName'] ?? '',
      medicationName: data['barcode'] ?? '',
      createdDate: data['startDate']?.substring(0, 10) ?? '',
      status: PrescriptionStatus.active,
      duration: _calculateDuration(data['startDate'], data['finishDate']),
      dosage: '2x1', // Firebase'de varsa güncelleyebilirsin
    );
  }

  static String _calculateDuration(String? start, String? finish) {
    if (start == null || finish == null) return '-';
    final s = DateTime.tryParse(start);
    final f = DateTime.tryParse(finish);
    if (s == null || f == null) return '-';
    return '${f.difference(s).inDays} gün';
  }
}

enum PrescriptionStatus {
  active,
  completed;

  String get displayName {
    switch (this) {
      case PrescriptionStatus.active:
        return 'Aktif';
      case PrescriptionStatus.completed:
        return 'Tamamlandı';
    }
  }
}

// === Tema ===

class AppColors {
  static const Color background = Color(0xFFE0F2F1);
  static const Color primary = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFFB2DFDB);
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF004D40),
  );

  static const TextStyle appBarSubtitle = TextStyle(
    fontSize: 12,
    color: Color(0xFF00695C),
  );

  static const TextStyle doctorName = TextStyle(
    fontSize: 12,
    color: Color(0xFF00796B),
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF004D40),
  );

  static const TextStyle patientName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF004D40),
  );

  static const TextStyle medicationName = TextStyle(
    fontSize: 14,
    color: Color(0xFF00796B),
  );

  static const TextStyle prescriptionDetail = TextStyle(
    fontSize: 12,
    color: Color(0xFF00796B),
  );

  static const TextStyle emptyTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF004D40),
  );

  static const TextStyle emptySubtitle = TextStyle(
    fontSize: 14,
    color: Color(0xFF00695C),
  );
}

class AppShadows {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x33006461),
      spreadRadius: 1,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
}
