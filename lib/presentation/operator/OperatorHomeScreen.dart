import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'SmartScannerScreen.dart';

class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({super.key});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  
  // Fungsi terpisah untuk menjaga build method tetap bersih
  Future<void> _handleLogout() async {
    // Tampilkan konfirmasi agar user tidak tidak sengaja memencet logout
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Keluar")),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      
      // Mengarahkan ke Login dan menghapus semua history route sebelumnya
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const LoginScreen()), 
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8C42),
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Halo Operator!", 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _handleLogout, // Memanggil method logout
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bagian Tengah
              const Expanded(
                child: Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Scan
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartScannerScreen())),
                child: Container(
                  height: 120, width: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
                  ),
                  child: const Icon(Icons.camera_alt, size: 50, color: Color(0xFFFF8C42)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 40),
                child: Text("KETUK UNTUK SCAN", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}