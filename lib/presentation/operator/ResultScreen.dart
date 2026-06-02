import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/core/network/api_service.dart';

class ResultScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String prediction; // Sekarang opsional
  final double weight;     // Sekarang opsional

  const ResultScreen({
    super.key,
    required this.imageBytes,
    this.prediction = "Unknown", // Nilai default jika tidak dikirim
    this.weight = 0.0,           // Nilai default jika tidak dikirim
  });

  Future<void> _saveToDatabase(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final apiService = ApiService();

    try {
      // Mengirim data ke backend
      await apiService.confirmScan(
        username: auth.username ?? "Unknown",
        companyName: auth.companyName ?? "Unknown",
        prediction: prediction,
        weight: weight,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil disimpan untuk verifikasi Manager!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF8C42), Color(0xFFF39C12)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    imageBytes,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.analytics, size: 50, color: Colors.orange),
                      const SizedBox(height: 10),
                      Text(
                        "Hasil: $prediction",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Simpan ke Database
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () => _saveToDatabase(context),
                          child: const Text(
                            "SIMPAN KE DATABASE",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tombol Kembali
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("KEMBALI"),
                        ),
                      ),
                    ],
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