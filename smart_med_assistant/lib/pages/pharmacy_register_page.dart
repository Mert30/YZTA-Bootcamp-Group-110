import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_med_assistant/pages/pharmacy_login_page.dart';

class PharmacyRegisterPage extends StatefulWidget {
  const PharmacyRegisterPage({super.key});

  @override
  State<PharmacyRegisterPage> createState() => _PharmacyRegisterPageState();
}

class _PharmacyRegisterPageState extends State<PharmacyRegisterPage> {
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
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

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
          MaterialPageRoute(builder: (context) => const PharmacyLoginPage()),
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
      prefixIcon: Icon(icon, color: Colors.teal.shade700),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.teal.shade400,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      filled: true,
      fillColor: Colors.teal.shade50.withOpacity(0.3),
      labelStyle: TextStyle(
        color: Colors.teal.shade700,
        fontWeight: FontWeight.w600,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.teal.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade100.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo ve başlık
                    const Icon(
                      Icons.medical_services_outlined,
                      size: 50,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Eczacı Kayıt",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "İlaç takibi için eczacı hesabınızı oluşturun",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.teal.shade600,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Form Alanları
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Ad Soyad", Icons.person),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Gerekli alan" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("E-posta", Icons.email),
                      validator: (val) => val != null && val.contains("@")
                          ? null
                          : "Geçerli e-posta girin",
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: _inputDecoration(
                        "Şifre",
                        Icons.lock,
                        isPassword: true,
                        isVisible: _showPassword,
                        toggleVisibility: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                      validator: (val) => val != null && val.length >= 6
                          ? null
                          : "Min 6 karakter",
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      decoration: _inputDecoration(
                        "Şifre Tekrar",
                        Icons.lock,
                        isPassword: true,
                        isVisible: _showConfirmPassword,
                        toggleVisibility: () {
                          setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          );
                        },
                      ),
                      validator: (val) => val == _passwordController.text
                          ? null
                          : "Şifreler uyuşmuyor",
                    ),

                    const SizedBox(height: 24),

                    // Kayıt butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Alt giriş bağlantısı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Zaten hesabınız var mı?",
                          style: TextStyle(color: Colors.teal.shade700),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PharmacyLoginPage(),
                              ),
                            );
                          },
                          child: const Text("Giriş Yap"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
