import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/ui/views/password_reset_page.dart';
import '../../data/repo/patient_repository.dart'; // varsa
import '../../ui/cubit/patient_login_cubit.dart';
import '../../ui/views/patient_register_page.dart';
import '../../ui/views/patient_prescriptions_page.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({super.key});

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  // Renkleri eczacı loginle aynı yaptım:
  final Color primaryColor = const Color(0xFF026873);
  final Color accentColor = const Color(0xFF04BF8A);
  final Color inputBorderColor = const Color(0xFF025940);
  final Color textColor = const Color(0xFF024059);
  final Color buttonGreen = const Color(0xFF03A64A);

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggle,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: inputBorderColor),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: accentColor,
              ),
              onPressed: toggle,
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: textColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inputBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientLoginCubit(PatientRepository()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE6F4F1), Color(0xFFB2EDE4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
                  listener: (context, state) {
                    if (state is PatientLoginSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Hoş geldin, ${_emailController.text.trim()}',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green.shade400,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientPrescriptionsPage(),
                        ),
                      );
                    } else if (state is PatientLoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is PatientLoginLoading;

                    return Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.95),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF04BF8A),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Hasta Giriş",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Hoş geldiniz! Lütfen giriş yapın",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),

                              TextFormField(
                                controller: _emailController,
                                decoration: _inputDecoration(
                                  "E-posta",
                                  Icons.email,
                                ),
                                validator: (val) =>
                                    val == null || !val.contains("@")
                                    ? "Geçerli e-posta giriniz"
                                    : null,
                              ),
                              const SizedBox(height: 14),

                              ValueListenableBuilder<bool>(
                                valueListenable: _obscurePassword,
                                builder: (context, isObscure, _) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    obscureText: isObscure,
                                    decoration: _inputDecoration(
                                      "Şifre",
                                      Icons.lock,
                                      isPassword: true,
                                      isVisible: !isObscure,
                                      toggle: () => _obscurePassword.value =
                                          !_obscurePassword.value,
                                    ),
                                    validator: (val) =>
                                        val == null || val.length < 6
                                        ? "Şifre en az 6 karakter"
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.login),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<PatientLoginCubit>()
                                                .login(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  label: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text("Giriş Yap"),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PasswordResetPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Şifremi Unuttum?",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
