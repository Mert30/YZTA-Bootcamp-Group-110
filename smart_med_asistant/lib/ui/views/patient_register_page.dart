import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/repo/patient_repository.dart';
import 'package:smart_med_assistant/ui/cubit/patient_register_cubit.dart';
import 'package:smart_med_assistant/ui/views/patient_login_page.dart';
import 'package:smart_med_assistant/ui/views/success_animation_page.dart';

class PatientRegisterPage extends StatelessWidget {
  PatientRegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Color primaryColor = const Color(0xFF026873);
  final Color accentColor = const Color(0xFF04BF8A);
  final Color textColor = const Color(0xFF024059);
  final Color buttonGreen = const Color(0xFF03A64A);
  final Color inputBorderColor = const Color(0xFF025940);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientRegisterCubit(PatientRepository()),
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
            child: BlocConsumer<PatientRegisterCubit, PatientRegisterState>(
              listener: (context, state) {
                if (state is PatientRegisterSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuccessAnimationPage(
                        message: 'Kayıt başarılı!',
                        nextPage: PatientLoginPage(),
                      ),
                    ),
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
                final cubit = context.read<PatientRegisterCubit>();

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Card(
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
                                Icons.person_add_alt_1,
                                size: 60,
                                color: Color(0xFF04BF8A),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Hasta Kayıt",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                "Lütfen bilgilerinizi doldurun",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildTextField(
                                controller: _nameController,
                                label: "Ad Soyad",
                                icon: Icons.person_outline,
                                validator: (val) => val == null || val.isEmpty
                                    ? "Gerekli alan"
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                controller: _emailController,
                                label: "E-posta",
                                icon: Icons.email_outlined,
                                validator: (val) =>
                                    val != null && val.contains("@")
                                    ? null
                                    : "Geçerli e-posta girin",
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                controller: _passwordController,
                                label: "Şifre",
                                icon: Icons.lock_outline,
                                obscure: true,
                                validator: (val) =>
                                    val != null && val.length >= 6
                                    ? null
                                    : "Min 6 karakter",
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: "Şifre Tekrar",
                                icon: Icons.lock_reset_outlined,
                                obscure: true,
                                validator: (val) =>
                                    val == _passwordController.text
                                    ? null
                                    : "Şifreler uyuşmuyor",
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check_circle_outline),
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
                                  onPressed: state is PatientRegisterLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            cubit.register(
                                              fullname: _nameController.text
                                                  .trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            );
                                          }
                                        },
                                  label: state is PatientRegisterLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text("Kayıt Ol"),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "veya",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Zaten hesabınız var mı?"),
                                  TextButton.icon(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PatientLoginPage(),
                                      ),
                                    ),
                                    icon: const Icon(Icons.login, size: 18),
                                    label: Text(
                                      "Giriş Yap",
                                      style: TextStyle(color: buttonGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: inputBorderColor),
        labelStyle: TextStyle(color: textColor),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputBorderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
