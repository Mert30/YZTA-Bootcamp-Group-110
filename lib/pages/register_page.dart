import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_med_assistant/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Firebase Authentication ile kullanıcı oluşturma yeri burası
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // Firestore'a kullanıcı bilgilerini kaydetme yeri burası
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set({
              "fullname": _nameController.text.trim(),
              "email": _emailController.text.trim(),
              "createdAt": Timestamp.now(),
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kayıt başarılı! Giriş yapabilirsiniz."),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMsg = "Bir hata oluştu.";
        if (e.code == 'email-already-in-use') {
          errorMsg = "Bu e-posta zaten kullanılıyor.";
        } else if (e.code == 'invalid-email') {
          errorMsg = "Geçersiz e-posta adresi.";
        } else if (e.code == 'weak-password') {
          errorMsg = "Şifre çok zayıf.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Beklenmeyen bir hata oluştu."),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade600),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade600,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      filled: true,
      fillColor: Colors.grey.shade50,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo / Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.medication_outlined,
                    size: 40,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "İlaç takibi için kişisel hesabınızı oluşturun",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Form Fields
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Ad Soyad", Icons.person),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ad Soyad gerekli"
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("E-posta", Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "E-posta gerekli";
                    }
                    if (!value.contains("@")) {
                      return "Geçerli bir e-posta girin";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: _inputDecoration(
                    "Şifre",
                    Icons.lock_outline,
                    isPassword: true,
                    isVisible: _showPassword,
                    toggleVisibility: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : "Şifre en az 6 karakter olmalı",
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_showConfirmPassword,
                  decoration: _inputDecoration(
                    "Şifre Tekrar",
                    Icons.lock_outline,
                    isPassword: true,
                    isVisible: _showConfirmPassword,
                    toggleVisibility: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) => value == _passwordController.text
                      ? null
                      : "Şifreler uyuşmuyor",
                ),
                const SizedBox(height: 32),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "Kayıt Ol",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login bağlantısı
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zaten hesabınız var mı?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
