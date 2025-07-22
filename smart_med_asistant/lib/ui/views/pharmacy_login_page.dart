import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/ui/views/password_reset_page.dart';
import '../../data/repo/pharmacy_repository.dart';
import '../../ui/cubit/pharmacy_login_cubit.dart';
import '../../ui/views/pharmacy_main_page.dart';

class PharmacyLoginPage extends StatelessWidget {
  PharmacyLoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

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
      create: (_) => PharmacyLoginCubit(PharmacyRepository()),
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
                child: BlocConsumer<PharmacyLoginCubit, PharmacyLoginState>(
                  listener: (context, state) {
                    if (state is PharmacyLoginSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PharmacistMainPage(),
                        ),
                      );
                    } else if (state is PharmacyLoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<PharmacyLoginCubit>();

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
                                Icons.local_pharmacy_outlined,
                                size: 60,
                                color: Color(0xFF04BF8A),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Eczacı Giriş",
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

                              // Email
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

                              // Password
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

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.login),
                                  onPressed: state is PharmacyLoginLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            cubit.login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
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
                                  label: state is PharmacyLoginLoading
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
