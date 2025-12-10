import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_absebsi/models/absensi_model.dart';
import 'package:apk_absebsi/services/api_services.dart';

class AbsensiService {
  static dynamic _parseJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      print("⚠️ Error decode JSON: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getTodayStatus(String token, String karKode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/absensi/today-status?kar_kode=$karKode'),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 && data != null) {
        return data;
      } else {
        print("❌ Gagal ambil status hari ini: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error getTodayStatus: $e");
      return null;
    }
  }

  static Future<List<Absensi>?> getAbsensi(String token, String karKode, String periode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/absensi/$periode?kar_kode=$karKode'),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 && data != null) {
        final list = data['data'] as List;
        return list.map((item) => Absensi.fromJson(item)).toList();
      } else {
        print("❌ Gagal ambil data absensi: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error getAbsensi: $e");
      return null;
     }
  }

  static Future<Absensi?> getAbsensiDetail(String token, String karKode, String tanggal) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/absensi/detail/$tanggal?kar_kode=$karKode'),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 && data != null) {
        return Absensi.fromJson(data['data']);
      } else {
        print("❌ Gagal ambil detail absensi: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error getAbsensiDetail: $e");
      return null;
    }
  }

  static Future<bool> checkIn(String token, String karKode, double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/absensi/check-in'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode({
          'kar_kode': karKode,
          'latitude': latitude,
          'longitude': longitude,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200) {
        print("✅ Check-in berhasil: ${response.body}");
        return true;
      } else {
        print("❌ Gagal check-in: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error checkIn: $e");
      return false;
    }
  }

  static Future<bool> checkOut(String token, String karKode, double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/absensi/check-out'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode({
          'kar_kode': karKode,
          'latitude': latitude,
          'longitude': longitude,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200) {
        print("✅ Check-out berhasil: ${response.body}");
        return true;
      } else {
        print("❌ Gagal check-out: ${response.statusCode} - ${data?['message'] ?? response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error checkOut: $e");
      return false;
    }
  }
}
