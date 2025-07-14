import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/repo/pharmacy_repository.dart';
import 'package:smart_med_assistant/ui/cubit/pharmacy_register_cubit.dart';
import 'package:smart_med_assistant/ui/views/pharmacy_login_page.dart';

class PharmacyRegisterPage extends StatelessWidget {
  PharmacyRegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PharmacyRegisterCubit(PharmacyRepository()),
      child: Scaffold(
        backgroundColor: Colors.teal.shade50,
        body: SafeArea(
          child: BlocConsumer<PharmacyRegisterCubit, PharmacyRegisterState>(
            listener: (context, state) {
              if (state is PharmacyRegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kayıt başarılı!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  PharmacyLoginPage()),
                );
              } else if (state is PharmacyRegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<PharmacyRegisterCubit>();

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Başlıklar
                        const Icon(Icons.medical_services_outlined, size: 50, color: Colors.teal),
                        const SizedBox(height: 10),
                        Text("Eczacı Kayıt", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.teal.shade800, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),

                        // Form alanları
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: "Ad Soyad"),
                          validator: (val) => val == null || val.isEmpty ? "Gerekli alan" : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: "E-posta"),
                          validator: (val) => val != null && val.contains("@") ? null : "Geçerli e-posta girin",
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Şifre"),
                          validator: (val) => val != null && val.length >= 6 ? null : "Min 6 karakter",
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Şifre Tekrar"),
                          validator: (val) => val == _passwordController.text ? null : "Şifreler uyuşmuyor",
                        ),
                        const SizedBox(height: 24),

                        // Kayıt Butonu
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is PharmacyRegisterLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                cubit.register(
                                  fullname: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              }
                            },
                            child: state is PharmacyRegisterLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Kayıt Ol"),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Zaten hesabınız var mı?"),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => PharmacyLoginPage()),
                              ),
                              child: const Text("Giriş Yap"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
