import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/ui/cubit/patient_register_cubit.dart';
import 'package:smart_med_assistant/ui/views/patient_login_page.dart';

class PatientRegisterPage extends StatefulWidget {
  const PatientRegisterPage({super.key});

  @override
  State<PatientRegisterPage> createState() => _PatientRegisterPageState();
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100.withOpacity(0.3),
      body: BlocConsumer<PatientRegisterCubit, PatientRegisterState>(
        listener: (context, state) {
          if (state is PatientRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Kayıt başarılı! Giriş yapabilirsiniz."),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PatientLoginPage()),
            );
          } else if (state is PatientRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientRegisterLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo
                      const Icon(Icons.person_add, size: 72, color: Colors.green),
                      const SizedBox(height: 16),
                      Text("Hasta Kayıt", style: Theme.of(context).textTheme.titleLarge),

                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Ad Soyad"),
                        validator: (val) => val == null || val.isEmpty ? "Ad giriniz" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "E-posta"),
                        validator: (val) => val != null && val.contains('@') ? null : "Geçerli e-posta girin",
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: (val) => val != null && val.length >= 6 ? null : "Şifre en az 6 karakter olmalı",
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                          labelText: "Şifre Tekrar",
                          suffixIcon: IconButton(
                            icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                          ),
                        ),
                        validator: (val) =>
                        val == _passwordController.text ? null : "Şifreler uyuşmuyor",
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PatientRegisterCubit>().register(
                              fullname: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Kayıt Ol"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PatientLoginPage()),
                          );
                        },
                        child: const Text("Giriş Yap"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
