import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Gunakan 10.0.2.2 untuk emulator Android, ganti dengan IP PC untuk real device
  static const String baseUrl = "http://10.49.153.201:8000/api";

  // 🔹 Helper decode JSON aman
  static dynamic _parseJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      print("⚠️ Error decode JSON: $e");
      return null;
    }
  }

  // 🔹 LOGIN
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 && data != null) {
        return data; // data['token'] bisa disimpan di Flutter
      } else {
        print("❌ Login gagal: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error login: $e");
      return null;
    }
  }

  // 🔹 GET PROFIL KARYAWAN LOGIN
  static Future<Map<String, dynamic>?> getKaryawanProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/karyawan/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 && data != null) {
        return data['data'];
      } else {
        print("❌ Gagal ambil profil: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error getKaryawanProfile: $e");
      return null;
    }
  }

  // 🔹 UPDATE PROFIL LOGIN
  static Future<bool> updateProfile(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/karyawan/profile"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      final resData = _parseJson(response.body);

      if (response.statusCode == 200) {
        print("✅ Update berhasil: ${response.body}");
        return true;
      } else {
        print("❌ Update gagal: ${response.statusCode} - ${resData?['message'] ?? response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error updateProfile: $e");
      return false;
    }
  }

  // 🔹 UPDATE PASSWORD KARYAWAN
  static Future<bool> updatePassword(String token, String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/karyawan/password"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "current_password": currentPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200) {
        print("✅ Password berhasil diperbarui");
        return true;
      } else {
        print("❌ Update password gagal: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error updatePassword: $e");
      return false;
    }
  }


}
