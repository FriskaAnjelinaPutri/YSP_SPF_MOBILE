import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_absebsi/models/absensi_model.dart';
import 'package:apk_absebsi/models/absensi_history_model.dart';
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

  static Future<Map<String, dynamic>?> getTodayStatus(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/absensi/today-status'),
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

  static Future<AbsensiHistory?> getAbsensi(
    String token,
    String periode,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiService.baseUrl}/absensi/$periode'),
            headers: {
              'Authorization': 'Bearer $token',
              "Accept": "application/json",
            },
          )
          .timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 200 &&
          data != null &&
          data['success'] == true) {
        // Ambil summary dan data dari response
        final Map<String, dynamic> summary = data['summary'];
        final List<dynamic> listData = data['data'];

        // Konversi list data ke List<Absensi>
        final List<Absensi> history =
            listData.map((item) => Absensi.fromJson(item)).toList();

        // Return AbsensiHistory yang dibuat manual
        return AbsensiHistory(summary: summary, history: history);
      } else {
        print(
          "❌ Gagal ambil data absensi: ${response.statusCode} - ${data?['message'] ?? response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Error getAbsensi: $e");
      return null;
    }
  }

  static Future<Absensi?> getAbsensiDetail(String token, String tanggal) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/absensi/detail/$tanggal'),
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

  static Future<bool> checkIn(String token, double latitude, double longitude, String status, String? keterangan) async {
    try {
      final body = {
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'keterangan': keterangan,
      };

      if (keterangan != null && keterangan.isNotEmpty) {
        body['keterangan'] = keterangan;
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/absensi/check-in'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      final data = _parseJson(response.body);

      if (response.statusCode == 201) {
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

  static Future<bool> checkOut(String token, double latitude, double longitude) async {
    try {
      final body = {
        'latitude': latitude,
        'longitude': longitude,
      };
      
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/absensi/check-out'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode(body),
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
