import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _role;
  String? _companyName;
  String? _email;

  String? get username => _username;
  String? get role => _role;
  String? get companyName => _companyName;
  String? get email => _email;

  // Update: Menambahkan pengecekan agar email tidak tersimpan jika null
  Future<void> loginUser(String username, String role, String company, {String? email}) async {
    _username = username;
    _role = role;
    _companyName = company;
    _email = email; 

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('role', role);
    await prefs.setString('company_name', company);
    
    // Pastikan hanya menyimpan jika email valid (tidak null dan tidak kosong)
    if (email != null && email.isNotEmpty) {
      await prefs.setString('email', email);
    } else {
      await prefs.remove('email'); // Hapus key jika email tidak valid
    }
    
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _role = prefs.getString('role');
    _companyName = prefs.getString('company_name');
    _email = prefs.getString('email'); 
    
    // Debug: Memastikan email yang dimuat benar
    debugPrint("AuthProvider: Email dimuat -> $_email");
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _username = null;
    _role = null;
    _companyName = null;
    _email = null;
    notifyListeners();
  }
}