import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart'; // Lottie için import
import 'package:smart_med_assistant/ui/views/disease_detection_page.dart';
import 'package:smart_med_assistant/ui/views/first_screen.dart';
import 'package:smart_med_assistant/ui/views/gemini_chat_page.dart';
import 'package:smart_med_assistant/ui/views/patient_prescriptions_page.dart';
import 'package:smart_med_assistant/ui/views/patient_settings_page.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String fullName = 'Hasta';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchUserData(_user!.email!);
    }
  }

  Future<void> _fetchUserData(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('role', isEqualTo: 'hasta')
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      setState(() {
        fullName = data['fullname'] ?? 'Hasta';
        profileImageUrl = data['profileImageUrl'];
      });
    }
  }

  Future<void> _selectAndUploadImage(BuildContext context, String email) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);
      final uid = _user!.uid;

      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$uid.jpg',
      );

      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: 'hasta')
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'profileImageUrl': downloadUrl,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profil resmi güncellendi"),
          backgroundColor: Colors.green[600],
        ),
      );

      _fetchUserData(email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata oluştu: $e"),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hasta Anasayfa'),
        backgroundColor: Colors.teal.shade700,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF6FFFE),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(color: Color(0xFF025940)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: profileImageUrl != null
                                    ? NetworkImage(profileImageUrl!)
                                    : null,
                                child: profileImageUrl == null
                                    ? Text(
                                        fullName.isNotEmpty
                                            ? fullName[0].toUpperCase()
                                            : 'H',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          color: Color(0xFF025940),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_user != null) {
                                      _selectAndUploadImage(
                                        context,
                                        _user!.email!,
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.green,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _user?.email ?? '',
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.medical_services,
                  color: Color(0xFF025940),
                ),
                title: const Text(
                  'İlaçlarım',
                  style: TextStyle(color: Color(0xFF025940)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientPrescriptionsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF025940)),
                title: const Text(
                  'Ayarlar',
                  style: TextStyle(color: Color(0xFF025940)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientSettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.health_and_safety,
                  color: Color(0xFF025940),
                ),
                title: const Text(
                  'Teşhisler',
                  style: TextStyle(color: Color(0xFF025940)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetectionPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Color(0xFF025940)),
                title: const Text(
                  'Çıkış Yap',
                  style: TextStyle(color: Color(0xFF025940)),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          color: Color(0xFF024059),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      content: const Text(
                        'Uygulamadan çıkmak istediğinize emin misiniz?',
                        style: TextStyle(color: Colors.black87),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'İptal',
                            style: TextStyle(
                              color: Color(0xFF04BF8A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04BF8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            elevation: 6,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Çıkış Yap',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Color(0xFF04BF8A),
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hoşgeldin, $fullName!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF025940),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sağlık bilgilerine buradan kolayca ulaşabilirsin.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Chatbot animasyonu ve konuşma balonu
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Konuşma kutusu
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Bana soru sorabilirsin 🧠',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Chatbot animasyonlu buton
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeminiChatPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Lottie.asset(
                      'assets/animations/chatbot.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
