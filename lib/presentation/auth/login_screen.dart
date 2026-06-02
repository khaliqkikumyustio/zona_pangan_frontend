// Di dalam login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/api_service.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';

// Import file lain di folder yang sama cukup dengan nama filenya saja
import 'register_screen.dart';
import 'forgot_password_screen.dart';

// Import folder operator dan manager untuk navigasi setelah login
import '../operator/OperatorHomeScreen.dart'; 
import '../manager/manager_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _apiService.login(_emailController.text, _passwordController.text);
      
      if (!mounted) return;
      
      await context.read<AuthProvider>().loginUser(
        userData['username'],
        userData['role'],
        userData['company_name'],
      );

      if (!mounted) return;

      // Hapus tanda komentar (//) pada baris navigasi di bawah ini
      if (userData['role'] == 'manager') {
        debugPrint("Navigasi ke Manager Dashboard");
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const ManagerDashboard()) // Pastikan nama class ini benar
        );
      } else {
        debugPrint("Navigasi ke Operator Home");
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const OperatorHomeScreen()) // Pastikan nama class ini benar
        );
      }
    } catch (e) {
      // ... sisa kode catch tetap sama
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal: ${e.toString()}"),
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
      // Menggunakan background gradient agar terlihat modern
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF8C42), Color(0xFFF39C12)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Icon dengan background samar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "ZONA PANGAN", 
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.white,
                    letterSpacing: 1.5,
                  )
                ),
                const Text(
                  "Sistem Inspeksi Kematangan Buah", 
                  style: TextStyle(color: Colors.white70, fontSize: 16)
                ),
                const SizedBox(height: 40),
                
                // Form Container dengan Shadow yang estetik
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: "Username atau Email", 
                        controller: _emailController, 
                        icon: Icons.person
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Password", 
                        controller: _passwordController, 
                        icon: Icons.lock, 
                        isPassword: true
                      ),
                      
                      Align(
  alignment: Alignment.centerRight, 
  child: TextButton(
    onPressed: () {
      // Menambahkan navigasi ke ForgotPasswordScreen
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => ForgotPasswordScreen()), // Pastikan nama class screen ini sesuai
      );
    }, 
    child: const Text(
      "Lupa Password?", 
      style: TextStyle(color: Colors.orange)
    )
  )
),
                      
                      _isLoading 
                        ? const CircularProgressIndicator(color: Color(0xFFFF8C42))
                        : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8C42), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                              ),
                              onPressed: _login, 
                              child: const Text(
                                "MASUK SEKARANG", 
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  }, 
                  child: const Text(
                    "Belum punya akun? Daftar Sekarang", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}