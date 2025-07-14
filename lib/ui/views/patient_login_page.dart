import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/ui/cubit/patient_login_cubit.dart';
import 'package:smart_med_assistant/ui/views/patient_register_page.dart';
import 'package:smart_med_assistant/ui/views//patient_prescriptions_page.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({super.key});

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100.withOpacity(0.3),
      body: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listener: (context, state) {
          if (state is PatientLoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PatientPrescriptionsPage()),
            );
          } else if (state is PatientLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientLoginLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 72, color: Colors.green),
                      const SizedBox(height: 16),
                      Text("Hasta Giriş", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "E-posta"),
                        validator: (val) => val != null && val.contains('@') ? null : "Geçerli e-posta girin",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (val) =>
                        val != null && val.length >= 6 ? null : "Şifre en az 6 karakter olmalı",
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PatientLoginCubit>().login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Giriş Yap"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PatientRegisterPage()),
                          );
                        },
                        child: const Text("Kayıt Ol"),
                      ),
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
