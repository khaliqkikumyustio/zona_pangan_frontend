import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../constants/api_endpoints.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // REGISTER
  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String role,
    required String companyName,
  }) async {
    try {
      await _dio.post(ApiEndpoints.register, data: {
        "email": email,
        "password": password,
        "username": username,
        "role": role,
        "company_name": companyName,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final errorMessage = e.response!.data['error'];
        throw Exception(errorMessage);
      }
      throw Exception("Terjadi kesalahan koneksi ke server");
    } catch (e) {
      throw Exception("Terjadi kesalahan tidak terduga");
    }
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {"email": email});
    } catch (e) {
      throw Exception("Gagal mengirim permintaan reset: ${e.toString()}");
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dio.post(ApiEndpoints.resetPassword, data: {
        "token": token,
        "new_password": newPassword
      });
    } catch (e) {
      throw Exception("Gagal mereset password: ${e.toString()}");
    }
  }

  // LOGIN
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: {
        "email": identifier,
        "password": password,
      });
      return response.data;
    } catch (e) {
      throw Exception("Login gagal: ${e.toString()}");
    }
  }

  // SCAN FRUIT
  Future<Uint8List> scanFruit(FormData formData) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.scan,
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        final errorString = utf8.decode(response.data);
        final errorJson = jsonDecode(errorString);
        throw Exception(errorJson['error'] ?? "Terjadi kesalahan server");
      }
    } on DioException catch (e) {
      throw Exception("Gagal terhubung ke server: ${e.message}");
    } catch (e) {
      throw Exception("Gagal memproses scan: ${e.toString()}");
    }
  }

  // --- GET OVERVIEW ---
  Future<Map<String, dynamic>> getOverview(String companyName) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.overview, // Menggunakan konstanta yang benar
        queryParameters: {"company_name": companyName.trim()}
      );
      return response.data;
    } catch (e) {
      debugPrint("Error Overview: $e");
      throw Exception("Gagal mengambil data overview");
    }
  }

  // --- GET INVENTORY ---
  Future<List<dynamic>> getInventory(String companyName) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.inventory, // Menggunakan konstanta yang benar
        queryParameters: {"company_name": companyName.trim()}
      );
      return (response.data['inventory'] as List?) ?? [];
    } catch (e) {
      debugPrint("Error Inventory: $e");
      throw Exception("Gagal mengambil inventaris");
    }
  }

  // --- GET LOGS ---
  Future<List<dynamic>> getLogs(String companyName) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.logs, // Menggunakan konstanta yang benar
        queryParameters: {"company_name": companyName.trim()}
      );
      return (response.data['logs'] as List?) ?? [];
    } catch (e) {
      debugPrint("Error Logs: $e");
      throw Exception("Gagal mengambil log");
    }
  }

  // KONFIRMASI / SIMPAN DATA
  Future<void> confirmScan({
    required String username,
    required String companyName,
    required String prediction,
    required double weight,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.confirmScan,
        data: {
          "username": username,
          "company_name": companyName,
          "prediction": prediction,
          "weight": weight,
          "status": "verified"
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return;
      } else {
        final errorMessage = response.data['error'] ?? "Gagal dengan status ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      throw Exception("Koneksi gagal: ${e.message}");
    } catch (e) {
      throw Exception("Kesalahan sistem: ${e.toString()}");
    }
  }
}