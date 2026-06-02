import 'dart:ui';
import 'dart:typed_data'; // WAJIB untuk tipe data gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/network/api_service.dart';
import 'ResultScreen.dart';

class SmartScannerScreen extends StatefulWidget {
  const SmartScannerScreen({super.key});

  @override
  State<SmartScannerScreen> createState() => _SmartScannerScreenState();
}

class _SmartScannerScreenState extends State<SmartScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;

  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() => _isProcessing = true);

    try {
      final auth = context.read<AuthProvider>();
      
      final String username = auth.username ?? "Operator";
      final String company = auth.companyName ?? "Default Company";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(pickedFile.path, filename: "scan.jpg"),
        "username": username,
        "company_name": company,
        "weight": 1.0, 
      });

      Uint8List imageBytes = await _apiService.scanFruit(formData);
      
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageBytes: imageBytes,
            prediction: "Detected", 
            weight: 1.0,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"), 
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Smart Scanner", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Container(color: Colors.black),
          Center(
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orangeAccent, width: 4),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
              ),
            ),
          ),
          
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.orangeAccent),
                    SizedBox(height: 20),
                    Text("Memproses...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 40, left: 30, right: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(Icons.photo_library, "Galeri", () => _processImage(ImageSource.gallery)),
                  FloatingActionButton(
                    onPressed: _isProcessing ? null : () => _processImage(ImageSource.camera),
                    backgroundColor: Colors.orangeAccent,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                  _buildButton(Icons.home, "Beranda", () => Navigator.pop(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(icon, color: Colors.white), onPressed: onTap),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}