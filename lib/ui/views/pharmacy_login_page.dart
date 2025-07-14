import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/pharmacy_repository.dart';
import '../../ui/cubit/pharmacy_login_cubit.dart';
import '../../ui/views/pharmacy_main_page.dart';
import 'pharmacy_register_page.dart';

class PharmacyLoginPage extends StatelessWidget {
  PharmacyLoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  InputDecoration _inputDecoration(
      String label,
      IconData icon, {
        bool isPassword = false,
        bool isVisible = false,
        VoidCallback? toggle,
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
        onPressed: toggle,
      )
          : null,
      filled: true,
      fillColor: Colors.teal.shade50,
      labelStyle: TextStyle(color: Colors.teal.shade700),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PharmacyLoginCubit(PharmacyRepository()),
      child: Scaffold(
        backgroundColor: Colors.teal.shade100.withOpacity(0.3),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<PharmacyLoginCubit, PharmacyLoginState>(
                listener: (context, state) {
                  if (state is PharmacyLoginSuccess) {
                    final email = _emailController.text.trim();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Hoş geldin, $email'),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green.shade400,
                      ),
                    );
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

                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo ve başlık
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.teal.shade700,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.local_pharmacy_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text("Eczacı Giriş",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800)),
                          const SizedBox(height: 24),

                          // E-posta
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration("E-posta", Icons.email),
                            validator: (val) =>
                            val == null || !val.contains("@")
                                ? "Geçerli e-posta giriniz"
                                : null,
                          ),
                          const SizedBox(height: 12),

                          // Şifre
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
                                validator: (val) => val == null || val.length < 6
                                    ? "Şifre en az 6 karakter"
                                    : null,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Giriş Butonu
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is PharmacyLoginLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: state is PharmacyLoginLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kayıt Ol Bağlantısı
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Hesabın yok mu?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      PharmacyRegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Kayıt Ol",
                                  style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
