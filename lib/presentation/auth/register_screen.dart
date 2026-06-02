import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();
  
  String _role = 'operator';
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.register(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        role: _role,
        companyName: _companyController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil! Silakan login."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background yang sama dengan LoginScreen
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF8C42), Color(0xFFF39C12)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Buat Akun Baru", 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)
                  ),
                  const SizedBox(height: 30),
                  
                  // Card Container yang sama
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        CustomTextField(label: "Username", controller: _usernameController, icon: Icons.person_outline),
                        const SizedBox(height: 16),
                        CustomTextField(label: "Email", controller: _emailController, icon: Icons.email_outlined),
                        const SizedBox(height: 16),
                        CustomTextField(label: "Password", controller: _passwordController, icon: Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 16),
                        CustomTextField(label: "Nama Perusahaan", controller: _companyController, icon: Icons.business),
                        const SizedBox(height: 16),
                        
                        // Custom Dropdown yang lebih rapi
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _role,
                            items: const [
                              DropdownMenuItem(value: 'operator', child: Text("Operator")),
                              DropdownMenuItem(value: 'manager', child: Text("Manager")),
                            ],
                            onChanged: (val) => setState(() => _role = val!),
                            decoration: const InputDecoration(border: InputBorder.none, labelText: "Role"),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        _isLoading 
                          ? const CircularProgressIndicator(color: Color(0xFFFF8C42))
                          : SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF8C42),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: _register,
                                child: const Text("DAFTAR SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Sudah punya akun? Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}